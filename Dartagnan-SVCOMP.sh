#!/bin/bash

VERSION=3.0.0

if [ $# -eq 0 ]; then
    echo "No input file supplied"
    exit 0
fi

if [ $1 == "-v" ] || [ $1 == "--version" ]; then
    echo $VERSION
else
    if [ $1 == "-witness" ]; then
        WITNESS="--validate="$2
        PROPERTYPATH=$3
        PROGRAMPATH=$4
    else
        WITNESS=""
        PROPERTYPATH=$1
        PROGRAMPATH=$2
    fi

    export DAT3M_HOME=$(pwd)
    export PATH=$PATH:$DAT3M_HOME/smack/bin

    FLAGS="--method=assume"
    if ! grep -q "pthread" $PROGRAMPATH; then
        FLAGS+=" --svcomp.optimization=O3 --svcomp.integerEncoding=bit-vector cat/sc.cat"
    else
        FLAGS+=" --svcomp.step=5 --svcomp.umax=27 cat/svcomp.cat"
    fi

    cmd="java -jar svcomp/target/svcomp-"$VERSION".jar "$FLAGS" --svcomp.property="$PROPERTYPATH" "$PROGRAMPATH" "$WITNESS
    echo $cmd
    $cmd
fi
