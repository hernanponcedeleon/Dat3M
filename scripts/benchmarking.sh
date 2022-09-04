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
declare -a TARGETS=( "TSO ARM8 Power RISCV IMM C11" )
declare -a METHODS=( "caat assume" )

for TARGET in ${TARGETS[@]}; do

    ## Decide memory model based on the target
    if [[ "$TARGET" == "TSO" ]]
    then
        CAT="tso.cat"
    fi

    if [[ "$TARGET" == "ARM8" ]]
    then
        CAT="aarch64.cat"
    fi

    if [[ "$TARGET" == "Power" ]]
    then
        CAT="power.cat"
    fi

    if [[ "$TARGET" == "RISCV" ]]
    then
        CAT="riscv.cat"
    fi

    if [[ "$TARGET" == "IMM" ]]
    then
        CAT="imm.cat"
        ## GenMC option
        WMM="-imm"
    fi

    if [[ "$TARGET" == "C11" ]]
    then
        CAT="rc11.cat"
        ## GenMC option
        WMM="-rc11"
    fi

    for METHOD in ${METHODS[@]}; do

        ## Start CSV files
        echo benchmark, result, time > $DAT3M_OUTPUT/csv/$TARGET-$METHOD.csv

        ## Run Dartagnan
        for BENCHMARK in ${BENCHMARKS[@]}; do
            start=`python3 -c 'import time; print(int(time.time() * 1000))'`
            OUTPUT=$(timeout $TIMEOUT java -Xmx2048m -jar dartagnan/target/dartagnan-3.1.0.jar cat/$CAT --bound=2 --target=$TARGET --method=$METHOD $BPL_PATH$BENCHMARK.bpl)
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
            echo $BENCHMARK, $RESULT, $TIME >> $DAT3M_OUTPUT/csv/$TARGET-$METHOD.csv
        done
    done

    ## Run GenMC
    if [[ "$TARGET" == "C11" ]] || [[ "$TARGET" == "IMM" ]]
    then

        ## Start CSV files
        echo benchmark, result, time > $DAT3M_OUTPUT/csv/$TARGET-genmc.csv

        for BENCHMARK in ${BENCHMARKS[@]}; do
            start=`python3 -c 'import time; print(int(time.time() * 1000))'`
            OUTPUT=$(timeout $TIMEOUT genmc $WMM -unroll=2 $C_PATH$BENCHMARK.c)
            end=`python3 -c 'import time; print(int(time.time() * 1000))'`
            TIME=$((end-start))

            if [[ $OUTPUT == *"$GENMC_PASS"* ]];
            then
                RESULT="PASS"
            else
                if [[ $OUTPUT == *"$GENMC_FAIL"* ]];
                then
                    RESULT="FAIL"
                else
                    RESULT="ERROR"
                    ## From seconds to miliseconds
                    TIME=$((1000*$TIMEOUT))
                fi
            fi

            ## Save CSV
            echo $BENCHMARK, $RESULT, $TIME >> $DAT3M_OUTPUT/csv/$TARGET-genmc.csv
        done
    fi

    ## Run Nidhugg
    if [[ "$TARGET" == "TSO" ]]
    then

        ## Start CSV files
        echo benchmark, result, time > $DAT3M_OUTPUT/csv/$TARGET-nidhugg.csv

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
            echo $BENCHMARK, $RESULT, $TIME >> $DAT3M_OUTPUT/csv/$TARGET-nidhugg.csv
        done
    fi

done
