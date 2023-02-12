#!/bin/bash
 
BENCH_PATH=$DAT3M_HOME/benchmarks/

TIMEOUT=3600

DAT3M_FINISHED="Verification finished"
DAT3M_FAIL="FAIL"

## Options
OPT_RA="--wmm.analysis.relationAnalysis"
OPT_MUST="--wmm.analysis.mustSets"
OPT_XRA="--wmm.analysis.extendedRelationAnalysis"
OPT_ACTIVE="--encoding.activeSets"
OPT_RAE="--encoding.wmm.reduceAcyclicityEncodeSets"

## Combinations
CAV19="$OPT_RA=true $OPT_MUST=false $OPT_XRA=false $OPT_ACTIVE=true $OPT_RAE=false" 
XRA="$OPT_RA=true $OPT_MUST=true $OPT_XRA=true $OPT_ACTIVE=true $OPT_RAE=false" 
XRA_ACY="$OPT_RA=true $OPT_MUST=true $OPT_XRA=true $OPT_ACTIVE=true $OPT_RAE=true" 

declare -a METHODS=( "caat assume" )
declare -a XRA_OPTS=( "$CAV19" "$XRA" "$XRA_ACY" )

CAT=$1
TARGET=$2

declare -a BENCHMARKS=( "locks/ttas" "locks/ticketlock" "locks/mutex" "locks/spinlock" "locks/linuxrwlock" "locks/mutex_musl" "lfds/chase-lev" "lfds/dglm" "lfds/ms" "lfds/treiber" )

for METHOD in ${METHODS[@]}; do
    for XRA_OPT in "${XRA_OPTS[@]}"; do

        ## Tool combinations
        case "$XRA_OPT" in
	        "$CAV19" )
		        TOOL=$METHOD-cav19 ;;
	        "$XRA" )
		        TOOL=$METHOD-xra ;;
	        "$XRA_ACY" )
		        TOOL=$METHOD-xra-acy ;;
        esac

        if [ "$METHOD" == "caat" ] && [ "$XRA_OPT" == "$XRA_ACY" ]; then
            continue
        fi

        ## Start CSV files
        echo benchmark, threads, may-size, must-size, act-size, smt-vars, acyc-size, result, ra_time, xra_time, veri_time > $DAT3M_OUTPUT/csv/$TARGET-$TOOL.csv

        ## Options for Dartagnan
        DAT3M_OPTIONS="$DAT3M_HOME/cat/$CAT --target=$TARGET --method=$METHOD $XRA_OPT --encoding.symmetry.breakOn=_cf --bound=2 --encoding.locallyConsistent=false"

        for BENCHMARK in ${BENCHMARKS[@]}; do

            ## Set number of threads
            case "$BENCHMARK" in
                "locks/ttas" | "locks/ticketlock" | "locks/spinlock")
                    THREADS=6 ;;
                "locks/linuxrwlock" | "lfds/chase-lev")
                    THREADS=5 ;;
                "locks/mutex" | "locks/mutex_musl" | "lfds/treiber")
                    THREADS=4 ;;
                "lfds/dglm" | "lfds/ms")
                    THREADS=3 ;;
                *)
                    echo "Missing case for benchmark" $BENCHMARK ;;
            esac

            export CFLAGS="-DNTHREADS="$THREADS

            ## The SMT statistics go to different logs
            if [ "$METHOD" == "caat" ]; then
    	        SMT_LOG=$DAT3M_OUTPUT/logs/refinement.log
            else
	            SMT_LOG=$DAT3M_OUTPUT/logs/$BENCHMARK.log
            fi

            ## Run Dartagnan
            start=`python3 -c 'import time; print(int(time.time() * 1000))'`
            OUTPUT=$(timeout $TIMEOUT java -DLOGNAME=$BENCHMARK -Xmx4g -jar dartagnan/target/dartagnan-3.1.1.jar $DAT3M_OPTIONS $BENCH_PATH$BENCHMARK.c)
            end=`python3 -c 'import time; print(int(time.time() * 1000))'`
            VERI_TIME=$((end-start))
            
            ## May set size
            GREP=$(grep "Number of may-tuples" $DAT3M_OUTPUT/logs/$BENCHMARK.log | tail -1)
            MAY_SET=-1
            if [[ "$GREP" == *"Number of may-tuples"* ]]; then
                MAY_SET=${GREP#*Number of may-tuples: }
            fi
            ## Must set size
            GREP=$(grep "Number of must-tuples" $DAT3M_OUTPUT/logs/$BENCHMARK.log | tail -1)
            MUST_SET=-1
            if [[ "$GREP" == *"Number of must-tuples"* ]]; then
                MUST_SET=${GREP#*Number of must-tuples: }
            fi
            ## Active set size
            GREP=$(grep "Number of encoded tuples:" $DAT3M_OUTPUT/logs/$BENCHMARK.log | tail -1)
            ACT_SET=-1
            if [[ "$GREP" == *"Number of encoded tuples:"* ]]; then
                ACT_SET=${GREP#*Number of encoded tuples: }
            fi
            ## SMT variables
            GREP=$(grep "mk bool var ->" $SMT_LOG | tail -1)
            SMT_VARS=-1
            if [[ "$GREP" == *"mk bool var ->"* ]]; then
                SMT_VARS=${GREP#*mk bool var -> }
            fi
            ## Size of acyclicity encoding
            GREP=$(grep "Number of encoded tuples for acyclicity:" $DAT3M_OUTPUT/logs/$BENCHMARK.log | tail -1)
            ACYC=-1
            if [[ "$GREP" == *"Number of encoded tuples for acyclicity:"* ]]; then
                ACYC=${GREP#*Number of encoded tuples for acyclicity: }
            fi
            ## Relation Analysis time
            GREP=$(grep "Finished regular analysis in " $DAT3M_OUTPUT/logs/$BENCHMARK.log | tail -1)
            RA_TIME=-1
            if [[ "$GREP" == *"Finished regular analysis in "* ]]; then
                RA_TIME=${GREP#*Finished regular analysis in }
                ## Remove the ms
                RA_TIME=${RA_TIME::-2}
            fi
            ## Extended Relation Analysis time
            GREP=$(grep "Finished extended analysis in " $DAT3M_OUTPUT/logs/$BENCHMARK.log | tail -1)
            XRA_TIME=-1
            if [[ "$GREP" == *"Finished extended analysis in "* ]]; then
                XRA_TIME=${GREP#*Finished extended analysis in }
                ## Remove the ms
                XRA_TIME=${XRA_TIME::-2}
            fi

            ## Verification result
            if [[ $OUTPUT == *"$DAT3M_FINISHED"* ]];
            then
                ## Verification result
                if [[ $OUTPUT == *"$DAT3M_FAIL"* ]];
                then
                    RESULT="FAIL"
                else
                    RESULT="PASS"
                fi
            else
                RESULT="ERROR"
                ## From seconds to miliseconds
                VERI_TIME=$((1000*$TIMEOUT))
            fi

            ## Save CSV
            echo $BENCHMARK, $THREADS, $MAY_SET, $MUST_SET, $ACT_SET, $SMT_VARS, $ACYC, $RESULT, $RA_TIME, $XRA_TIME, $VERI_TIME >> $DAT3M_OUTPUT/csv/$TARGET-$TOOL.csv

        done
    done
done