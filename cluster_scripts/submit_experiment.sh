#!/bin/bash

mkdir -p cluster_logs

EXPERIMENTS=$1
for EXP in $EXPERIMENTS; do
    echo -e "\n\n\nExperiment $EXP, language cs-en, source: {train,eval}.cs-en.{cs,en}"
    read _
    echo -e "#!/bin/bash\ncluster_scripts/train_experiment.sh $EXP cs-en cs en" > .q.$EXP.csen.sh
    qsub \
        -q 'gpu*' \
        -l gpu=4,gpu_ram=3G \
        -pe smp 4 \
        -cwd \
        -j y \
        -o ./cluster_logs/$EXP.csen.log \
        .q.$EXP.csen.sh

    # echo -e "\n\n\nExperiment $EXP, language en-cs, source: {train,eval}.cs-en.{en,cs}"
    # read _
    # echo -e "#!/bin/bash\ncluster_scripts/train_experiment.sh $EXP cs-en en cs" > .q.$EXP.encs.sh
    # qsub \
    #     -q 'gpu*' \
    #     -l gpu=4,gpu_ram=3G \
    #     -pe smp 4 \
    #     -cwd \
    #     -j y \
    #     -o ./cluster_logs/$EXP.encs.log \
    #     .q.$EXP.encs.sh

    # echo -e "\n\n\nExperiment $EXP, language en-de, source: {train,eval}.de-en.{en,de}"
    # read _
    # echo -e "#!/bin/bash\ncluster_scripts/train_experiment.sh $EXP de-en en de" > .q.$EXP.ende.sh
    # qsub \
    #     -q 'gpu*' \
    #     -l gpu=4,gpu_ram=3G \
    #     -pe smp 4 \
    #     -cwd \
    #     -j y \
    #     -o ./cluster_logs/$EXP.ende.log \
    #     .q.$EXP.ende.sh
done