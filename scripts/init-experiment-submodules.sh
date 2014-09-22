#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR/../implementations/
source script.inc

INFO Setup all TruffleSOM Experiments

cd TruffleSOM

BRANCH_PREFIX="mt-vs-pe"
PREFIX="T-"
REPO_URL="git@github.com:smarr/TruffleSOM.git"

git ls-remote --heads | grep $BRANCH_PREFIX | cut -c 53- | while read branch
do
  INFO Branch $branch
  shortName=${branch/${BRANCH_PREFIX}\//}
  cd $DIR/../
  EXP_NAME="implementations/$PREFIX$shortName"
  
  if [ ! -d "$EXP_NAME" ]; then
    INFO "Add submodule for $branch"
    git submodule add --force  $REPO_URL $EXP_NAME
    git submodule init $EXP_NAME
    git submodule update $EXP_NAME
    OK "Submodule added for $branch"
  fi
  
  INFO Update to latest version
  cd $EXP_NAME
  git fetch
  git checkout $branch
  OK "$branch updated"
done
