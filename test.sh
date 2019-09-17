#!/bin/bash
FILES=/home/ponce/tools/sv-benchmarks/c/pthread/*.c
for f in $FILES
do
  echo $f
  bash Dartagnan.sh $f
done
