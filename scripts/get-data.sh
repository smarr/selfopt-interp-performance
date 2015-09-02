#!/bin/bash
mkdir -p data
REV=`git rev-parse HEAD | cut -c1-8`
TARGET_PATH=benchmark-results/somns-agere/$REV
BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

scp 8:$TARGET_PATH/\*.data $BASE_DIR/../data/
ssh 8 'bash -s' < scripts/spec.sh >& $BASE_DIR/../data/spec.md
