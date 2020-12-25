#!/bin/bash

EXPERIMENTS=$1
for EXP in $EXPERIMENTS; do
    rm -r models/experiment/$EXP
    rm cluster_logs/$EXP*.log
done