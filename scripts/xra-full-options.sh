#!/bin/bash
 
TIMEOUT=900

BENCHMARK=$1
CAT=$2
TARGET=$3
CSV_FILE=$4
LOG_FILE=$5

DAT3M_FINISHED="Verification finished"
DAT3M_FAIL="FAIL"

OPT_RA="--wmm.analysis.relationAnalysis"
OPT_MUST="--wmm.analysis.mustSets"
OPT_XRA="--wmm.analysis.extendedRelationAnalysis"
OPT_ACTIVE="--encoding.activeSets"
OPT_RAE="--encoding.wmm.reduceAcyclicityEncodeSets"

declare -a METHODS=( "caat assume" )
declare -a XRA_OPTS=( 
    ## [1,2,3,4,5]
    "$OPT_RA=false $OPT_MUST=false $OPT_XRA=false $OPT_ACTIVE=false $OPT_RAE=false" 
    ## [2,3,5]
    "$OPT_RA=true $OPT_MUST=false $OPT_XRA=false $OPT_ACTIVE=true $OPT_RAE=false" 
    ## [3,5]
    "$OPT_RA=true $OPT_MUST=true $OPT_XRA=false $OPT_ACTIVE=true $OPT_RAE=false" 
    ## [3]
    "$OPT_RA=true $OPT_MUST=true $OPT_XRA=false $OPT_ACTIVE=true $OPT_RAE=true" 
    ## [5]
    "$OPT_RA=true $OPT_MUST=true $OPT_XRA=true $OPT_ACTIVE=true $OPT_RAE=false" 
    # []
    "$OPT_RA=true $OPT_MUST=true $OPT_XRA=true $OPT_ACTIVE=true $OPT_RAE=true" 
)

## Remove logs from previous runs
rm -f -- $LOG_FILE
## Create final log
touch $LOG_FILE

## Start CSV files
echo // Benchmark: $BENCHMARK > $CSV_FILE
echo // CAT: $CAT >> $CSV_FILE
echo // Target: $TARGET >> $CSV_FILE
echo method, ra, must, xra, active, red-acyc, may-size, must-size, smt-vars, acyc-size, result, time >> $CSV_FILE

for METHOD in ${METHODS[@]}; do
    for XRA_OPT in "${XRA_OPTS[@]}"; do

        ## Remove logs from previous iteration
        rm -f -- $DAT3M_OUTPUT/logs/*.log

        DAT3M_OPTIONS="$CAT --target=$TARGET --method=$METHOD $XRA_OPT --encoding.symmetry.breakOn=rf"

        start=`python3 -c 'import time; print(int(time.time() * 1000))'`
        OUTPUT=$(timeout $TIMEOUT java -Xmx2048m -jar dartagnan/target/dartagnan-3.1.0.jar $DAT3M_OPTIONS $BENCHMARK)
        end=`python3 -c 'import time; print(int(time.time() * 1000))'`
        TIME=$((end-start))

        ## Options combination
        TOPT_RA=0
        if [[ "$XRA_OPT" == *"$OPT_RA=true"* ]]; then
            TOPT_RA=1
        fi
        TOPT_MUST=0
        if [[ "$XRA_OPT" == *"$OPT_MUST=true"* ]]; then
            TOPT_MUST=1
        fi
        TOPT_XRA=0
        if [[ "$XRA_OPT" == *"$OPT_XRA=true"* ]]; then
            TOPT_XRA=1
        fi
        TOPT_ACTIVE=0
        if [[ "$XRA_OPT" == *"$OPT_ACTIVE=true"* ]]; then
            TOPT_ACTIVE=1
        fi
        TOPT_RAE=0
        if [[ "$XRA_OPT" == *"$OPT_RAE=true"* ]]; then
            TOPT_RAE=1
        fi
                    
        ## May set size
        ## We want the last one because with CAAT we get the stats for the whole WMM
        ## as well as for what CAAT encodes
        GREP=$(grep "Number of may-tuples" $DAT3M_OUTPUT/logs/*.log | tail -1)
        MAY_SET=-1
        if [[ "$GREP" == *"Number of may-tuples"* ]]; then
            MAY_SET=${GREP#*Number of may-tuples: }
        fi
        ## Must set size
        ## We want the last one because with CAAT we get the stats for the whole WMM
        ## as well as for what CAAT encodes
        GREP=$(grep "Number of must-tuples" $DAT3M_OUTPUT/logs/*.log | tail -1)
        MUST_SET=-1
        if [[ "$GREP" == *"Number of must-tuples"* ]]; then
            MUST_SET=${GREP#*Number of must-tuples: }
        fi
        ## SMT variables
        ## We want the last one because with CAAT we get the stats for the first
        ## and final refinement iteration
        GREP=$(grep "mk bool var ->" $DAT3M_OUTPUT/logs/*.log | tail -1)
        SMT_VARS=-1
        if [[ "$GREP" == *"mk bool var ->"* ]]; then
            SMT_VARS=${GREP#*mk bool var -> }
        fi
        ## Acyclicity encoding
        GREP=$(grep "Number of encoded tuples for acyclicity:" $DAT3M_OUTPUT/logs/*.log)
        ACYC=-1
        if [[ "$GREP" == *"Number of encoded tuples for acyclicity:"* ]]; then
            ACYC=${GREP#*Number of encoded tuples for acyclicity:}
        fi

        ## Verification result
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

        ## Remove logs from previous runs
        cat $DAT3M_OUTPUT/logs/*.log >> $LOG_FILE

        ## Save CSV
        echo $METHOD, $TOPT_RA, $TOPT_MUST, $TOPT_XRA, $TOPT_ACTIVE, $TOPT_RAE, $MAY_SET, $MUST_SET, $SMT_VARS, $ACYC, $RESULT, $TIME >> $CSV_FILE
            
    done
done