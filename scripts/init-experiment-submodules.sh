#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR/../implementations/
source script.inc

create_submodules_for_experiments() {
  REPO_URL="$1"
  BRANCH_PREFIX="$2"
  PREFIX="$3"
  
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
    git reset --hard origin/$branch
    OK "$branch updated"
  done
}

INFO Setup all TruffleSOM Experiments

cd TruffleSOM
create_submodules_for_experiments "https://github.com/smarr/TruffleSOM.git" "mt-vs-pe" "T-"

cd ../RTruffleSOM
create_submodules_for_experiments "https://github.com/smarr/RTruffleSOM.git" "mt-vs-pe" "R-"
