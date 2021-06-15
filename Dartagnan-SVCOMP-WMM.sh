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

    java -jar svcomp/target/svcomp-$VERSION-jar-with-dependencies.jar -umax 1 -solver $1 -t $2 -cat $3 -property $4 -i $5
fi
