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

## Bias "," results in no bias being used
declare -a BIASES=( "," $RMW_OPT $OOTA_OPT $UNI_OPT $RMW_OPT,$OOTA_OPT $RMW_OPT,$UNI_OPT $OOTA_OPT,$UNI_OPT $RMW_OPT,$OOTA_OPT,$UNI_OPT )
declare -a TARGETS=( "LKMM ARM8 Power" )

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

    for BIAS in ${BIASES[@]}; do
    
        ## Run Dartagnan
        start=`python3 -c 'import time; print(int(time.time() * 1000))'`
        OUTPUT=$(timeout $TIMEOUT java -Xmx2048m -jar dartagnan/target/dartagnan-3.0.0.jar cat/$CAT $DAT3M_OPTIONS --target=$TARGET --refinement.baseline=$BIAS $BENCHMARK)
        end=`python3 -c 'import time; print(int(time.time() * 1000))'`
        TIME=$((end-start))
        
        RMW=\ding{52}
        if [[ $BIAS == *"$RMW_OPT"* ]]; then
            RMW=\ding{56}
        fi

        OOTA=\ding{52}
        if [[ $BIAS == *"$OOTA_OPT"* ]]; then
            OOTA=\ding{56}
        fi

        UNI=\ding{52}
        if [[ $BIAS == *"$UNI_OPT"* ]]; then
            UNI=\ding{56}
        fi

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
done
