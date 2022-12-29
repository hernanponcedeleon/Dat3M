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

declare -a BENCHMARKS=( "locks/ttas" "locks/ticketlock" "locks/mutex" "locks/spinlock" "locks/linuxrwlock" "locks/mutex_musl" "lfds/safe_stack-3" "lfds/chase-lev-5" "lfds/dglm-3" "lfds/harris-3" "lfds/ms-3" "lfds/treiber-3" )
declare -a METHODS=( "caat assume cutting" )

CAT=tso.cat

for METHOD in ${METHODS[@]}; do

    ## We use METHOD for file names and MOPT to call the tool
    MOPT=$METHOD

    ## Update memory model for cutting
    if [[ "$METHOD" == "cutting" ]]
    then
        CAT=cut-$CAT
        MOPT="caat"
    fi

    ## Start CSV files
    echo benchmark, result, time > $DAT3M_OUTPUT/csv/TSO-$METHOD.csv

    ## Run Dartagnan
    for BENCHMARK in ${BENCHMARKS[@]}; do
        ## safe_stack is unsafe and thus we run it several times to avoid minimise time fluctuations
        if [[ "$BENCHMARK" == "lfds/safe_stack-3" ]];
        then
            start=`python3 -c 'import time; print(int(time.time() * 1000))'`
            for i in 1 2 3
            do
                OUTPUT=$(timeout $TIMEOUT java -Xmx4g -jar dartagnan/target/dartagnan-3.1.0.jar cat/$CAT --bound=2 --target=tso --method=$MOPT $DAT3M_OPTIONS $BPL_PATH$BENCHMARK.bpl)
            done
            end=`python3 -c 'import time; print(int(time.time() * 1000))'`
            TIME=$(($((end-start))/3))
        else
            start=`python3 -c 'import time; print(int(time.time() * 1000))'`
            OUTPUT=$(timeout $TIMEOUT java -Xmx2048m -jar dartagnan/target/dartagnan-3.1.0.jar cat/$CAT --bound=2 --target=tso --method=$MOPT $DAT3M_OPTIONS $BPL_PATH$BENCHMARK.bpl)
            end=`python3 -c 'import time; print(int(time.time() * 1000))'`
            TIME=$((end-start))
        fi

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
        echo $BENCHMARK, $RESULT, $TIME >> $DAT3M_OUTPUT/csv/TSO-$METHOD.csv
    done
done

## Run Nidhugg

## Start CSV files
echo benchmark, result, time > $DAT3M_OUTPUT/csv/TSO-nidhugg.csv

for BENCHMARK in ${BENCHMARKS[@]}; do
    clang -emit-llvm -S -o $C_PATH$BENCHMARK.ll $C_PATH$BENCHMARK.c
    nidhugg --unroll=2 --transform=$C_PATH$BENCHMARK-u.ll $C_PATH$BENCHMARK.ll
    start=`python3 -c 'import time; print(int(time.time() * 1000))'`
    OUTPUT=$(timeout $TIMEOUT nidhugg -tso $C_PATH$BENCHMARK-u.ll)
    end=`python3 -c 'import time; print(int(time.time() * 1000))'`
    TIME=$((end-start))

    if [[ $OUTPUT == *"$GENMC_PASS"* ]];
    then
        RESULT="PASS"
    else
        if [[ $OUTPUT == *"$NIDHUGG_FAIL"* ]];
        then
            RESULT="FAIL"
        else
            RESULT="ERROR"
            ## From seconds to miliseconds
            TIME=$((1000*$TIMEOUT))
        fi

    fi
    
    ## Save CSV
    echo $BENCHMARK, $RESULT, $TIME >> $DAT3M_OUTPUT/csv/TSO-nidhugg.csv
done
