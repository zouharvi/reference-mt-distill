#!/bin/bash

mkdir -p data/teacher

marian-decoder \
    -m "models/teacher/ende/model.npz" \
    -v "models/teacher/ende/vocab.spm" "models/teacher/ende/vocab.spm" \
    -i "data/original/europarl.de-en.en" \
    -o "data/teacher/europarl.de-en.de" \
    --n-best \
    --normalize 1 \

marian-decoder \
    -m "models/teacher/ende/model.npz" \
    -v "models/teacher/ende/vocab.spm" "models/teacher/ende/vocab.spm" \
    -i "data/original/europarl.de-en.en" \
    -o "data/teacher/europarl.de-en.de.spm" \
    --n-best \
    --no-spm-decode \
    --normalize 1 \