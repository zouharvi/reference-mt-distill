#!/bin/bash

# run me from the data directory

CROP=10

cp -r original original_backup

# crop train datasets
head -n $CROP original/train.cs-en.cs > tmp && mv tmp original/train.cs-en.cs 
head -n $CROP original/train.cs-en.en > tmp && mv tmp original/train.cs-en.en 
head -n $CROP original/train.de-en.de > tmp && mv tmp original/train.de-en.de 
head -n $CROP original/train.de-en.en > tmp && mv tmp original/train.de-en.en 
