#!/bin/bash

EXPERIMENTS=$1
for EXP in $EXPERIMENTS; do
    echo -en "\n\nInfer $EXP"
    echo -en "\n$EXP csen "
    python3 -m sacrebleu "data/original/test.cs-en.en" --metrics bleu --score-only -i "data/experiment/$EXP/test.cs-en.en"
    echo -en "\n$EXP encs "
    python3 -m sacrebleu "data/original/test.cs-en.cs" --metrics bleu --score-only -i "data/experiment/$EXP/test.cs-en.cs"
    echo -en "\n$EXP ende "
    python3 -m sacrebleu "data/original/test.cs-en.de" --metrics bleu --score-only -i "data/experiment/$EXP/test.cs-en.de"
done