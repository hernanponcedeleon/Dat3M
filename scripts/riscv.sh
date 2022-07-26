#!/bin/bash
 
BPL_PATH=$DAT3M_HOME/dartagnan/src/test/resources/
C_PATH=$DAT3M_HOME/benchmarks/
TIMEOUT=900

DAT3M_FINISHED="Verification finished"
DAT3M_FAIL="FAIL"
GENMC_PASS="No errors were detected"
GENMC_FAIL="Assertion violation"
NIDHUGG_PASS="No errors were detected"
NIDHUGG_FAIL="Assertion violation"

declare -a BENCHMARKS=( "locks/ttas-5" "locks/ticketlock-6" "locks/mutex-4" "locks/spinlock-5" "locks/linuxrwlock-3" "locks/mutex_musl-4" "lfds/safe_stack-3" "lfds/chase-lev-5" "lfds/dglm-3" "lfds/harris-3" "lfds/ms-3" "lfds/treiber-3" )
declare -a METHODS=( "caat assume" )

for METHOD in ${METHODS[@]}; do

    ## Start CSV files
    echo benchmark, result, time > $DAT3M_OUTPUT/csv/RISCV-$METHOD.csv

    ## Run Dartagnan
    for BENCHMARK in ${BENCHMARKS[@]}; do
        start=`python3 -c 'import time; print(int(time.time() * 1000))'`
        OUTPUT=$(timeout $TIMEOUT java -Xmx2048m -jar dartagnan/target/dartagnan-3.0.0.jar cat/riscv.cat --bound=2 --target=riscv --method=$METHOD $BPL_PATH$BENCHMARK.bpl)
        end=`python3 -c 'import time; print(int(time.time() * 1000))'`
        TIME=$((end-start))
        
        if [[ $OUTPUT == *"$DAT3M_FINISHED"* ]];
        then
            if [[ $OUTPUT == *"$DAT3M_FAIL"* ]];
            then
                RESULT="FAIL"
            else
                RESULT="PASS"
            fi
        else
            RESULT="ERROR"
            ## From seconds to miliseconds
            TIME=$((1000*$TIMEOUT))
        fi
        
        ## Save CSV
        echo $BENCHMARK, $RESULT, $TIME >> $DAT3M_OUTPUT/csv/RISCV-$METHOD.csv
    done
done
