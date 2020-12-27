#!/bin/bash

# run me from the top directory

mkdir -p data/teacher

marian-decoder \
    -m "models/teacher/encs/model.bin" \
    -v "models/teacher/encs/vocab.spm" "models/teacher/encs/vocab.spm" \
    -i "~/.sacrebleu/wmt20/cs-en.en" \
    -o "data/teacher/wmt20.cs-en.cs" \
    --devices 0 1 2 3 4 5 \
    --quiet-translation \

marian-decoder \
    -m "models/teacher/csen/model.bin" \
    -v "models/teacher/csen/vocab.spm" "models/teacher/csen/vocab.spm" \
    -i "~/.sacrebleu/wmt20/cs-en.cs" \
    -o "data/teacher/wmt20.cs-en.en" \
    --devices 0 1 2 3 4 5 \
    --quiet-translation \
    
marian-decoder \
    -m "models/teacher/ende/model.npz" \
    -v "models/teacher/ende/vocab.spm" "models/teacher/ende/vocab.spm" \
    -i "~/.sacrebleu/wmt20/de-en.en" \
    -o "data/teacher/wmt20.de-en.de" \
    --devices 0 1 2 3 4 5 \
    --quiet-translation \
