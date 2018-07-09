#!/bin/sh

# TODO: ROOT and HERD from environment
ROOT="/Users/natgavrilenko/Desktop/Dat3M/dartagnan"
HERD="/Users/natgavrilenko/.opam/system/bin/herd7"

TESTS_PATH=$ROOT/"litmus"

OUT_FILE=$ROOT/"litmus/herd.csv"
OUTPUT_RELATIVE_PATH=1

> $OUT_FILE

DIRS="$(find $TESTS_PATH -type d)"
for dir in $DIRS
do
    # TODO: Put HERD configs here (cat model etc) and apply them to all tests in this dir
    FILES="$(find $dir -name '*.litmus')"
    for file in $FILES
    do
        result=-1
        herdOut=$($HERD $file | tail -8 | head -1 | grep -oE "(Ok|No)")
        if [ $herdOut = "Ok" ]
        then
            result=1
        elif [ $herdOut = "No" ]
        then
            result=0
        fi
        if [ $OUTPUT_RELATIVE_PATH = 1 ]
        then
            file=${file/$ROOT\//}
        fi
        echo "$file,$result" >> $OUT_FILE
    done
done