#!/bin/bash
 
BPL_PATH=$DAT3M_HOME/dartagnan/src/test/resources/

declare -a LOCK_BENCHMARKS=( "ttas-5" "ticketlock-6" "mutex-4" "spinlock-5" "linuxrwlock-3" "mutex_musl-4" )
declare -a LFDS_BENCHMARKS=( "safe_stack-3" "chase-lev-5" "dglm-3" "ms-3" "treiber-3" )

CAT=$DAT3M_HOME/cat/aarch64.cat
TARGET=arm8
LOGS_FOLDER=$1

## Call xra.sh with correct parameters
for BENCHMARK in ${LOCK_BENCHMARKS[@]}; do
    bash $DAT3M_HOME/scripts/xra.sh $BPL_PATH/locks/$BENCHMARK.bpl $CAT $TARGET $DAT3M_OUTPUT/csv/$TARGET-$BENCHMARK.csv $LOGS_FOLDER/$TARGET-$BENCHMARK.log
done
for BENCHMARK in ${LFDS_BENCHMARKS[@]}; do
    bash $DAT3M_HOME/scripts/xra.sh $BPL_PATH/lfds/$BENCHMARK.bpl $CAT $TARGET $DAT3M_OUTPUT/csv/$TARGET-$BENCHMARK.csv $LOGS_FOLDER/$TARGET-$BENCHMARK.log
done
