#!/bin/bash
for p in $(ls *.Rmd); do
  echo Render $p
  ./scripts/knit.R $p
done
