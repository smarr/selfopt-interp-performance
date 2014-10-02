#!/bin/bash
scp 8:Projects/COMPARE-TRACE-EVAL/data/*.data data/
ssh 8 'bash -s' < scripts/spec.sh >& data/spec.md
