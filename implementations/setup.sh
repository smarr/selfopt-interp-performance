#!/bin/bash
set -e # make script fail on first error

source script.inc

check_for_tools git ant tar make javac mv unzip uname cc c++
get_web_getter

./build-graal.sh
./build-classic-benchmarks.sh
./build-somns.sh

OK done.
