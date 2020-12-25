#!/bin/bash

# run me from the top directory

EXP=$1
LANGSOURCE=$2
LANG1=$3
LANG2=$4

mkdir -p models/experiment/$EXP/$LANG1$LANG2

marian \
    -m models/experiment/$EXP/$LANG1$LANG2/model.bin \
    -c models/experiment/config.yml \
    -t data/original/train.$LANGSOURCE.$LANG1 data/original/train.$LANGSOURCE.$LANG2 \
    -v models/experiment/$EXP/$LANG1$LANG2/vocab.spm models/experiment/$EXP/$LANG1$LANG2/vocab.spm \
    --valid-sets data/original/eval.$LANGSOURCE.$LANG1 data/original/eval.$LANGSOURCE.$LANG2 \
    --devices 0 1 2 3 \
    --sync-sgd \
    --valid-metrics bleu \
    --overwrite --keep-best \
    --early-stopping 20 \
    --shuffle-in-ram \
