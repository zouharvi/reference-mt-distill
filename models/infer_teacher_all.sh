#!/bin/bash

mkdir -p data/teacher

marian-decoder \
    -m "models/teacher/ende/model.npz" \
    -v "models/teacher/ende/vocab.spm" "models/teacher/ende/vocab.spm" \
    -i "data/original/europarl.de-en.en" \
    -o "data/teacher/europarl.de-en.de" \
    --n-best \
    --no-spm-decode \
    --normalize 1 \

marian-decoder \
    -m "models/teacher/encs/model.npz" \
    -v "models/teacher/encs/vocab.spm" "models/teacher/encs/vocab.spm" \
    -i "data/original/europarl.cs-en.en" \
    -o "data/teacher/europarl.cs-en.cs" \
    --n-best \
    --no-spm-decode \
    --normalize 1 \

marian-decoder \
    -m "models/teacher/csen/model.npz" \
    -v "models/teacher/csen/vocab.spm" "models/teacher/csen/vocab.spm" \
    -i "data/original/europarl.cs-en.cs" \
    -o "data/teacher/europarl.cs-en.en" \
    --n-best \
    --no-spm-decode \
    --normalize 1 \