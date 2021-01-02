#!/bin/python3

"""
Creates new training data for all language directions (META_LANGS) according to META_RECIPES.
This may take some time, but is written in a functional way, so the files are not loaded into memory
in larger pieces.
"""


import file_utils
from extractor import *
from recipes import META_RECIPES
import os
import argparse

parser = argparse.ArgumentParser(description='Create experiment datasets')
parser.add_argument('-r', '--recipes', nargs='+',
                    help='Recipes', required=True)
parser.add_argument('-l', '--langs', nargs='+',
                    help='Languages', required=True)
args = parser.parse_args()
args.recipes = set(args.recipes)

META_LANGS = {
    'csen': 'cs-en',
    'encs': 'cs-en',
    'ende': 'de-en',
}

for lpairtrue, lpairorig in META_LANGS.items():
    if not lpairtrue in args.langs:
        continue
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
