timeout=1800

echo "SC -> TSO"
echo ""

for file in $(find benchmarks -name '*.pts' | sort);
do
   echo $file

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java -Xmx128m porthos/Porthos -s sc -t tso -scat cat/sc.cat -tcat cat/tso.cat -unroll 2 -i $file)
   END=$(python -c 'import time; print time.time()')
   it=$(echo $EXEC | grep -e "Iterations" | grep -oE "[1-9]+$")
   diff=$(echo "$END - $START" | bc)
   if [[ $it ]]
       then
          printf "LFP   iterations: %d  time: %s\n" $it $diff
       else
          printf "LFP   T/0\n"
   fi

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java -Xmx128m porthos/Porthos -s sc -t tso -scat cat/sc.cat -tcat cat/tso.cat -unroll 2 -i $file -idl)
   END=$(python -c 'import time; print time.time()')
   it=$(echo $EXEC | grep -e "Iterations" | grep -oE "[1-9]+$")
   diff=$(echo "$END - $START" | bc)
   if [[ $it ]]
       then
          printf "IDL   iterations: %d  time: %s\n" $it $diff
       else
          printf "IDL   T/0\n"
   fi

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java -Xmx128m porthos/Porthos -s sc -t tso -scat cat/sc.cat -tcat cat/tso.cat -unroll 2 -i $file -relax)
   END=$(python -c 'import time; print time.time()')
   it=$(echo $EXEC | grep -e "Iterations" | grep -oE "[1-9]+$")
   diff=$(echo "$END - $START" | bc)
   if [[ $it ]]
       then
          printf "RELAX iterations: %d  time: %s\n" $it $diff
       else
          printf "RELAX T/0\n"
   fi

   echo ""
done


echo "TSO -> ARM"
echo ""

for file in $(find benchmarks -name '*.pts' | sort);
do
   echo $file

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java -Xmx128m porthos/Porthos -s sc -t tso -scat cat/tso.cat -tcat cat/arm.cat -unroll 2 -i $file)
   END=$(python -c 'import time; print time.time()')
   it=$(echo $EXEC | grep -e "Iterations" | grep -oE "[1-9]+$")
   diff=$(echo "$END - $START" | bc)
   if [[ $it ]]
       then
          printf "LFP   iterations: %d  time: %s\n" $it $diff
       else
          printf "LFP   T/0\n"
   fi

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java -Xmx128m porthos/Porthos -s sc -t tso -scat cat/tso.cat -tcat cat/arm.cat -unroll 2 -i $file -idl)
   END=$(python -c 'import time; print time.time()')
   it=$(echo $EXEC | grep -e "Iterations" | grep -oE "[1-9]+$")
   diff=$(echo "$END - $START" | bc)
   if [[ $it ]]
       then
          printf "IDL   iterations: %d  time: %s\n" $it $diff
       else
          printf "IDL   T/0\n"
   fi

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java -Xmx128m porthos/Porthos -s sc -t tso -scat cat/tso.cat -tcat cat/arm.cat -unroll 2 -i $file -relax)
   END=$(python -c 'import time; print time.time()')
   it=$(echo $EXEC | grep -e "Iterations" | grep -oE "[1-9]+$")
   diff=$(echo "$END - $START" | bc)
   if [[ $it ]]
       then
          printf "RELAX iterations: %d  time: %s\n" $it $diff
       else
          printf "RELAX T/0\n"
   fi

   echo ""
done


echo "TSO -> POWER"
echo ""

for file in $(find benchmarks -name '*.pts' | sort);
do
   echo $file

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java -Xmx128m porthos/Porthos -s sc -t tso -scat cat/tso.cat -tcat cat/power.cat -unroll 2 -i $file)
   END=$(python -c 'import time; print time.time()')
   it=$(echo $EXEC | grep -e "Iterations" | grep -oE "[1-9]+$")
   diff=$(echo "$END - $START" | bc)
   if [[ $it ]]
       then
          printf "LFP   iterations: %d  time: %s\n" $it $diff
       else
          printf "LFP   T/0\n"
   fi

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java -Xmx128m porthos/Porthos -s sc -t tso -scat cat/tso.cat -tcat cat/power.cat -unroll 2 -i $file -idl)
   END=$(python -c 'import time; print time.time()')
   it=$(echo $EXEC | grep -e "Iterations" | grep -oE "[1-9]+$")
   diff=$(echo "$END - $START" | bc)
   if [[ $it ]]
       then
          printf "IDL   iterations: %d  time: %s\n" $it $diff
       else
          printf "IDL   T/0\n"
   fi

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java -Xmx128m porthos/Porthos -s sc -t tso -scat cat/tso.cat -tcat cat/power.cat -unroll 2 -i $file -relax)
   END=$(python -c 'import time; print time.time()')
   it=$(echo $EXEC | grep -e "Iterations" | grep -oE "[1-9]+$")
   diff=$(echo "$END - $START" | bc)
   if [[ $it ]]
       then
          printf "RELAX iterations: %d  time: %s\n" $it $diff
       else
          printf "RELAX T/0\n"
   fi

   echo ""
done