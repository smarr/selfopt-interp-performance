#!/bin/sh
mkdir -p data
#rebench -f -d --scheduler=random --without-nice rebench.conf all
#rebench -f -d --scheduler=random --without-nice rebench.conf SOMns-micro
rebench -c -f -d --scheduler=random --without-nice rebench.conf SOMns-jit
rebench -c -f -d --scheduler=random --without-nice rebench.conf Java

REV=`git rev-parse HEAD | cut -c1-8`
TARGET_PATH=~/benchmark-results/somns-agere/$REV
mkdir -p $TARGET_PATH
cp data/* $TARGET_PATH/
