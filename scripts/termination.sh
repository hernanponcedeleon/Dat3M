#!/bin/bash

# Check if a directory is passed as an argument
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <directory> <output>"
  exit 1
fi

# Directory to process (from the first argument)
DIR="$1"
RESULTS="$2"

TIMEOUT=120

# Check if the directory exists
if [ ! -d "$DIR" ]; then
  echo "Directory $DIR does not exist!"
  exit 2
fi

# Create a fresh results file
if [ -f "$RESULTS" ]; then
    rm "$RESULTS"
fi
echo "benchmark, tool, spinloop detection, spinloop annotation, result, time"  >> "$RESULTS"

# Iterate through all files in the directory
for file in "$DIR"*.c; do
  # Check if it's a regular file (not a directory)
  if [ -f "$file" ]; then
    echo "Running model checker on file: $file"

    # Get base file name
    benchmark=$(basename "$file")
    
    # Run genmc (without loop annotation)
    tool="\genmc"
    out=$(timeout $TIMEOUT genmc -check-liveness -disable-estimation -- -DVSYNC_VERIFICATION -DVSYNC_DISABLE_SPIN_ANNOTATION -DUSE_GENMC -I $LIBVSYNC_HOME/test/include -I $DAT3M_HOME/benchmarks/locks "$file" 2> /dev/null)

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
    echo "$benchmark, $tool, \cmark, \xmark, $res, $time" >> "$RESULTS"

    # Run genmc (with loop annotation)
    tool="\genmc"
    out=$(timeout $TIMEOUT genmc -check-liveness -disable-estimation -disable-spin-assume -- -DVSYNC_VERIFICATION -DUSE_GENMC -I $LIBVSYNC_HOME/test/include -I $DAT3M_HOME/benchmarks/locks "$file" 2> /dev/null)

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
    echo "$benchmark, $tool, \xmark, \cmark, $res, $time" >> "$RESULTS"

    # Run dartagnan
    tool="\dartagnan"
    out=$(CFLAGS="-DVSYNC_VERIFICATION -DVSYNC_VERIFICATION_DAT3M -DVSYNC_DISABLE_SPIN_ANNOTATION -I $LIBVSYNC_HOME/test/include -I $DAT3M_HOME/benchmarks/locks" timeout $TIMEOUT java -jar ${DAT3M_HOME}/dartagnan/target/dartagnan.jar --property=termination $DAT3M_HOME/cat/imm.cat --bound=4 "$file" 2> /dev/null)
    
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
    echo "$benchmark, $tool, \cmark, \xmark, $res, $time" >> "$RESULTS"

    echo
  fi
done