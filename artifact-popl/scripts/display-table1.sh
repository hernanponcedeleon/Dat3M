#!/bin/bash

input="table1.csv"

awk -F, '
BEGIN {
  # Color codes (optional)
  red="\033[1;31m"; reset="\033[0m";
  cross=red "❌" reset;

  # Header
  printf "%-15s | %-8s | %-10s\n", "benchmark", "result", "time";
  print "------------------------------------------";
}
NR>1 {
  benchmark=$1; result=$2; time=$3;

  gsub(/\\xmark/, cross, result);
  gsub(/^ +| +$/, "", benchmark);
  gsub(/^ +| +$/, "", result);
  gsub(/^ +| +$/, "", time);

  printf "%-15s | %-18s | %-10s\n", benchmark, result, time;
}' "$input"
