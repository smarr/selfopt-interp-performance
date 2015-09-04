#!/bin/sh
mkdir -p data
#rebench -f -d --scheduler=random --without-nice rebench.conf all
rebench -c -f -d --scheduler=random --without-nice rebench.conf SOMns-micro

REV=`git rev-parse HEAD | cut -c1-8`
TARGET_PATH=~/benchmark-results/somns-agere/$REV
mkdir -p $TARGET_PATH
cp data/* $TARGET_PATH/
