#!/bin/bash

version=3.1.1

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

    cflags="-DSVCOMP -DCUSTOM_VERIFIER_ASSERT -fno-vectorize -fno-slp-vectorize"
    svcompflags="--method=assume --svcomp.step=5 --svcomp.umax=27 cat/svcomp.cat"

    export DAT3M_HOME=$(pwd)
    export DAT3M_OUTPUT=$DAT3M_HOME/output
    export CFLAGS=$cflags

    cmd="java -jar svcomp/target/svcomp.jar "$svcompflags" --svcomp.property="$propertypath" "$programpath" "$witness
    $cmd
fi
