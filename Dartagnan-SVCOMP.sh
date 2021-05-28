#!/bin/bash

VERSION=2.0.7

if [ $# -eq 0 ]; then
    echo "No input file supplied"
    exit 0
fi

if [ $1 == "-v" ] || [ $1 == "--version" ]; then
    echo $VERSION
else
    export PATH=$PATH:$HOME/bin:$JAVA_HOME/bin
    export LD_LIBRARY_PATH=$(pwd)/lib/

    FLAGS="-solver incremental"
    if ! grep -q "pthread" $2; then
        FLAGS+=" -o O3 -e bit-vector -cat cat/sc.cat"
    else
        FLAGS+=" -cat cat/svcomp.cat"
    fi
    echo $FLAGS -property $1 -i $2
    java -jar svcomp/target/svcomp-$VERSION-jar-with-dependencies.jar $FLAGS -property $1 -i $2
fi
