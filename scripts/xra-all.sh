#!/bin/bash
 
bash $DAT3M_HOME/scripts/xra.sh aarch64.cat ARM8
bash $DAT3M_HOME/scripts/xra.sh riscv.cat RISCV
bash $DAT3M_HOME/scripts/xra.sh linux-kernel.cat LKMM

python3 $DAT3M_HOME/scripts/plot-xra.py

echo "combination,may-set,must-set,unknown,act-set,smt-vars,acyc-size,veri-time,safe,live,race" > $DAT3M_OUTPUT/Stats.csv
echo "############ ARMv8 ############" >> $DAT3M_OUTPUT/Stats.csv
tail -n +2 $DAT3M_OUTPUT/csv/ARM8-Stats.csv >> $DAT3M_OUTPUT/Stats.csv
echo "############ RISC-V ############" >> $DAT3M_OUTPUT/Stats.csv
tail -n +2 $DAT3M_OUTPUT/csv/RISCV-Stats.csv >> $DAT3M_OUTPUT/Stats.csv
echo "############ LKMM-v6.3 ############" >> $DAT3M_OUTPUT/Stats.csv
tail -n +2 $DAT3M_OUTPUT/csv/LKMM-Stats.csv >> $DAT3M_OUTPUT/Stats.csv
