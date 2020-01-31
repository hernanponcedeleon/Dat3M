#!/bin/bash

if [ $# -eq 0 ]; then
    echo "No input file supplied"
    exit 0
fi

if [ $# -eq 1 ]; then
    echo "No output file supplied"
    exit 0
fi

# Compile all files
clang -c -Wall -Wno-everything -emit-llvm -O0 -g -Xclang -disable-O0-optnone $1 -o ./output/input.bc
clang -c -Wall -emit-llvm -O0 -g -Xclang -disable-O0-optnone -I ./include/ ./lib/smack.c -o ./output/smack.bc
clang -c -Wall -emit-llvm -O0 -g -Xclang -disable-O0-optnone -I ./include/ ./lib/stdlib.c -o ./output/std.bc
clang -c -Wall -emit-llvm -O0 -g -Xclang -disable-O0-optnone -I ./include/ ./lib/errno.c -o ./output/error.bc
# Link them into one
llvm-link -o ./output/all.bc ./output/input.bc ./output/smack.bc ./output/std.bc ./output/error.bc
rm ./output/input.bc ./output/smack.bc ./output/std.bc ./output/error.bc
# Convert to BOOGIE
llvm2bpl ./output/all.bc -bpl $2 -warn-type silent -colored-warnings -source-loc-syms -entry-points main -mem-mod-impls
rm ./output/all.bc
