#!/bin/bash

input="table4.csv"

awk -F, '
BEGIN {
  check="✅"; cross="❌";
  printf "%-21s | %-10s | %-8s | %-10s\n", "prefixsum", "progress", "result", "time";
  print "-----------------------------------------------------------";
}
NR>1 {
  prefix=$1; progress=$3; result=$4; time=$5;

  # --- Clean LaTeX formatting ---
  prefix = gensub(/\{\\it ([^}]*)\}/, "\\1", "g", prefix);     # remove {\it ...}
  progress = gensub(/\\textsc\{([^}]*)\}/, "\\1", "g", progress); # remove \textsc{...}

  gsub(/\\cmark/, check, result);   # replace \cmark
  gsub(/\\xmark/, cross, result);   # replace \xmark

  # Trim spaces
  gsub(/^ +| +$/, "", prefix);
  gsub(/^ +| +$/, "", progress);
  gsub(/^ +| +$/, "", result);
  gsub(/^ +| +$/, "", time);

  printf "%-21s | %-10s | %-8s | %-10s\n", prefix, progress, result, time;
}' "$input"
