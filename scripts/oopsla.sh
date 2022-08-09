#!/bin/bash

if [ -z "$1" ]; then
  SOLVER=z3
else
  SOLVER=$1
fi

bash $DAT3M_HOME/scripts/tso.sh $SOLVER
bash $DAT3M_HOME/scripts/arm8.sh $SOLVER
bash $DAT3M_HOME/scripts/power.sh $SOLVER
bash $DAT3M_HOME/scripts/riscv.sh $SOLVER
bash $DAT3M_HOME/scripts/imm.sh $SOLVER
bash $DAT3M_HOME/scripts/rc11.sh $SOLVER
