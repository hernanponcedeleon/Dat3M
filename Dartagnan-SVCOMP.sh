#!/bin/bash

if [ $# -eq 0 ]; then
    echo "No input file supplied"
    exit 0
fi

if [ $1 == "-v" ] || [ $1 == "--version" ]; then
    cmd="java -jar dartagnan/target/dartagnan.jar --version"
else
    if [ $1 == "-witness" ]; then
        witness="--validate="$2
        propertypath=$3
        programpath=$4
    else
        witness=""
        propertypath=$1
        programpath=$2
    fi

    export DAT3M_HOME=$(pwd)
    export DAT3M_OUTPUT=$DAT3M_HOME/output

    export OPTFLAGS="-mem2reg -sroa -early-cse -indvars -loop-unroll -fix-irreducible -loop-simplify -simplifycfg -gvn"

    skip_assertions_of_type="--program.processing.skipAssertionsOfType=USER"
    if [[ $propertypath == *"no-overflow.prp"* ]]; then
        export CFLAGS="-fgnu89-inline -fsanitize=signed-integer-overflow"
    elif [[ $propertypath == *"valid-memsafety.prp"* ]]; then
        export CFLAGS="-fgnu89-inline -fsanitize=null"
    else
        export CFLAGS="-fgnu89-inline"
        skip_assertions_of_type=""
    fi
    
    cmd="java -jar svcomp/target/svcomp.jar --method=eager --encoding.integers=true $skip_assertions_of_type --svcomp.step=5 --svcomp.umax=27 cat/svcomp.cat --svcomp.property="$propertypath" "$programpath" "$witness
fi
$cmd
