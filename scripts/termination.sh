#!/bin/bash

# Check if a directory is passed as an argument
if [ "$#" -ne 5 ]; then
  echo "Usage: $0 <directory> <output> <run_genmc> <run_await_while> <timeout>"
  exit 1
fi

# Process inputs
DIR="$1"
RESULTS="$2"
RUNGENMC="$3"
MANUAL="$4"
TIMEOUT="$5"

# Check if the directory exists
if [ ! -d "$DIR" ]; then
  echo "Directory $DIR does not exist!"
  exit 2
fi

# Create a fresh results file
if [ -f "$RESULTS" ]; then
    rm "$RESULTS"
fi
if [ "$MANUAL" == "true" ]; then
    echo "benchmark, tool, spinloop detection, spinloop annotation, result, time"  >> "$RESULTS"
else
    echo "benchmark, tool, result, time"  >> "$RESULTS"
fi

# Iterate through all files in the directory
for file in "$DIR"*.c; do
  # Check if it's a regular file (not a directory)
  if [ -f "$file" ]; then
    echo "Running model checker on file: $file"

    # Get base file name
    base=$(basename "$file")
    benchmark="${base%.c}"

    if [ "$RUNGENMC" == "true" ] && [ "$MANUAL" == "true" ]; then
        # Run genmc (with loop annotation)
        tool="\genmc"
        out=$(timeout $TIMEOUT genmc -imm -check-liveness -disable-estimation -disable-spin-assume -- -DVSYNC_VERIFICATION -DUSE_GENMC -I $LIBVSYNC_HOME/test/include -I $DAT3M_HOME/benchmarks/locks "$file" 2> /dev/null)

        # Capture the exit code
        exit_code=$?

        # Extract time
        time=$(echo "$out" | tail -1 | sed -n 's/.*Total wall-clock time: *\([0-9.]*\)s$/\1 secs/p')
        if [ -z "$time" ]; then
            time="?"
        fi

        # Default results
        res="?"

        # Adapt output
        if [[ "$exit_code" == 124 ]]; then
            time="\clock"
            res="N/A"
        fi
        if [[ "$exit_code" == 1 ]]; then
            time="N/A"
            res="N/A"
        fi
        if [[ "$out" =~ "No errors were detected" ]]; then
            res="\cmark"
        fi
        if [[ "$out" =~ "Liveness violation" ]]; then
            res="\xmark"
        fi
        if [ "$MANUAL" == "true" ]; then
            echo "$benchmark, $tool, \xmark, \cmark, $res, $time" >> "$RESULTS"
        else
            echo "$benchmark, $tool, $res, $time" >> "$RESULTS"
        fi
    fi
    
    if [ "$RUNGENMC" == "true" ]; then
        # Run genmc (without loop annotation)
        tool="\genmc"
        out=$(timeout $TIMEOUT genmc -imm -check-liveness -disable-estimation -- -DVSYNC_VERIFICATION -DVSYNC_DISABLE_SPIN_ANNOTATION -DUSE_GENMC -I $LIBVSYNC_HOME/test/include -I $DAT3M_HOME/benchmarks/locks "$file" 2> /dev/null)

        # Capture the exit code
        exit_code=$?

        # Extract time
        time=$(echo "$out" | tail -1 | sed -n 's/.*Total wall-clock time: *\([0-9.]*\)s$/\1 secs/p')
        if [ -z "$time" ]; then
            time="?"
        fi
    
        # Default results
        res="?"

        # Adapt output
        if [[ "$exit_code" == 124 ]]; then
            time="\clock"
            res="N/A"
        fi
        if [[ "$exit_code" == 139 ]]; then
            time="N/A"
            res="N/A"
        fi
        if [[ "$out" =~ "No errors were detected" ]]; then
            res="\cmark"
        fi
        if [[ "$out" =~ "Liveness violation" ]]; then
            res="\xmark"
        fi
        if [ "$MANUAL" == "true" ]; then
            echo "$benchmark, $tool, \cmark, \xmark, $res, $time" >> "$RESULTS"
        else
            echo "$benchmark, $tool, $res, $time" >> "$RESULTS"
        fi
    fi

    # Run dartagnan
    tool="\dartagnan"

    # Use a larger unrolling bound for hmcslock
    if [[ "$benchmark" == "hmcslock" ]]; then
        bound=8
    else
        bound=4
    fi

    out=$(CFLAGS="-DVSYNC_VERIFICATION -DVSYNC_VERIFICATION_DAT3M -DVSYNC_DISABLE_SPIN_ANNOTATION -DTWA_A=128 -I $LIBVSYNC_HOME/test/include -I $DAT3M_HOME/benchmarks/locks" timeout $TIMEOUT java -jar ${DAT3M_HOME}/dartagnan/target/dartagnan.jar --property=termination $DAT3M_HOME/cat/imm.cat --bound=$bound --modeling.recursionBound=$bound "$file" 2> /dev/null)
    
    # Capture the exit code
    exit_code=$?

    # Extract time
    time=$(echo "$out" | tail -1 | sed -n 's/.*Time: *//p')
    if [ -z "$time" ]; then
        time="?"
    fi
    
    # Default results
    res="?"

    # Adapt output
    if [[ "$exit_code" == 124 ]]; then
        time="\clock"
        res="N/A"
    fi
    if [[ "$exit_code" == 1 ]]; then
        time="N/A"
        res="N/A"
    fi
    if [[ "$out" =~ "PASS" ]]; then
        res="\cmark"
    fi
    if [[ "$out" =~ "Termination violation found" ]]; then
        res="\xmark"
    fi
    if [ "$MANUAL" == "true" ]; then
        echo "$benchmark, $tool, \cmark, \xmark, $res, $time" >> "$RESULTS"
    else
        echo "$benchmark, $tool, $res, $time" >> "$RESULTS"
    fi

    echo
  fi
done