#!/bin/bash
FILES=/home/ponce/tools/sv-benchmarks/c/pthread-wmm/*.c
rm -f res.out
for f in $FILES
do
  echo $f
  timeout 30 cbmc $f > $f.res
  if [[ 'grep 'FAIL' $f' ]];then
    echo $f", FAIL" >> res.out
  else
    echo $f", PASS"
  fi
  rm $f.res >> res.out
done
