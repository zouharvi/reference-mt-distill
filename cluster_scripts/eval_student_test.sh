#!/bin/bash

EXPERIMENTS=$1
for EXP in $EXPERIMENTS; do
    echo -en "\n"
    echo -en "$EXP csen "
    python3 -m sacrebleu "data/original/test.cs-en.en" --metrics bleu --score-only -i "data/student_test/$EXP/test.cs-en.en"
    echo -en "$EXP encs "
    python3 -m sacrebleu "data/original/test.cs-en.cs" --metrics bleu --score-only -i "data/student_test/$EXP/test.cs-en.cs"
    echo -en "$EXP ende "
    python3 -m sacrebleu "data/original/test.de-en.de" --metrics bleu --score-only -i "data/student_test/$EXP/test.de-en.de"
done