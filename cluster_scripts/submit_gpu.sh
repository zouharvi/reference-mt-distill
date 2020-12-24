#!/bin/bash

mkdir -p cluster_logs

EXPERIMENTS=$1
for EXP in $EXPERIMENTS; do
    echo "Experiment $EXP, language cs-en, source: {train,eval}.cs-en.{cs,en}"
    read _
    qsubmit \
        -q 'gpu*' \
        -l gpu=4,gpu_ram=3G \
        -pe smp 4 \
        -cwd \
        -o ./cluster_logs/$EXP.csen.olog \
        -e ./cluster_logs/$EXP.csen.elog \
        "cluster_scripts/train_experiment.sh $EXP cs-en cs en"

    echo "Experiment $EXP, language en-cs, source: {train,eval}.cs-en.{en,cs}"
    read _
    qsubmit \
        -q 'gpu*' \
        -l gpu=4,gpu_ram=3G \
        -pe smp 4 \
        -cwd \
        -o ./cluster_logs/$EXP.encs.olog \
        -e ./cluster_logs/$EXP.encs.elog \
        "cluster_scripts/train_experiment.sh $EXP cs-en en cs"

    echo "Experiment $EXP, language en-de, source: {train,eval}.de-en.{en,de}"
    read _
    qsubmit \
        -q 'gpu*' \
        -l gpu=4,gpu_ram=3G \
        -pe smp 4 \
        -cwd \
        -o ./cluster_logs/$EXP.ende.olog \
        -e ./cluster_logs/$EXP.ende.elog \
        "cluster_scripts/train_experiment.sh $EXP de-en en de"
done