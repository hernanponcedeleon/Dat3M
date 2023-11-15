#!/bin/bash

version=4.0.0

if [ $# -eq 0 ]; then
    echo "No input file supplied"
    exit 0
fi

if [ $1 == "-v" ] || [ $1 == "--version" ]; then
    echo $version
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

    if [[ $propertypath == *"no-overflow.prp"* ]]; then
        export CFLAGS="-fgnu89-inline -fsanitize=signed-integer-overflow"
    else
        export CFLAGS="-fgnu89-inline"
    fi
    
    cmd="java -jar svcomp/target/svcomp.jar --method=assume --program.processing.constantPropagation=false --encoding.integers=true --svcomp.step=5 --svcomp.umax=27 cat/svcomp.cat --svcomp.property="$propertypath" "$programpath" "$witness
    $cmd
fi
