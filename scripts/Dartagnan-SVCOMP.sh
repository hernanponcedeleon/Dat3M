#!/bin/bash

if [ $# -eq 0 ]; then
    echo "No input file supplied"
    exit 0
fi

export DAT3M_HOME=$(pwd)
export DAT3M_OUTPUT=$DAT3M_HOME/output

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

    skip_assertions_of_type="--program.processing.skipAssertionsOfType=USER"
    if [[ $propertypath == *"no-overflow.prp"* ]]; then
        export CFLAGS="-fgnu89-inline -fsanitize=signed-integer-overflow"
    elif [[ $propertypath == *"valid-memsafety.prp"* ]]; then
        export CFLAGS="-fgnu89-inline -fsanitize=null"
    elif [[ $propertypath == *"termination.prp"* ]]; then
        export CFLAGS="-fgnu89-inline"
    elif [[ $propertypath == *"no-data-race.prp"* ]]; then
        export CFLAGS="-fgnu89-inline"
    else
        export CFLAGS="-fgnu89-inline"
        skip_assertions_of_type=""
    fi
    
    cmd="java -jar svcomp/target/svcomp.jar $skip_assertions_of_type cat/svcomp.cat --svcomp.property="$propertypath" "$programpath" "$witness
fi
$cmd
