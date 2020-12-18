#!/bin/bash

# run me from the top directory

mkdir -p data/teacher

marian-decoder \
    -m "models/teacher/ende/model.npz" \
    -v "models/teacher/ende/vocab.spm" "models/teacher/ende/vocab.spm" \
    -i "data/original/europarl.de-en.en" \
    -o "data/teacher/europarl.de-en.de" \
    --devices 0 1 2 3 4 5 \
    --n-best \
    --no-spm-decode \
    --normalize 1 \
    --quiet-translation \

marian-decoder \
    -m "models/teacher/encs/model.bin" \
    -v "models/teacher/encs/vocab.spm" "models/teacher/encs/vocab.spm" \
    -i "data/original/europarl.cs-en.en" \
    -o "data/teacher/europarl.cs-en.cs" \
    --devices 0 1 2 3 4 5 \
    --n-best \
    --no-spm-decode \
    --normalize 1 \
    --quiet-translation \

marian-decoder \
    -m "models/teacher/csen/model.bin" \
    -v "models/teacher/csen/vocab.spm" "models/teacher/csen/vocab.spm" \
    -i "data/original/europarl.cs-en.cs" \
    -o "data/teacher/europarl.cs-en.en" \
    --devices 0 1 2 3 4 5 \
    --n-best \
    --no-spm-decode \
    --normalize 1 \
    --quiet-translation \