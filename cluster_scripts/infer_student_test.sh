#!/bin/bash
# run me from the top directory

EXP=$1

function getmodel {
    FILE="models/experiment/$2/$1"
    if [ -d $FILE ]; then
        cp "$FILE/model.bin.best-bleu.bin" /tmp/student.$2.bin
        cp "$FILE/vocab.spm" /tmp/student.$2.spm
        echo $FILE
    fi
    FILE="/lnet/tspec/work/people/zouhar/reference-mt-distill/models_exp/$2/$1"
    if [ -d $FILE ]; then
        cp "$FILE/model.bin.best-bleu.bin" /tmp/student.$2.bin
        cp "$FILE/vocab.spm" /tmp/student.$2.spm
        echo $FILE
    fi
    return 1
}

MODEL_PREFIX=$(getmodel "encs" $EXP)
marian-decoder \
    -m "/tmp/student.$EXP.bin" \
    -v "/tmp/student.$EXP.spm" "/tmp/student.$EXP.spm" \
    -i "data/original/test.cs-en.en" \
    -o "data/experiment/$EXP/test.cs-en.cs" \
    --devices 0 \
    --quiet-translation \

MODEL=$(getmodel "csen" $EXP)
marian-decoder \
    -m "/tmp/student.$EXP.bin" \
    -v "/tmp/student.$EXP.spm" "/tmp/student.$EXP.spm" \
    -i "data/original/test.cs-en.cs" \
    -o "data/experiment/$EXP/test.cs-en.en" \
    --devices 0 \
    --quiet-translation \

MODEL=$(getmodel "ende" $EXP)
marian-decoder \
    -m "/tmp/student.$EXP.bin" \
    -v "/tmp/student.$EXP.spm" "/tmp/student.$EXP.spm" \
    -i "data/original/test.de-en.en" \
    -o "data/experiment/$EXP/test.de-en.de" \
    --devices 0 \
    --quiet-translation \

rm /tmp/student.$EXP.bin
rm /tmp/student.$EXP.spm