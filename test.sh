#!/bin/bash
FILES=/home/ponce/tools/sv-benchmarks/c/pthread-wmm/*.c
for f in $FILES
do
  echo $f
  sed 's/void __VERIFIER_assert(int expression) { if (!expression) { ERROR: __VERIFIER_error(); }; return; }//g' $f > new.c
  timeout 30 java -jar dartagnan/target/dartagnan-2.0.4-jar-with-dependencies.jar -cat cat/sc.cat -t none -unroll 1 -i new.c
done
