#!/bin/bash

# run me from the top directory

EXP=$1

mkdir -p data/teacher

marian-decoder \
    -m "models/experiment/$EXP/encs/model.bin.best-bleu.bin" \
    -v "models/experiment/$EXP/encs/vocab.spm" "models/teacher/encs/vocab.spm" \
    -i "data/original/test.cs-en.en" \
    -o "data/experiment/$EXP/test.cs-en.en" \
    --devices 0 1 2 3 \
    --quiet-translation \

marian-decoder \
    -m "models/experiment/$EXP/csen/model.bin.best-bleu.bin" \
    -v "models/experiment/$EXP/csen/vocab.spm" "models/experiment/$EXP/csen/vocab.spm" \
    -i "data/original/test.cs-en.cs" \
    -o "data/experiment/$EXP/test.cs-en.cs" \
    --devices 0 1 2 3 \
    --quiet-translation \
    
marian-decoder \
    -m "models/experiment/$EXP/ende/model.bin.best-bleu.bin" \
    -v "models/experiment/$EXP/ende/vocab.spm" "models/experiment/$EXP/ende/vocab.spm" \
    -i "data/original/test.de-en.en" \
    -o "data/experiment/$EXP/test.de-en.en" \
    --devices 0 1 2 3 \
    --quiet-translation \
