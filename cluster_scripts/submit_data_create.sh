#!/bin/bash

mkdir -p cluster_logs tmp

EXPERIMENTS=$1
LANGS=$2
for EXP in $EXPERIMENTS; do
for LANG in $LANGS; do
    echo -en "\nExperiment data $EXP for $LANG"
    read _
    echo -e "#!/bin/bash\npython3 src/create_data.py -r $EXP -l $LANG" > tmp/d.$EXP.$LANG.sh
    qsub \
        -l mem_free=2G \
        -pe smp 2 \
        -cwd \
        -j y \
        -o ./cluster_logs/d.$EXP.$LANG.csen.log \
        tmp/d.$EXP.$LANG.sh
done
done