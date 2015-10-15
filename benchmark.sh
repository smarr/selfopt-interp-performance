#!/bin/sh
mkdir -p data
#rebench -f -d --scheduler=random --without-nice rebench.conf all
#rebench -f -d --scheduler=random --without-nice rebench.conf SOMns-micro
rebench -f -d --scheduler=random --without-nice rebench.conf SOMns-jit
rebench -f -d --scheduler=random --without-nice rebench.conf Java

DATA_ROOT=~/benchmark-results/somns-agere

NUM_PREV=`ls -l | grep ^d | wc -l`
NUM_PREV=`printf "%03d" $NUM_PREV`

REV=`git rev-parse HEAD | cut -c1-8`
TARGET_PATH=$DATA_ROOT/$NUM_PREV-$REV
mkdir -p $TARGET_PATH
cp data/* $TARGET_PATH/
