#!/bin/sh
mkdir -p data
rebench -d --scheduler=random --without-nice rebench.conf all
