#!/bin/bash

usage() {
    cat >&2 <<EOF
Usage: $0 [options] <property.prp> <program.c|program.i>
       $0 --version

Options (in any order, also after the positional arguments):
  --data-model=<ILP32|LP64>  data model of the program (default: LP64)
  --witness=<witness.yml>    validate the given violation witness
EOF
}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

export DAT3M_HOME="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
export DAT3M_OUTPUT=$DAT3M_HOME/output

if [ "$1" == "-v" ] || [ "$1" == "--version" ]; then
    cmd=("$DAT3M_HOME/dartagnan/target/dartagnan" --version)
else
    positional=()
    data_model=""
    witnesspath=""
    while [ $# -gt 0 ]; do
        case "$1" in
            --data-model=*)
                data_model=${1#--data-model=}
                ;;
            -witness)
                # Not shown in the usage: BenchExec's tool-info passes the witness in this form.
                if [ $# -lt 2 ]; then
                    echo "Missing value for -witness" >&2
                    usage
                    exit 1
                fi
                witnesspath=$2
                shift
                ;;
            --witness=*)
                witnesspath=${1#--witness=}
                if [ -z "$witnesspath" ]; then
                    echo "Missing value for --witness" >&2
                    usage
                    exit 1
                fi
                ;;
            --)
                shift
                positional+=("$@")
                break
                ;;
            --?*=*)
                # Unknown option, possibly added by a newer caller: ignore it.
                echo "Ignoring unknown option: $1" >&2
                ;;
            -*)
                echo "Unknown option: $1 (options must have the form --key=value)" >&2
                usage
                exit 1
                ;;
            *)
                positional+=("$1")
                ;;
        esac
        shift
    done

    if [ ${#positional[@]} -ne 2 ]; then
        usage
        exit 1
    fi
    propertypath=${positional[0]}
    programpath=${positional[1]}

    case "${data_model:-LP64}" in
        ILP32) export DAT3M_COMPILER_OPTIONS="-m32" ;;
        LP64) export DAT3M_COMPILER_OPTIONS="-m64" ;;
        *) echo "Unsupported data model: $data_model (expected ILP32 or LP64)" >&2; exit 1 ;;
    esac

    cmd=("$DAT3M_HOME/svcomp/target/svcomp")
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
    if [ -n "$witnesspath" ]; then
        cmd+=("--validate=$witnesspath")
    fi
    cmd+=("$DAT3M_HOME/cat/svcomp.cat" "--svcomp.property=$propertypath" "$programpath")
fi
exec "${cmd[@]}"
