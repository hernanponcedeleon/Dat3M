#!/bin/bash

if [ $# -eq 0 ]; then
    echo "No input file supplied"
    exit 0
fi

export DAT3M_HOME=$(pwd)
export DAT3M_OUTPUT=$DAT3M_HOME/output

if [ $1 == "-v" ] || [ $1 == "--version" ]; then
    cmd=(dartagnan --version)
else
    propertypath=$1
    programpath=$2

    cmd=(svcomp/target/svcomp)
    compilation_pipeline=svcomp/compilation.yml
    if [[ $propertypath == *"no-overflow.prp"* ]]; then
        compilation_pipeline=svcomp/compilation-no-overflow.yml
    elif [[ $propertypath == *"valid-memsafety.prp"* ]]; then
        compilation_pipeline=svcomp/compilation-valid-memsafety.yml
    fi
    cmd+=("--compilation.pipeline=$DAT3M_HOME/$compilation_pipeline")

    if [[ $propertypath == *"no-overflow.prp"* || $propertypath == *"valid-memsafety.prp"* \
            || $propertypath == *"termination.prp"* || $propertypath == *"no-data-race.prp"* ]]; then
        cmd+=(--program.processing.skipAssertionsOfType=USER)
    fi
    cmd+=(cat/svcomp.cat "--svcomp.property=$propertypath" "$programpath")
fi
"${cmd[@]}"
