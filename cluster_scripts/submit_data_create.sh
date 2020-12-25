#!/bin/bash

mkdir -p cluster_logs

EXPERIMENTS=$1
for EXP in $EXPERIMENTS; do
    echo "Experiment data $EXP"
    read _
    echo -e "#!/bin/bash\npython3 src/create_data.py -r $EXP" > .d.$EXP.sh
    qsub \
        -l mem_free=2G \
        -pe smp 2 \
        -cwd \
        -j y \
        -o ./cluster_logs/d.$EXP.csen.log \
        .d.$EXP.sh
done