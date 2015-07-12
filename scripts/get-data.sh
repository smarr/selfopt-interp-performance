#!/bin/bash
mkdir -p data
cd data

scp 8:Projects/COMPARE-TRACE-EVAL/data/*.data .
ssh 8 'bash -s' < ../scripts/spec.sh >& spec.md

bzip2 *.data
