#!/bin/sh
mkdir -p data
export GRAAL_HOME=/home/smarr/Projects/graal/jvmci
#rebench -f -d --scheduler=random --without-nice rebench.conf all
#rebench -f -d --scheduler=random --without-nice rebench.conf Savina
rebench -f -d --scheduler=random --without-nice rebench.conf SOMns-actor
rebench -f -d --scheduler=random --without-nice rebench.conf SOMns-micro
#rebench -f -d --scheduler=random --without-nice rebench.conf SOMns-jit
#rebench -f -d --scheduler=random --without-nice rebench.conf Java

DATA_ROOT=~/benchmark-results/somns-agere

NUM_PREV=`ls -l $DATA_ROOT | grep ^d | wc -l`
NUM_PREV=`printf "%03d" $NUM_PREV`

REV=`git rev-parse HEAD | cut -c1-8`
TARGET_PATH=$DATA_ROOT/$NUM_PREV-$REV
mkdir -p $TARGET_PATH
cp data/* $TARGET_PATH/
