#!/bin/python3

import file_utils
from extractor import top_k, atleast_k

file_utils.load_process_save(
    'original/train.cs-en.en',
    'original/train.cs-en.cs',
    'teacher/train.cs-en.cs',
    # top_k(scorer=lambda x: x.score, k=3),
    atleast_k(scorer=lambda x: x.score, k=-0.1),
    'experiment/train.cs-en.en',
    'experiment/train.cs-en.cs',
    spm_model='models/teacher/csen/vocab.spm',
)