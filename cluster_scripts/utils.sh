alias quota2='/opt/mfutils/mgmt quota | grep -E "lnet/spec|net/tspec"'

function qstat2 {
        qstat -xml | tr '\n' ' ' | sed 's#<job_list[^>]*>#\n#g'   | sed 's#<[^>]*>##g' | grep " " | column -t
}
function qstat3 {
        qstat2
        qstat | tail -n +3 | wc -l | tr '\n' ' '
        echo -n "d"
        qstat | tail -n +3 | grep ' d\.' | wc -l | tr '\n' ' '
        echo -n "e"
        qstat | tail -n +3 | grep ' e\.' | wc -l | tr '\n' ' '
        echo -n "i"
        qstat | tail -n +3 | grep ' i\.' | wc -l | tr '\n' ' '
        echo ""
}

function bleu {
        tail -n 100 $1 | grep -aE "valid.*Ep.*bleu" | tail -n 3 | sed 's/\[valid\] //'
}
function bleu2 {
        for f in $(qstat2 | grep -Eo "\\se.[a-z][0-9][a-z]*.[a-z]{2,4}" | grep -Eo "[a-z][0-9][a-z]*.[a-z]{2,4}"); do
                echo -e "$f"
                bleu ./cluster_logs/$f.log
        done
}
