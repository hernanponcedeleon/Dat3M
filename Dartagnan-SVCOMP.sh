#!/bin/bash

VERSION=2.0.7

if [ $# -eq 0 ]; then
    echo "No input file supplied"
    exit 0
fi

if [ $1 == "-v" ] || [ $1 == "--version" ]; then
    echo $VERSION
else
    if [ $1 == "-witness" ]; then
        WITNESS=$1" "$2
        PROPERTYPATH=$3
        PROGRAMPATH=$4
    else
        WITNESS=""
        PROPERTYPATH=$1
        PROGRAMPATH=$2
    fi

    export PATH=$PATH:$HOME/bin:$JAVA_HOME/bin
    export LD_LIBRARY_PATH=$(pwd)/lib/

    FLAGS="-method incremental"
    if ! grep -q "pthread" $2; then
        FLAGS+=" -o O3 -e bit-vector -cat cat/sc.cat"
    else
        FLAGS+=" -cat cat/svcomp.cat"
    fi
    echo java -jar svcomp/target/svcomp-$VERSION.jar $FLAGS -property $PROPERTYPATH -i $PROGRAMPATH $WITNESS
    java -jar svcomp/target/svcomp-$VERSION.jar $FLAGS -property $PROPERTYPATH -i $PROGRAMPATH $WITNESS
fi
