#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR/../implementations/
source script.inc

collect_stats() {
  BRANCH_PREFIX="$1"
  EXP_PREFIX="$2"

  # Clear files
  echo "" > patch-stats.txt 
  echo "" > cloc.txt

  # git ls-remote --heads
  git ls-remote . | grep $BRANCH_PREFIX | cut -c 62- | while read branch
  do
    INFO Branch $branch
    shortName=${branch/${BRANCH_PREFIX}\//}
    echo -ne "$shortName:\t\t" >> patch-stats.txt
    echo -ne "$shortName:\t\t" >> cloc.txt
    git diff --shortstat remotes/origin/$BRANCH_PREFIX/baseline..remotes/origin/$branch >> patch-stats.txt
    ../../scripts/cloc --quiet --csv ../$EXP_PREFIX$shortName/src >> cloc.txt
  done
}

INFO "Collect patch-stats.txt for experiments"

cd TruffleSOM
collect_stats "mt-vs-pe" "T-"

cd ../RTruffleSOM
collect_stats "mt-vs-pe" "R-"
