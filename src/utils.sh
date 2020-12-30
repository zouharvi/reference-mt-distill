#!/bin/bash

# utils for experiment management

alias qstat2='qstat && qstat | tail -n +3 | wc -l'
alias quota2='/opt/mfutils/mgmt quota | grep -E "lnet/spec|net/tspec"'

function bleu {
        grep -aE "valid.*Ep.*bleu" $1 | tail -n 3
}

function bleu2 {
        for f in $(qstat | grep -Eo "\\se.[a-z][0-9].[a-z]{4}" | grep -Eo "[a-z][0-9].[a-z]{4}"); do
                echo -e "$f"
                bleu ./cluster_logs/$f.log
        done
}
