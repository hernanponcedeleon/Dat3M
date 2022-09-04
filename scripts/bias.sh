#!/bin/bash

export SMACK_FLAGS="-q -t --no-memory-splitting"

if [[ -z "${BENCHMARK}" ]]; then
    echo "Variable BENCHMARK is not defined"
    exit 0
fi

if [[ -z "${CFLAGS}" ]]; then
    echo "Variable CFLAGS is not defined"
    exit 0
fi

if [[ -z "${TIMEOUT}" ]]; then
    TIMEOUT=900
fi

DAT3M_FINISHED="Verification finished"
DAT3M_FAIL="FAIL"

RMW_OPT="atomic_rmw"
OOTA_OPT="no_oota"
UNI_OPT="uniproc"

CUT="cut-"


## Bias "," results in no bias being used
declare -a BIASES=( "," $RMW_OPT $OOTA_OPT $RMW_OPT,$OOTA_OPT $UNI_OPT $RMW_OPT,$UNI_OPT $OOTA_OPT,$UNI_OPT $RMW_OPT,$OOTA_OPT,$UNI_OPT )
declare -a TARGETS=( "LKMM ARM8 Power RISCV" )

for TARGET in ${TARGETS[@]}; do

    ## Start CSV file
    echo rmw, oota, uni, result, time > $DAT3M_OUTPUT/csv/bias-$TARGET.csv

    ## Decide memory model based on the target
    if [[ "$TARGET" == "LKMM" ]]; then
        CAT="linux-kernel.cat"
    fi

    if [[ "$TARGET" == "ARM8" ]]; then
        CAT="aarch64.cat"
    fi

    if [[ "$TARGET" == "Power" ]]; then
        CAT="power.cat"
    fi

    if [[ "$TARGET" == "RISCV" ]]; then
        CAT="riscv.cat"
    fi

    for BIAS in ${BIASES[@]}; do
    
        RMW="\ding{56}"
        if [[ $BIAS == *"$RMW_OPT"* ]]; then
            RMW="\ding{52}"
        fi

        OOTA="\ding{56}"
        if [[ $BIAS == *"$OOTA_OPT"* ]]; then
            OOTA="\ding{52}"
        fi

        UNI="\ding{56}"
        if [[ $BIAS == *"$UNI_OPT"* ]]; then
            UNI="\ding{52}"
            ## When using uniproc bias, we cut the fr relation
            if [[ $CAT != *"$CUT"* ]]; then
                CAT=$CUT$CAT
            fi
        fi

        ## Run Dartagnan with CAAT
        start=`python3 -c 'import time; print(int(time.time() * 1000))'`
        OUTPUT=$(timeout $TIMEOUT java -Xmx2048m -jar dartagnan/target/dartagnan-3.1.0.jar cat/$CAT $DAT3M_OPTIONS --target=$TARGET --refinement.baseline=$BIAS $BENCHMARK)
        end=`python3 -c 'import time; print(int(time.time() * 1000))'`
        TIME=$((end-start))
        
        if [[ $OUTPUT == *"$DAT3M_FINISHED"* ]]; then
            if [[ $OUTPUT == *"$DAT3M_FAIL"* ]]; then
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
        echo $RMW, $OOTA, $UNI, $RESULT, $TIME >> $DAT3M_OUTPUT/csv/bias-$TARGET.csv
    done
    
    ## Run Dartagnan with eager encoding
    start=`python3 -c 'import time; print(int(time.time() * 1000))'`
    OUTPUT=$(timeout $TIMEOUT java -Xmx2048m -jar dartagnan/target/dartagnan-3.1.0.jar cat/$CAT $DAT3M_OPTIONS --target=$TARGET --refinement.baseline=$BIAS $BENCHMARK --method=assume)
    end=`python3 -c 'import time; print(int(time.time() * 1000))'`
    TIME=$((end-start))
    
    if [[ $OUTPUT == *"$DAT3M_FINISHED"* ]]; then
        if [[ $OUTPUT == *"$DAT3M_FAIL"* ]]; then
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
    echo -, -, -, $RESULT, $TIME >> $DAT3M_OUTPUT/csv/bias-$TARGET.csv

done
