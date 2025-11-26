#!/bin/bash

# Check if a directory is passed as an argument
if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <directory> <output> <run_genmc> <timeout>"
  exit 1
fi

# Process inputs
DIR="$1"
RESULTS="$2"
RUNGENMC="$3"
TIMEOUT="$4"

format_dat3m_time() {
  local input="$1"

  if [[ "$input" == *"mins"* ]]; then
    local min="${input%%:*}"
    local sec_part="${input#*:}"
    local sec="${sec_part%% *}"
    min=$((10#$min))
    sec=$((10#$sec))
    local rounded=$(printf "%dm %ds\n" "$min" "$sec")
    echo "${rounded}"

  elif [[ "$input" == *"secs"* ]]; then
    local secs="${input%% *}"
    local rounded=$(printf "%.1f" "$secs")
    echo "${rounded}s"

  else
    echo "Invalid format: $input" >&2
    return 1
  fi
}

format_genmc_time() {
  local input="$1"

  local secs=$(echo "$input" | sed -E 's/[^0-9.]+//g')

  if [[ ! "$secs" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    echo "Invalid input: $input" >&2
    return 1
  fi

  if (( $(echo "$secs < 60" | bc -l) )); then
    printf "%.1fs\n" "$secs"
  else
    local minutes=$(echo "$secs / 60" | bc)
    local remaining=$(echo "$secs - ($minutes * 60)" | bc -l)
    local rounded_remaining=$(printf "%.0f" "$remaining")
    echo "${minutes}m ${rounded_remaining}s"
  fi
}

# Check if the directory exists
if [ ! -d "$DIR" ]; then
  echo "Directory $DIR does not exist!"
  exit 2
fi

# Create a fresh results file
if [ -f "$RESULTS" ]; then
    rm "$RESULTS"
fi
if [ "$RUNGENMC" == "true" ]; then
    echo "benchmark, genmc (M), genmc (A), dartagnan (A)"  >> "$RESULTS"
else
    echo "benchmark, result, time"  >> "$RESULTS"
fi

# Iterate through all files in the directory
for file in "$DIR"*.c; do
  # Check if it's a regular file (not a directory)
  if [ -f ${file} ]; then
    echo "Running model checker on file: $file"

    # Get base file name
    base=$(basename ${file})
    benchmark="${base%.c}"
    line=$benchmark

    if [ "$RUNGENMC" == "true" ]; then
        # Run genmc (with loop annotation)
        tool="\genmc"
        out=$(timeout ${TIMEOUT} genmc -imm -check-liveness -disable-estimation -disable-spin-assume -- -DVSYNC_VERIFICATION -DVSYNC_VERIFICATION_QUICK -I ${LIBVSYNC_HOME}/test/include -I ${LIBVSYNC_HOME}/include/ -I ${LIBVSYNC_HOME}/vatomic/include ${file} 2> /dev/null)

        # Capture the exit code
        exit_code=$?

        # Default result
        res="N/A"

        # Extract time
        time=$(echo "$out" | tail -1 | sed -n 's/.*Total wall-clock time: *\([0-9.]*\)s$/\1 secs/p')
        if [ -z "$time" ]; then
            time="N/A"
        else
            time=$(format_genmc_time "$time")
        fi

        # Adapt output
        if [[ "$exit_code" == 124 ]]; then
            time="\clock"
        fi
        if [[ "$out" =~ "No errors were detected" ]]; then
            res="\cmark"
        fi
        if [[ "$out" =~ "Liveness violation" ]]; then
            res="\xmark"
        fi

        if [ "$time" == "\clock" ]; then
            line="$line, $time"
        else
            line="$line, $res\ ($time)"
        fi

        # Run genmc (without loop annotation)
        tool="\genmc"
        out=$(timeout ${TIMEOUT} genmc -imm -check-liveness -disable-estimation -- -DVSYNC_VERIFICATION -DVSYNC_VERIFICATION_QUICK -DVSYNC_DISABLE_SPIN_ANNOTATION -I ${LIBVSYNC_HOME}/test/include -I ${LIBVSYNC_HOME}/include/ -I ${LIBVSYNC_HOME}/vatomic/include ${file} 2> /dev/null)

        # Capture the exit code
        exit_code=$?

        # Default results
        res="N/A"

        # Extract time
        time=$(echo "$out" | tail -1 | sed -n 's/.*Total wall-clock time: *\([0-9.]*\)s$/\1 secs/p')
        if [ -z "$time" ]; then
            time="N/A"
        else
            time=$(format_genmc_time "$time")
        fi

        # Adapt output
        if [[ "$exit_code" == 124 ]]; then
            time="\clock"
        fi
        if [[ "$out" =~ "No errors were detected" ]]; then
            res="\cmark"
        fi
        if [[ "$out" =~ "Liveness violation" ]]; then
            res="\xmark"
        fi

        if [ "$time" == "\clock" ]; then
            line="$line, $time"
        else
            line="$line, $res\ ($time)"
        fi
    fi

    # Run dartagnan
    tool="\dartagnan"

    if [[ "$benchmark" == "cnalock" || "$benchmark" == "hclhlock" || "$benchmark" == "mcslock" || "$benchmark" == "twalock" ]]; then
        # This bound is enough in most of the cases to find the bug
        bound=2
    elif [[ "$benchmark" == "hmcslock" ]]; then
        # Use a larger unrolling bound for hmcslock
        bound=8
    else
        # Force full exploration for all other benchmarks
        bound=4
    fi

    out=$(CFLAGS="-DVSYNC_VERIFICATION -DVSYNC_VERIFICATION_QUICK -DVSYNC_VERIFICATION_DAT3M -DVSYNC_DISABLE_SPIN_ANNOTATION -DTWA_A=128 -I ${LIBVSYNC_HOME}/test/include -I ${LIBVSYNC_HOME}/include/ -I ${LIBVSYNC_HOME}/vatomic/include" timeout ${TIMEOUT} java -jar ${DAT3M_HOME}/dartagnan/target/dartagnan.jar --solver=${SMTSOLVER} --property=termination ${DAT3M_HOME}/cat/imm.cat --bound=${bound} --modeling.recursionBound=${bound} ${file} 2> /dev/null)

    # Capture the exit code
    exit_code=$?

    # Default results
    res="N/A"

    # Extract time
    time=$(echo "$out" | tail -1 | sed -n 's/.*Time: *//p')
    if [ -z "$time" ]; then
        time="N/A"
    else
        time=$(format_dat3m_time "$time")
    fi

    # Adapt output
    if [[ "$exit_code" == 124 ]]; then
        time="\clock"
    fi
    if [[ "$out" =~ "PASS" ]]; then
        res="\cmark"
    fi
    if [[ "$out" =~ "Termination violation found" ]]; then
        res="\xmark"
    fi

    if [ "$RUNGENMC" == "true" ]; then
        if [[ "$time" == "\clock" || "$time" == "N/A" ]]; then

            line="$line, $time / B=${bound}"
        else
            line="$line, $res\ ($time / B=${bound})"
        fi
        echo $line >> "$RESULTS"
    else
        echo "$benchmark, $res, $time" >> "$RESULTS"
    fi

    echo
  fi
done