#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No input file supplied"
    exit 0
fi

if [ $1 == "-v" ] || [ $1 == "--version" ]; then
    echo "2.0.5"
else
    export PATH=$PATH:$HOME/bin:$JAVA_HOME/bin:$(pwd)/smack/bin/bin
    export LD_LIBRARY_PATH=$(pwd)/lib/

    java -jar svcomp/target/svcomp-2.0.5-jar-with-dependencies.jar -w -i $1
fi
