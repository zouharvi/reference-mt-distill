#!/bin/bash

mkdir -p cluster_logs tmp

EXPERIMENTS=$1
for EXP in $EXPERIMENTS; do
    echo -en "\nExperiment data $EXP"
    read _
    echo -e "#!/bin/bash\npython3 src/create_data.py -r $EXP" > tmp/d.$EXP.sh
    qsub \
        -l mem_free=2G \
        -pe smp 2 \
        -cwd \
        -j y \
        -o ./cluster_logs/d.$EXP.csen.log \
        tmp/d.$EXP.sh
done