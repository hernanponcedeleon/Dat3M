#!/bin/bash
if [ "$#" -ne 2 ]; then
  echo "Usage: @PASSNAME@ input.ll output.ll"
else
  @LLVM_BINARY_DIR@/bin/opt -enable-new-pm=0 -load=lib@PASSNAME@.so -@PASSNAME@ ${ATOMIC_REPLACE_OPTS} $1 -S -o $2
fi
