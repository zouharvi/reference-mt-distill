#!/bin/bash

mkdir -p cluster_logs tmp

EXPERIMENTS=$1
for EXP in $EXPERIMENTS; do
    echo -en "\nExperiment $EXP, language cs-en, source: {train,eval}.cs-en.{cs,en}"
    read _
    echo -e "#!/bin/bash\ncluster_scripts/train_experiment.sh $EXP cs-en cs en" > tmp/q.$EXP.csen.sh
    qsub \
        -q 'gpu*' \
        -l gpu=4,gpu_ram=3G \
        -pe smp 4 \
        -cwd \
        -j y \
        -o ./cluster_logs/$EXP.csen.log \
        tmp/q.$EXP.csen.sh

    echo -en "\nExperiment $EXP, language en-cs, source: {train,eval}.cs-en.{en,cs}"
    read _
    echo -e "#!/bin/bash\ncluster_scripts/train_experiment.sh $EXP cs-en en cs" > tmp/q.$EXP.encs.sh
    qsub \
        -q 'gpu*' \
        -l gpu=4,gpu_ram=3G \
        -pe smp 4 \
        -cwd \
        -j y \
        -o ./cluster_logs/$EXP.encs.log \
        tmp/q.$EXP.encs.sh

    echo -en "\nExperiment $EXP, language en-de, source: {train,eval}.de-en.{en,de}"
    read _
    echo -e "#!/bin/bash\ncluster_scripts/train_experiment.sh $EXP de-en en de" > tmp/q.$EXP.ende.sh
    qsub \
        -q 'gpu*' \
        -l gpu=4,gpu_ram=3G \
        -pe smp 4 \
        -cwd \
        -j y \
        -o ./cluster_logs/$EXP.ende.log \
        tmp/q.$EXP.ende.sh
done