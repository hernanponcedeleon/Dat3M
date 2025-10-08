#!/bin/bash

input="table4.csv"

awk -F, '
BEGIN {
  check="✅"
  cross="❌"
  printf "\n%-30s | %-10s | %-12s | %-12s\n", "Prefixsum", "Scheduler", "Terminates", "Time"
  print "-------------------------------------------------------------------"
}
NR > 1 {
  prefix=$1
  bound=$2
  progress=$3
  result=$4
  time=$5

  # --- Clean LaTeX formatting ---
  while (match(prefix, /\{\\it[[:space:]]*([^}]*)\}/)) {
    inner = substr(prefix, RSTART+5, RLENGTH-6)
    sub(/\{\\it[[:space:]]*[^}]*\}/, inner, prefix)
  }
  while (match(progress, /\\textsc\{[^}]*\}/)) {
    inner = substr(progress, RSTART+8, RLENGTH-9)
    sub(/\\textsc\{[^}]*\}/, inner, progress)
  }

  # --- Trim spaces ---
  sub(/^ +/, "", prefix); sub(/ +$/, "", prefix)
  sub(/^ +/, "", bound); sub(/ +$/, "", bound)
  sub(/^ +/, "", progress); sub(/ +$/, "", progress)
  sub(/^ +/, "", result); sub(/ +$/, "", result)
  sub(/^ +/, "", time); sub(/ +$/, "", time)

  # --- Replace marks with emojis ---
  gsub(/\\cmark/, check, result)
  gsub(/\\xmark/, cross, result)

  # --- Merge bound with time ---
  time = time " (B=" bound ")"

  # --- Print row ---
  printf "%-30s | %-10s | %-11s | %-12s\n", prefix, progress, result, time
}
END {
  print "-------------------------------------------------------------------\n"
}' "$input"
