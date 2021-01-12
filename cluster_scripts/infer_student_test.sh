#!/bin/bash
# run me from the top directory

EXP=$1

function getmodel {
    FILE="models/experiment/$2/$1"
    if [ -d $FILE ]; then
        echo $FILE
    fi
    FILE="/lnet/tspec/work/people/zouhar/reference-mt-distill/models_exp/$2/$1"
    if [ -d $FILE ]; then
        echo $FILE
    fi
    return 1
}

mkdir -p "data/student_test/$EXP"
rm -f "data/student_test/$EXP/test.cs-en.cs"
rm -f "data/student_test/$EXP/test.cs-en.en"
rm -f "data/student_test/$EXP/test.de-en.de"

MODEL_PREFIX=$(getmodel "encs" $EXP)
marian-decoder \
    -m "$MODEL_PREFIX/model.bin.best-bleu.bin" \
    -v "$MODEL_PREFIX/vocab.spm" "$MODEL_PREFIX/vocab.spm" \
    -c "$MODEL_PREFIX/model.bin.best-bleu.bin.decoder.yml" \
    -i "~/.sacrebleu/wmt20/cs-en.en" \
    -o "data/student_test/$EXP/wmt.cs-en.cs" \
    --devices 0 \
    --quiet-translation \

MODEL_PREFIX=$(getmodel "csen" $EXP)
marian-decoder \
    -m "$MODEL_PREFIX/model.bin.best-bleu.bin" \
    -v "$MODEL_PREFIX/vocab.spm" "$MODEL_PREFIX/vocab.spm" \
    -c "$MODEL_PREFIX/model.bin.best-bleu.bin.decoder.yml" \
    -i "~/.sacrebleu/wmt20/cs-en.cs" \
    -o "data/student_test/$EXP/wmt.cs-en.en" \
    --devices 0 \
    --quiet-translation \

MODEL_PREFIX=$(getmodel "ende" $EXP)
marian-decoder \
    -m "$MODEL_PREFIX/model.bin.best-bleu.bin" \
    -v "$MODEL_PREFIX/vocab.spm" "$MODEL_PREFIX/vocab.spm" \
    -c "$MODEL_PREFIX/model.bin.best-bleu.bin.decoder.yml" \
    -i "~/.sacrebleu/wmt20/de-en.en" \
    -o "data/student_test/$EXP/wmt.de-en.de" \
    --devices 0 \
    --quiet-translation \