# Define the output files
tmp_file="prefixsum.out"
RESULTS="prefixsum.csv"

# Create a fresh tmp_file file
if [ -f "$RESULTS" ]; then
    rm "$RESULTS"
fi
echo "prefixsum, PL, progress, result, time"  >> "$RESULTS"

# List of configurations
configurations=(
    "QF=fair"
    "QF=obe"
    "QF=hsa"
    "QF=hsa_obe"
    "QF=lobe"
    "QF=unfair"
)

echo "==================================================="
echo "                    Ours (v1)                      "
echo "==================================================="

# Loop over each configuration
for config in "${configurations[@]}"; do
    
    # Print configuration
    echo $config
    progress=$(echo "$config" | grep -oP 'QF=\K[^,]+')

    # Run the command with the current configuration as a parameter
    java -DlogLevel=off -jar dartagnan/target/dartagnan.jar cat/vulkan.cat --target=vulkan benchmarks/artifact/Decoupled_Look_Back_ColumTreeBased.spv.dis --method=eager --solver=yices2 --bound=3 --wmm.analysis.relationAnalysis=lazy --modeling.progress=[$config] --property=termination > "$tmp_file"

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

    # Save result in CSV
    echo "{\it Ours (ids)}, \slang, \textsc{$progress}, $res, $time" >> "$RESULTS"
done

echo "==================================================="
echo "                    Ours (v2)                      "
echo "==================================================="

# Loop over each configuration
for config in "${configurations[@]}"; do
    
    # Print configuration
    echo $config
    progress=$(echo "$config" | grep -oP 'QF=\K[^,]+')

    # Run the command with the current configuration as a parameter
    java -DlogLevel=off -jar dartagnan/target/dartagnan.jar cat/vulkan.cat --target=vulkan benchmarks/artifact/Decoupled_Look_Back_ColumTreeBased_AtomicPartition.spv.dis --method=eager --solver=yices2 --bound=3 --wmm.analysis.relationAnalysis=lazy --modeling.progress=[$config] --property=termination > "$tmp_file"

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

    # Save result in CSV
    echo "{\it Ours (ticket)}, \slang, \textsc{$progress}, $res, $time" >> "$RESULTS"
done

echo "==================================================="
echo "                       UCSC                        "
echo "==================================================="

# Loop over each configuration
for config in "${configurations[@]}"; do
    
    # Print configuration
    echo $config
    progress=$(echo "$config" | grep -oP 'QF=\K[^,]+')

    # Run the command with the current configuration as a parameter
    java -DlogLevel=off -jar dartagnan/target/dartagnan.jar cat/vulkan.cat --target=vulkan benchmarks/artifact/prefix-scan.spvasm --method=eager --solver=yices2 --bound=2 --wmm.analysis.relationAnalysis=lazy --modeling.progress=[$config] --property=termination > "$tmp_file"

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

    # Save result in CSV
    echo "{\it UCSC (ticket)}, \opencl, \textsc{$progress}, $res, $time" >> "$RESULTS"
done

echo "==================================================="
echo "                      Vello                        "
echo "==================================================="

# Loop over each configuration
for config in "${configurations[@]}"; do
    
    # Print configuration
    echo $config
    progress=$(echo "$config" | grep -oP 'QF=\K[^,]+')

    # Run the command with the current configuration as a parameter
    java -DlogLevel=off -jar dartagnan/target/dartagnan.jar cat/vulkan.cat --target=vulkan benchmarks/artifact/Vello_Scan_ATOMIC.spv.dis --method=eager --solver=yices2 --bound=8 --wmm.analysis.relationAnalysis=lazy --modeling.progress=[$config] --property=termination > "$tmp_file"

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

    # Save result in CSV
    echo "{\it Vello (work-stealing)}, \hlsl, \textsc{$progress}, $res, $time" >> "$RESULTS"
done

rm "$tmp_file"
