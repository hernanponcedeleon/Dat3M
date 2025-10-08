#!/bin/bash

printf "%6s | %6s | %8s | %7s\n" "PASS" "FAIL" "UNKNOWN" "ERROR"
echo "--------------------------------------"

for f in table2-r*.txt; do
  pass=$(grep -c PASS "$f")
  fail=$(grep -c FAIL "$f")
  unk=$(grep -c UNKNOWN "$f")
  err=$(grep -c ERROR "$f")
  printf "%6d | %6d | %8d | %7d\n" "$pass" "$fail" "$unk" "$err"
done
