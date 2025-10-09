#!/bin/bash

# Define the output files
tmp_file="prefixsum.out"
RESULTS="table3.csv"

# Create a fresh tmp_file file
if [ -f "$RESULTS" ]; then
    rm "$RESULTS"
fi
echo "prefixsum, bound, progress, result, time"  >> "$RESULTS"

# List of configurations
configurations=(
    "QF=fair"
    "QF=obe"
    "QF=hsa"
    "QF=hsa_obe"
    "QF=lobe"
    "QF=unfair"
)

format_time() {
  local input="$1"

  if [[ "$input" == *"mins"* ]]; then
    local min="${input%%:*}"
    local sec_part="${input#*:}"
    local sec="${sec_part%% *}"
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

echo "==================================================="
echo "                    Ours (Id)                      "
echo "==================================================="

# Loop over each configuration
for config in "${configurations[@]}"; do

    # Print configuration
    echo $config
    progress=$(echo "$config" | grep -oP 'QF=\K[^,]+')
    bound=3

    # Run the command with the current configuration as a parameter
    java -DlogLevel=off -jar $DAT3M_HOME/dartagnan/target/dartagnan.jar $DAT3M_HOME/cat/vulkan.cat --target=vulkan $DAT3M_HOME/artifact-popl/benchmarks/prefixsum/Ours-Id.spvasm --method=eager --bound=$bound --wmm.analysis.relationAnalysis=lazy --modeling.progress=[$config] --property=termination > "$tmp_file"

    # Compute and print result and time
    out=$(cat "$tmp_file")
    echo $out
    echo
    res=$(echo "$out" | grep '^Result:' | cut -d' ' -f2)
    if [ "$res" = "PASS" ]; then
        res="\cmark"
    elif [ "$res" = "FAIL" ]; then
        res="\xmark"
    else
        res="?"
    fi
    time=$(echo "$out" | grep '^Time:' | cut -d' ' -f2-)
    time=$(format_time "$time")

    # Save result in CSV
    echo "{\it Ours (ids)}, $bound, \textsc{$progress}, $res, $time" >> "$RESULTS"
done

echo "==================================================="
echo "                  Ours (Ticket)                    "
echo "==================================================="

# Loop over each configuration
for config in "${configurations[@]}"; do

    # Print configuration
    echo $config
    progress=$(echo "$config" | grep -oP 'QF=\K[^,]+')
    bound=3

    # Run the command with the current configuration as a parameter
    java -DlogLevel=off -jar $DAT3M_HOME/dartagnan/target/dartagnan.jar $DAT3M_HOME/cat/vulkan.cat --target=vulkan $DAT3M_HOME/artifact-popl/benchmarks/prefixsum/Ours-Ticket.spvasm --method=eager --bound=$bound --wmm.analysis.relationAnalysis=lazy --modeling.progress=[$config] --property=termination > "$tmp_file"

    # Compute and print result and time
    out=$(cat "$tmp_file")
    echo $out
    echo
    res=$(echo "$out" | grep '^Result:' | cut -d' ' -f2)
    if [ "$res" = "PASS" ]; then
        res="\cmark"
    elif [ "$res" = "FAIL" ]; then
        res="\xmark"
    else
        res="?"
    fi
    time=$(echo "$out" | grep '^Time:' | cut -d' ' -f2-)
    time=$(format_time "$time")

    # Save result in CSV
    echo "{\it Ours (ticket)}, $bound, \textsc{$progress}, $res, $time" >> "$RESULTS"
done

echo "==================================================="
echo "                       UCSC                        "
echo "==================================================="

# Loop over each configuration
for config in "${configurations[@]}"; do

    # Print configuration
    echo $config
    progress=$(echo "$config" | grep -oP 'QF=\K[^,]+')
    bound=2

    # Run the command with the current configuration as a parameter
    java -DlogLevel=off -jar $DAT3M_HOME/dartagnan/target/dartagnan.jar $DAT3M_HOME/cat/vulkan.cat --target=vulkan $DAT3M_HOME/artifact-popl/benchmarks/prefixsum/UCSC.spvasm --method=eager --bound=$bound --wmm.analysis.relationAnalysis=lazy --modeling.progress=[$config] --property=termination > "$tmp_file"

    # Compute and print result and time
    out=$(cat "$tmp_file")
    echo $out
    echo
    res=$(echo "$out" | grep '^Result:' | cut -d' ' -f2)
    if [ "$res" = "PASS" ]; then
        res="\cmark"
    elif [ "$res" = "FAIL" ]; then
        res="\xmark"
    else
        res="?"
    fi
    time=$(echo "$out" | grep '^Time:' | cut -d' ' -f2-)
    time=$(format_time "$time")

    # Save result in CSV
    echo "{\it UCSC (ticket)}, $bound, \textsc{$progress}, $res, $time" >> "$RESULTS"
done

echo "==================================================="
echo "                      Vello                        "
echo "==================================================="

# Loop over each configuration
for config in "${configurations[@]}"; do

    # Print configuration
    echo $config
    progress=$(echo "$config" | grep -oP 'QF=\K[^,]+')
    bound=8

    # Run the command with the current configuration as a parameter
    java -DlogLevel=off -jar $DAT3M_HOME/dartagnan/target/dartagnan.jar $DAT3M_HOME/cat/vulkan.cat --target=vulkan $DAT3M_HOME/artifact-popl/benchmarks/prefixsum/Vello.spvasm --method=eager --bound=$bound --wmm.analysis.relationAnalysis=lazy --modeling.progress=[$config] --property=termination > "$tmp_file"

    # Compute and print result and time
    out=$(cat "$tmp_file")
    echo $out
    echo
    res=$(echo "$out" | grep '^Result:' | cut -d' ' -f2)
    if [ "$res" = "PASS" ]; then
        res="\cmark"
    elif [ "$res" = "FAIL" ]; then
        res="\xmark"
    else
        res="?"
    fi
    time=$(echo "$out" | grep '^Time:' | cut -d' ' -f2-)
    time=$(format_time "$time")

    # Save result in CSV
    echo "{\it Vello (ticket)}, $bound, \textsc{$progress}, $res, $time" >> "$RESULTS"
done

rm "$tmp_file"