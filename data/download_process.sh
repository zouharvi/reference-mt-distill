#!/bin/bash

# run me from the data directory

wget -nc http://www.statmt.org/europarl/v10/training/europarl-v10.de-en.tsv.gz
wget -nc http://www.statmt.org/europarl/v10/training/europarl-v10.cs-en.tsv.gz

gunzip -k europarl-v10.de-en.tsv.gz
gunzip -k europarl-v10.cs-en.tsv.gz
mkdir -p original

EVAL_COUNT=15000
EVAL_COUNT_DOUBLE=$(( 2 * $EVAL_COUNT))

# remove faulty long lines
# word count: 633, 668, 668
sed -i "1395584d;1681528d;1796262d;" europarl-v10.de-en.tsv


# randomly shuffle data
get_seeded_random()
{
  seed="$1"
  openssl enc -aes-256-ctr -pass pass:"$seed" -nosalt \
    </dev/zero 2>/dev/null
}
cp europarl-v10.cs-en.tsv tmp1
cp europarl-v10.de-en.tsv tmp2
shuf --random-source=<(get_seeded_random 64) tmp1 > europarl-v10.cs-en.tsv &
shuf --random-source=<(get_seeded_random 64) tmp2 > europarl-v10.de-en.tsv &
wait
rm tmp1 tmp2

# create train, eval and test datasets CSEN
head -n -$EVAL_COUNT_DOUBLE europarl-v10.cs-en.tsv | cut -f1 > original/train.cs-en.cs 
head -n -$EVAL_COUNT_DOUBLE europarl-v10.cs-en.tsv | cut -f2 > original/train.cs-en.en
tail -n +$EVAL_COUNT_DOUBLE europarl-v10.cs-en.tsv | head -n $EVAL_COUNT | cut -f1 > original/test.cs-en.cs
tail -n +$EVAL_COUNT_DOUBLE europarl-v10.cs-en.tsv | head -n $EVAL_COUNT | cut -f2 > original/test.cs-en.en  
tail -n $EVAL_COUNT europarl-v10.cs-en.tsv | cut -f1 > original/eval.cs-en.cs
tail -n $EVAL_COUNT europarl-v10.cs-en.tsv | cut -f2 > original/eval.cs-en.en

# create train, eval and test datasets DEEN
head -n -$EVAL_COUNT_DOUBLE europarl-v10.de-en.tsv | cut -f1 > original/train.de-en.de 
head -n -$EVAL_COUNT_DOUBLE europarl-v10.de-en.tsv | cut -f2 > original/train.de-en.en
tail -n +$EVAL_COUNT_DOUBLE europarl-v10.de-en.tsv | head -n $EVAL_COUNT | cut -f1 > original/test.de-en.de
tail -n +$EVAL_COUNT_DOUBLE europarl-v10.de-en.tsv | head -n $EVAL_COUNT | cut -f2 > original/test.de-en.en  
tail -n $EVAL_COUNT europarl-v10.de-en.tsv | cut -f1 > original/eval.de-en.de
tail -n $EVAL_COUNT europarl-v10.de-en.tsv | cut -f2 > original/eval.de-en.en

wc -l original/*