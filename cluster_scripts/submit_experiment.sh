#!/bin/bash

confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:- [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

mkdir -p cluster_logs tmp

EXPERIMENTS=$1
for EXP in $EXPERIMENTS; do
    echo -en "\nExperiment $EXP, language cs-en, source: {train,eval}.cs-en.{cs,en}"
    echo -e "#!/bin/bash\ncluster_scripts/train_experiment.sh $EXP cs-en cs en" > tmp/e.$EXP.csen.sh
    confirm && qsub \
        -q 'gpu*' \
        -l gpu=6,gpu_ram=4G \
        -pe smp 6 \
        -cwd \
        -j y \
        -o ./cluster_logs/$EXP.csen.log \
        tmp/e.$EXP.csen.sh

    echo -en "\nExperiment $EXP, language en-cs, source: {train,eval}.cs-en.{en,cs}"
    echo -e "#!/bin/bash\ncluster_scripts/train_experiment.sh $EXP cs-en en cs" > tmp/e.$EXP.encs.sh
    confirm && qsub \
        -q 'gpu*' \
        -l gpu=6,gpu_ram=4G \
        -pe smp 6 \
        -cwd \
        -j y \
        -o ./cluster_logs/$EXP.encs.log \
        tmp/e.$EXP.encs.sh

    echo -en "\nExperiment $EXP, language en-de, source: {train,eval}.de-en.{en,de}"
    echo -e "#!/bin/bash\ncluster_scripts/train_experiment.sh $EXP de-en en de" > tmp/e.$EXP.ende.sh
    confirm && qsub \
        -q 'gpu*' \
        -l gpu=6,gpu_ram=4G \
        -pe smp 6 \
        -cwd \
        -j y \
        -o ./cluster_logs/$EXP.ende.log \
        tmp/e.$EXP.ende.sh
done