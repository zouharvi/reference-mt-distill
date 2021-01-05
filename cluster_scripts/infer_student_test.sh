#!/bin/bash

# run me from the top directory

EXP=$1

function getmodel {
    FILE="models/experiment/$2/$1/model.bin.best-bleu.bin"
    if [ -f $FILE ]; then
        echo $FILE
        return 0
    fi
    FILE="~/tspec/reference-mt-distill/models/experiment/$2/$1/model.bin.best-bleu.bin"
    if [ -f $FILE ]; then
        echo $FILE
        return 0
    fi
    return 1
}

MODEL=$(getmodel "encs" $EXP)
echo "found $MODEL"
# marian-decoder \
#     -m $MODEL \
#     -v "models/experiment/$EXP/encs/vocab.spm" "models/experiment/$EXP/encs/vocab.spm" \
#     -i "data/original/test.cs-en.en" \
#     -o "data/experiment/$EXP/test.cs-en.cs" \
#     --devices 0 \
#     --quiet-translation \

MODEL=$(getmodel "csen" $EXP)
echo "found $MODEL"
# marian-decoder \
#     -m "models/experiment/$EXP/csen/model.bin.best-bleu.bin" \
#     -v "models/experiment/$EXP/csen/vocab.spm" "models/experiment/$EXP/csen/vocab.spm" \
#     -i "data/original/test.cs-en.cs" \
#     -o "data/experiment/$EXP/test.cs-en.en" \
#     --devices 0 \
#     --quiet-translation \
    
MODEL=$(getmodel "ende" $EXP)
echo "found $MODEL"
# marian-decoder \
#     -m "models/experiment/$EXP/ende/model.bin.best-bleu.bin" \
#     -v "models/experiment/$EXP/ende/vocab.spm" "models/experiment/$EXP/ende/vocab.spm" \
#     -i "data/original/test.de-en.en" \
#     -o "data/experiment/$EXP/test.de-en.de" \
#     --devices 0 \
#     --quiet-translation \
