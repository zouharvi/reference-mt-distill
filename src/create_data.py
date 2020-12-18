#!/bin/python3

import file_utils
from extractor import top_k, atleast_k, aggregator

file_utils.load_process_save(
    'original/train.cs-en.en',
    'original/train.cs-en.cs',
    'teacher/train.cs-en.cs',
    aggregator(recipe=[
        (1, top_k(scorer=lambda x: x.score, k=1)),
        (1, atleast_k(scorer=lambda x: x.score, k=-0.1)),
    ]),
    'experiment/train.cs-en.en',
    'experiment/train.cs-en.cs',
    spm_model='models/teacher/csen/vocab.spm',
)
