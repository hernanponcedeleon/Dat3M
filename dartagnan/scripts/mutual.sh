timeout=5

printf "Timeout %d seconds\n\n" $timeout

printf "SC -> TSO\n\n"

for file in $(find benchmarks -name '*.pts' | sort);
do
   printf "%s\n" $file

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java -Xmx128m porthos/Porthos -s sc -t tso -scat cat/sc.cat -tcat cat/tso.cat -unroll 2 -i $file)
   END=$(python -c 'import time; print time.time()')
   raw=$(echo $EXEC)
   if [[ ! -z $raw ]]
       then
          [[ $(echo $raw | grep -e "not" | wc -l) = 0 ]] && status="portable" || status="not portable"
          it=$(echo $raw | grep "Iterations" | grep -oE "[0-9]+$")
          diff=$(echo "$END - $START" | bc)
          printf "LFP   iterations: %3d  time: %6s    - %s\n" $it $diff "${status}"
       else
          printf "LFP   T/0\n"
   fi

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java -Xmx128m porthos/Porthos -s sc -t tso -scat cat/sc.cat -tcat cat/tso.cat -unroll 2 -i $file -idl)
   END=$(python -c 'import time; print time.time()')
   raw=$(echo $EXEC)
   if [[ ! -z $raw ]]
       then
          [[ $(echo $raw | grep -e "not" | wc -l) = 0 ]] && status="portable" || status="not portable"
          it=$(echo $raw | grep "Iterations" | grep -oE "[0-9]+$")
          diff=$(echo "$END - $START" | bc)
          printf "IDL   iterations: %3d  time: %6s    - %s\n" $it $diff "${status}"
       else
          printf "IDL   T/0\n"
   fi

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java -Xmx128m porthos/Porthos -s sc -t tso -scat cat/sc.cat -tcat cat/tso.cat -unroll 2 -i $file -relax)
   END=$(python -c 'import time; print time.time()')
   raw=$(echo $EXEC)
   if [[ ! -z $raw ]]
       then
          [[ $(echo $raw | grep -e "not" | wc -l) = 0 ]] && status="portable" || status="not portable"
          it=$(echo $raw | grep "Iterations" | grep -oE "[0-9]+$")
          diff=$(echo "$END - $START" | bc)
          printf "RELAX iterations: %3d  time: %6s    - %s\n" $it $diff "${status}"
       else
          printf "RELAX T/0\n"
   fi

   printf "\n"
done


printf "TSO -> ARM\n\n"

for file in $(find benchmarks -name '*.pts' | sort);
do
   printf "%s\n" $file

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java -Xmx128m porthos/Porthos -s sc -t tso -scat cat/tso.cat -tcat cat/arm.cat -unroll 2 -i $file)
   END=$(python -c 'import time; print time.time()')
   raw=$(echo $EXEC)
   if [[ ! -z $raw ]]
       then
          [[ $(echo $raw | grep -e "not" | wc -l) = 0 ]] && status="portable" || status="not portable"
          it=$(echo $raw | grep "Iterations" | grep -oE "[0-9]+$")
          diff=$(echo "$END - $START" | bc)
          printf "LFP   iterations: %3d  time: %6s    - %s\n" $it $diff "${status}"
       else
          printf "LFP   T/0\n"
   fi

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java -Xmx128m porthos/Porthos -s sc -t tso -scat cat/tso.cat -tcat cat/arm.cat -unroll 2 -i $file -idl)
   END=$(python -c 'import time; print time.time()')
   raw=$(echo $EXEC)
   if [[ ! -z $raw ]]
       then
          [[ $(echo $raw | grep -e "not" | wc -l) = 0 ]] && status="portable" || status="not portable"
          it=$(echo $raw | grep "Iterations" | grep -oE "[0-9]+$")
          diff=$(echo "$END - $START" | bc)
          printf "IDL   iterations: %3d  time: %6s    - %s\n" $it $diff "${status}"
       else
          printf "IDL   T/0\n"
   fi

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java -Xmx128m porthos/Porthos -s sc -t tso -scat cat/tso.cat -tcat cat/arm.cat -unroll 2 -i $file -relax)
   END=$(python -c 'import time; print time.time()')
   raw=$(echo $EXEC)
   if [[ ! -z $raw ]]
       then
          [[ $(echo $raw | grep -e "not" | wc -l) = 0 ]] && status="portable" || status="not portable"
          it=$(echo $raw | grep "Iterations" | grep -oE "[0-9]+$")
          diff=$(echo "$END - $START" | bc)
          printf "RELAX iterations: %3d  time: %6s    - %s\n" $it $diff "${status}"
       else
          printf "RELAX T/0\n"
   fi

   printf "\n"
done


printf "TSO -> POWER\n\n"

for file in $(find benchmarks -name '*.pts' | sort);
do
   printf "%s\n" $file

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java -Xmx128m porthos/Porthos -s sc -t tso -scat cat/tso.cat -tcat cat/power.cat -unroll 2 -i $file)
   END=$(python -c 'import time; print time.time()')
   raw=$(echo $EXEC)
   if [[ ! -z $raw ]]
       then
          [[ $(echo $raw | grep -e "not" | wc -l) = 0 ]] && status="portable" || status="not portable"
          it=$(echo $raw | grep "Iterations" | grep -oE "[0-9]+$")
          diff=$(echo "$END - $START" | bc)
          printf "LFP   iterations: %3d  time: %6s    - %s\n" $it $diff "${status}"
       else
          printf "LFP   T/0\n"
   fi

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java -Xmx128m porthos/Porthos -s sc -t tso -scat cat/tso.cat -tcat cat/power.cat -unroll 2 -i $file -idl)
   END=$(python -c 'import time; print time.time()')
   raw=$(echo $EXEC)
   if [[ ! -z $raw ]]
       then
          [[ $(echo $raw | grep -e "not" | wc -l) = 0 ]] && status="portable" || status="not portable"
          it=$(echo $raw | grep "Iterations" | grep -oE "[0-9]+$")
          diff=$(echo "$END - $START" | bc)
          printf "IDL   iterations: %3d  time: %6s    - %s\n" $it $diff "${status}"
       else
          printf "IDL   T/0\n"
   fi

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java -Xmx128m porthos/Porthos -s sc -t tso -scat cat/tso.cat -tcat cat/power.cat -unroll 2 -i $file -relax)
   END=$(python -c 'import time; print time.time()')
   raw=$(echo $EXEC)
   if [[ ! -z $raw ]]
       then
          [[ $(echo $raw | grep -e "not" | wc -l) = 0 ]] && status="portable" || status="not portable"
          it=$(echo $raw | grep "Iterations" | grep -oE "[0-9]+$")
          diff=$(echo "$END - $START" | bc)
          printf "RELAX iterations: %3d  time: %6s    - %s\n" $it $diff "${status}"
       else
          printf "RELAX T/0\n"
   fi

   printf "\n"
done