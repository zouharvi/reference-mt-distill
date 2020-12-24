#!/bin/python3

"""
Creates new training data for all language directions (META_LANGS) according to META_RECIPES.
This may take some time, but is written in a functional way, so the files are not loaded into memory
in larger pieces.
"""


import file_utils
from extractor import top_k, atleast_k, original, aggregator
import os

META_LANGS = [
    ('cs-en', 'csen'),
    ('cs-en', 'encs'),
    ('de-en', 'ende'),
]

# forig:     folder with train.LPAIRORIG.LSRC and train.LPAIRORIG.LTGT
# ftrans:    translated target language by the teacher
# fnew:      folder where train.LPAIRORIG.LSRC and train.LPAIRORIG.LTGT will be placed
# spm_model: path to sentence piece model
# generator_partial: new data generator
# every recipe is a tuple of number of repetitions and a generator
# examples:
# (1, original()),
# (5, top_k(scorer=lambda x: x.score, k=1)),
# (1, atleast_k(scorer=lambda x: x.score, k=-0.1)),

META_RECIPES = [
    {
        'forig': 'original',
        'ftrans': 'teacher/train.LPAIRORIG.LTGT',
        'fnew': 'experiment/b1/LPAIRTRUE',
        'spm_model': 'models/teacher/LPAIRTRUE/vocab.spm',
        'generator_partial': aggregator(recipe=[
            (1, original()),
        ]),
    },
    {
        'forig': 'original',
        'ftrans': 'teacher/train.LPAIRORIG.LTGT',
        'fnew': 'experiment/b2/LPAIRTRUE',
        'spm_model': 'models/teacher/LPAIRTRUE/vocab.spm',
        'generator_partial': aggregator(recipe=[
            (1, top_k(scorer=lambda x: x.score, k=1)),
        ]),
    },
    {
        'forig': 'original',
        'ftrans': 'teacher/train.LPAIRORIG.LTGT',
        'fnew': 'experiment/b3/LPAIRTRUE',
        'spm_model': 'models/teacher/LPAIRTRUE/vocab.spm',
        'generator_partial': aggregator(recipe=[
            (1, atleast_k(scorer=lambda x: x.score, k=-np.inf)),
        ]),
    },
]

for lpairorig, lpairtrue in META_LANGS:
    lsrc = lpairtrue[:2]
    ltgt = lpairtrue[2:]
    for recipe_i, meta_recipe in enumerate(META_RECIPES):
        print(f'Processing recipe #{recipe_i} for {lpairtrue}')

        # replace capital variables in the recipe
        meta_recipe = {
            k: (
                v.replace('LPAIRTRUE', lpairtrue).replace('LPAIRORIG', lpairorig).
                replace('LSRC',  lsrc).replace('LTGT', ltgt)
                if isinstance(v, str) else v
            )
            for k, v in meta_recipe.items()
        }

        # create new keys and delete the old ones
        meta_recipe['fsrc'] = f'{meta_recipe["forig"]}/train.{lpairorig}.{lsrc}'
        meta_recipe['ftgt'] = f'{meta_recipe["forig"]}/train.{lpairorig}.{ltgt}'
        del meta_recipe["forig"]
        meta_recipe['fnew_src'] = f'{meta_recipe["fnew"]}/train.{lpairorig}.{lsrc}'
        meta_recipe['fnew_tgt'] = f'{meta_recipe["fnew"]}/train.{lpairorig}.{ltgt}'
        del meta_recipe["fnew"]

        # run the job
        file_utils.load_process_save(**meta_recipe)
