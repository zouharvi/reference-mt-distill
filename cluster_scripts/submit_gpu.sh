#!/bin/bash

mkdir -p cluster_logs

filename=$(basename -- "$1")
filename="${filename%.*}"

qsub \
    -q 'gpu*' \
    -l gpu=4,gpu_ram=3G \
    -pe smp 4 \
    -cwd \
    -o ./cluster_logs/$filename.olog \
    -e ./cluster_logs/$filename.elog \
    cluster_scripts/$filename.sh