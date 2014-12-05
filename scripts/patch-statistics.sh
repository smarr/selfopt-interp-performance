#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DATA_CLOC=$DIR/../data/cloc.csv
DATA_PATCH=$DIR/../data/patch-stats.csv

cd $DIR/../implementations/
source script.inc

collect_stats() {
  BRANCH_PREFIX="$1"
  EXP_PREFIX="$2"
  VM="$3"

  # git ls-remote --heads
  git ls-remote . | grep $BRANCH_PREFIX | cut -c 62- | while read branch
  do
    INFO Branch $branch
    shortName=${branch/${BRANCH_PREFIX}\//}
    echo -ne "$VM,$shortName,\t\t" >> $DATA_PATCH
    echo -ne "$VM,$shortName,\t\t" >> $DATA_CLOC
    git diff --shortstat remotes/origin/$BRANCH_PREFIX/baseline..remotes/origin/$branch >> $DATA_PATCH
    ../../scripts/cloc --quiet --csv ../$EXP_PREFIX$shortName/src | tr -d '\n' >> $DATA_CLOC
    echo -e "" >> $DATA_CLOC
    
    if [[ "$BRANCH_PREFIX/baseline" == $branch ]]
    then
      echo -e "" >> $DATA_PATCH
    fi
  done
}

INFO "Collect patch-stats.txt for experiments"

# Clear files
echo "" > $DATA_PATCH
echo "VM,experiment,files,language,blank,comment,code" > $DATA_CLOC


cd TruffleSOM
collect_stats "mt-vs-pe" "T-" "TruffleSOM"

cd ../RTruffleSOM
collect_stats "mt-vs-pe" "R-" "RTruffleSOM"
