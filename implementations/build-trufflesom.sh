#!/bin/bash

source ./script.inc
source ./config.inc

INFO Build TruffleSOM master
cd TruffleSOM
make clean
mkdir libs; cp ../graal/build/truffle*.jar libs/
make || {
  ERR Build of master failed.
  exit 1
}
cd ..
OK TruffleSOM master Build Completed.

for exp in $( ls -d T-* ); do
  INFO Build TruffleSOM $exp
  cd $exp
  make clean
  mkdir libs; cp ../graal/build/truffle*.jar libs/
  make || {
    ERR Build of $exp failed.
    exit 1
  }
  cd ..
  OK TruffleSOM $exp Build Completed.
done
