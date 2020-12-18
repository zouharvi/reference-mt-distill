#!/bin/bash

# run me from the top directory



mkdir -p models/student/base/csen

marian \
    -m models/student/base/csen/model.bin \
    -c models/student/config.yml \
    -t data/original/train.cs-en.cs data/original/train.cs-en.en \
    -v models/student/base/csen/vocab.spm models/student/base/csen/vocab.spm \
    --valid-sets data/original/eval.cs-en.cs data/original/eval.cs-en.en \
    --keep-best \