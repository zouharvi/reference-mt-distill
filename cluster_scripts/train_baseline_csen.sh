#!/bin/bash

# run me from the top directory

mkdir -p models/student/baseline/csen/b1

marian \
    -m models/student/baseline/csen/b1/model.bin \
    -c models/student/config.yml \
    -t data/original/train.cs-en.cs data/original/train.cs-en.en \
    -v models/student/baseline/csen/b1/vocab.spm models/student/baseline/csen/b1/vocab.spm \
    --valid-sets data/original/eval.cs-en.cs data/original/eval.cs-en.en \
    --devices 0 1 2 3 \
    --valid-metrics bleu \
    --overwrite \
    --keep-best \
    --early-stopping 10 \
