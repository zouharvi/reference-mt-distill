#!/bin/bash

EXPERIMENTS=$1
for EXP in $EXPERIMENTS; do
    echo -en "\nInfer $EXP"
    read _
    echo -e "#!/bin/bash\n./cluster_scripts/infer_student_test.sh $EXP" > tmp/i.$EXP.sh
    qsub \
        -l gpu=1,gpu_ram=1G \
        -pe smp 2 \
        -cwd \
        -j y \
        -o ./cluster_logs/i.$EXP.log \
        tmp/i.$EXP.sh
done