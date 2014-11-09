#!/bin/bash

source ./script.inc
source ./config.inc

PAR_JOBS=8
declare -a job_pids

enq_job() {
  elm=$1
  job_pids=("${job_pids[@]}" "$elm")
}

deq_job() {
  dequed_job=${job_pids[0]}
  unset job_pids[0]
  job_pids=("${job_pids[@]}")
}


build_branch() {
  exp="$1"
  INFO Build RTruffleSOM $exp
  
  cd $exp
  get_pypy
  git submodule init
  git submodule update
  
  make clean > /dev/null
  make RTruffleSOM-jit || {
    ERR Build of $exp failed.
    exit 1
  }
  make RTruffleSOM-no-jit || {
    ERR Build of $exp failed.
    exit 1
  }
  cd ..
  OK RTruffleSOM $exp Build Completed.
}

build_branch "RTruffleSOM" &
enq_job $!

((PAR_JOBS--))

for exp in $( ls -d R-* ); do
  build_branch "$exp" &
  enq_job $!
  ((PAR_JOBS--))
  if [ $PAR_JOBS -eq 0 ]; then
    deq_job
    wait $dequed_job
    ((PAR_JOBS++))
  fi
done
wait

