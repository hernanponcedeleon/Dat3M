#!/bin/bash

input="table2.csv"

awk -F, '
BEGIN {
  check="✅"; cross="❌"; clock="🕒";
  printf "%-14s | %-12s | %-14s | %-20s\n", "Benchmark", "Genmc (M)", "Genmc (A)", "Dartagnan (A)";
  print "--------------------------------------------------------------------------";
}
NR>1 {
  for (i=1; i<=NF; i++) {
    gsub(/\\cmark\\/, check, $i);
    gsub(/\\xmark\\/, cross, $i);
    gsub(/\\clock/, clock, $i);
    gsub(/\\[[:space:]]/, " ", $i);
    gsub(/\\\(/, "(", $i);
    gsub(/\\$/, "", $i);
    gsub(/^ +| +$/, "", $i);
  }
  printf "%-14s | %-11s | %-13s | %-20s\n", $1, $2, $3, $4;
}' "$input"
