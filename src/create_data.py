#!/bin/python3

"""
Creates new training data for all language directions (META_LANGS) according to META_RECIPES.
This may take some time, but is written in a functional way, so the files are not loaded into memory
in larger pieces.
"""


import file_utils
from extractor import top_k, top_kth, atleast, original, aggregator
import os
import argparse

parser = argparse.ArgumentParser(description='Create experiment datasets')
parser.add_argument('-r','--recipes', nargs='+', help='Recipes', required=True)
args = parser.parse_args()
args.recipes = set(args.recipes)

META_LANGS = [
    ('cs-en', 'csen'),
    ('cs-en', 'encs'),
    ('de-en', 'ende'),
]

# every recipe is a tuple of number of repetitions and a generator
# examples:
# (1, original()),
# (5, top_k(scorer=lambda x: x.score, k=1)),
# (1, atleast(scorer=lambda x: x.score, threshold=-0.1)),

META_RECIPES = {
    'b1': aggregator(recipe=[
        (1, original()),
    ]),
    'b2': aggregator(recipe=[
        (1, top_kth(scorer=lambda x: x.score, k=1)),
    ]),
    'b3': aggregator(recipe=[
        (1, top_k(scorer=lambda x: x.score, k=12)),
    ]),
    'm1': aggregator(recipe=[
        (1, top_k(scorer=lambda x: x.bleu(), k=1)),
    ]),
    'm2': aggregator(recipe=[
        (1, top_k(scorer=lambda x: x.ter(), k=1)),
    ]),
    'm3': aggregator(recipe=[
        (1, top_k(scorer=lambda x: x.spm_diff(), k=1)),
    ]),
    'g1': aggregator(recipe=[
        (1, atleast(scorer=lambda x: x.bleu(), threshold=65)),
    ]),
    'g2': aggregator(recipe=[
        (1, atleast(scorer=lambda x: x.chrf(), threshold=0.8)),
    ]),
    'g3': aggregator(recipe=[
        (1, atleast(scorer=lambda x: x.spm_diff(), threshold=-7)),
    ]),
}

for lpairorig, lpairtrue in META_LANGS:
    lsrc = lpairtrue[:2]
    ltgt = lpairtrue[2:]
    for meta_recipe_name, meta_recipe_generator in META_RECIPES.items():
        if not meta_recipe_name in args.recipes:
            continue
        print(f'Processing recipe #{meta_recipe_name} for {lpairtrue}')

        meta_recipe = {}
        meta_recipe['generator_partial'] = meta_recipe_generator

        meta_recipe['ftrans'] = f'teacher/train.{lpairorig}.{ltgt}'
        meta_recipe['spm_model'] = f'models/teacher/{lpairtrue}/vocab.spm'

        # create new keys and delete the old ones
        meta_recipe['fsrc'] = f'original/train.{lpairorig}.{lsrc}'
        meta_recipe['ftgt'] = f'original/train.{lpairorig}.{ltgt}'
        meta_recipe['fnew_src'] = f'experiment/{meta_recipe_name}/{lpairtrue}/train.{lpairorig}.{lsrc}'
        meta_recipe['fnew_tgt'] = f'experiment/{meta_recipe_name}/{lpairtrue}/train.{lpairorig}.{ltgt}'

        # run the job
        file_utils.load_process_save(**meta_recipe)
