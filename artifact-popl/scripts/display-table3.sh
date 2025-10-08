#!/bin/bash

input="table3.csv"

awk -F, '
BEGIN {
  check="✅"; cross="❌"; clock="🕒";
  printf "%-14s | %-16s | %-16s | %-20s\n", "benchmark", "genmc (M)", "genmc (A)", "dartagnan (A)";
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
  printf "%-14s | %-15s | %-15s | %-20s\n", $1, $2, $3, $4;
}' "$input"
