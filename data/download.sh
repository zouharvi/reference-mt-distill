#!/bin/bash

# run me from the data directory

wget -nc http://www.statmt.org/europarl/v10/training/europarl-v10.de-en.tsv.gz
wget -nc http://www.statmt.org/europarl/v10/training/europarl-v10.cs-en.tsv.gz

gunzip -k europarl-v10.de-en.tsv.gz
gunzip -k europarl-v10.cs-en.tsv.gz

mkdir -p original

cut -f1 europarl-v10.de-en.tsv > original/europarl.de-en.de
cut -f2 europarl-v10.de-en.tsv > original/europarl.de-en.en
cut -f1 europarl-v10.cs-en.tsv > original/europarl.cs-en.cs
cut -f2 europarl-v10.cs-en.tsv > original/europarl.cs-en.en

echo -e "\nDE-EN"
echo "de"
wc -l < original/europarl.de-en.de
echo "en"
wc -l < original/europarl.de-en.en

echo -e "\nCS-EN"
echo "cs"
wc -l < original/europarl.cs-en.cs
echo "en"
wc -l < original/europarl.cs-en.en