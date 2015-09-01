#!/bin/bash
set -e

source ./script.inc
source ./config.inc

INFO "Build SOMns"
cd SOMns
make clean; make
cd ..
OK "SOMns: Build Completed."

INFO "Build SOMns without optimizations"
cd SOMns-wo-opt
make clean; make
OK "SOMns without optimizations: Build Completed."
