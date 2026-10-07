#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <property.prp> <program.c|program.i> <ILP32|LP64>" >&2
    exit 1
fi

export DAT3M_HOME=$(pwd)
export DAT3M_OUTPUT=$DAT3M_HOME/output

if [ $1 == "-v" ] || [ $1 == "--version" ]; then
    cmd=(dartagnan --version)
else
    if [ $# -ne 3 ]; then
        echo "Usage: $0 <property.prp> <program.c|program.i> <ILP32|LP64>" >&2
        exit 1
    fi
    propertypath=$1
    programpath=$2

    case "$3" in
        ILP32) export DAT3M_COMPILER_OPTIONS="-m32" ;;
        LP64) export DAT3M_COMPILER_OPTIONS="-m64" ;;
        *) echo "Unsupported data model: $3 (expected ILP32 or LP64)" >&2; exit 1 ;;
    esac

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
