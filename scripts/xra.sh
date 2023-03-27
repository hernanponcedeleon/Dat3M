#!/bin/bash
 
TIMEOUT=10800

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

declare -a METHODS=( "assume caat" )
declare -a XRA_OPTS=( "$CAV19" "$XRA" "$XRA_ACY" )
declare -a BENCHMARKS=( "benchmarks/locks/clh_mutex" 
                        "benchmarks/locks/cna"
                        "benchmarks/locks/linuxrwlock"
                        "benchmarks/locks/mutex_musl"
                        "benchmarks/locks/mutex"
                        "benchmarks/locks/spinlock"
                        "benchmarks/locks/ticket_awnsb_mutex"
                        "benchmarks/locks/ticketlock"
                        "benchmarks/locks/ttas"
                        "benchmarks/lfds/chase-lev"
                        "benchmarks/lfds/dglm"
                        "benchmarks/lfds/ms"
                        "benchmarks/lfds/treiber"
                        "$CNA_VERIFICATION_HOME/client-code"
                        )

CAT=$1
TARGET=$2

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

        for BENCHMARK in ${BENCHMARKS[@]}; do

            ## The other benchmarks are not compatible with LKMM API
            if [ "$TARGET" == "LKMM" ] && [ "$BENCHMARK" != "$CNA_VERIFICATION_HOME/client-code" ]; then
                continue
            fi
        
            ## Options for Dartagnan
            DAT3M_OPTIONS="$DAT3M_HOME/cat/$CAT --target=$TARGET --method=$METHOD $XRA_OPT \
            --property=program_spec,liveness,cat_spec --program.processing.propagateCopyAssignments=false \
            --encoding.symmetry.breakOn=_cf --bound=2 --solver=yices2 \
            --modeling.threadCreateAlwaysSucceeds=true --modeling.precision=64 --encoding.locallyConsistent=false"

            ## Set number of threads
            case "$BENCHMARK" in
                "benchmarks/locks/ttas" | "benchmarks/locks/ticketlock" | "benchmarks/locks/spinlock" | "benchmarks/locks/clh_mutex")
                    THREADS=6 ;;
                "benchmarks/locks/linuxrwlock" | "benchmarks/lfds/chase-lev" | "benchmarks/locks/ticket_awnsb_mutex")
                    THREADS=5 ;;
                "benchmarks/locks/mutex" | "benchmarks/locks/mutex_musl" | "benchmarks/lfds/treiber" | "benchmarks/locks/cna" | "$CNA_VERIFICATION_HOME/client-code")
                    THREADS=4 ;;
                "benchmarks/lfds/dglm" | "benchmarks/lfds/ms")
                    THREADS=3 ;;
                *)
                    echo "Missing case for benchmark" $BENCHMARK ;;
            esac

            export CFLAGS="-I$DAT3M_HOME/include -I$CNA_VERIFICATION_HOME/include -DALGORITHM=2 -DNTHREADS="$THREADS

            ## The SMT statistics go to different logs
            if [ "$METHOD" == "caat" ]; then
    	        SMT_LOG=$DAT3M_OUTPUT/logs/refinement.log
            else
	            SMT_LOG=$DAT3M_OUTPUT/logs/$BENCHMARK.log
            fi

            ## Run Dartagnan
            start=`python3 -c 'import time; print(int(time.time() * 1000))'`
            OUTPUT=$(timeout $TIMEOUT java -Dlog4j2.configurationFile=file:$DAT3M_HOME/dartagnan/src/main/resources/log4j2.xml -DLOGNAME=$BENCHMARK -Xmx4g -jar $DAT3M_HOME/dartagnan/target/dartagnan-3.1.1.jar $DAT3M_OPTIONS $BENCHMARK.c)
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
            if [[ $OUTPUT == *"$DAT3M_FINISHED"* ]]; then
                ## Verification result
                if [[ $OUTPUT == *"$DAT3M_FAIL"* ]]; then
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