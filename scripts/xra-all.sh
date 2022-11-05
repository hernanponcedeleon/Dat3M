#!/bin/bash
 
LOGS_FOLDER=$1

bash scripts/xra-tso.sh $LOGS_FOLDER
bash scripts/xra-arm8.sh $LOGS_FOLDER
bash scripts/xra-riscv.sh $LOGS_FOLDER
bash scripts/xra-power.sh $LOGS_FOLDER
