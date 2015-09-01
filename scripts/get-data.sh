#!/bin/bash
mkdir -p data
scp 8:Projects/RoarVM-buildslave/selfopt-interp-performance/build/data/*.data data/
ssh 8 'bash -s' < scripts/spec.sh >& data/spec.md
