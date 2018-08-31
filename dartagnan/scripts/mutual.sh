timeout=1800

echo "TSO"
for file in $(find benchmarks -name '*.pts' | sort);
do
   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java -Xmx128m dartagnan/Dartagnan -t tso -i $file -unroll 2 -relax)
   END=$(python -c 'import time; print time.time()')
   if [ $(echo $EXEC | grep -e "Condition" | wc -l) = 1 ]
      then
         diffPort1=$(echo "$END - $START" | bc)
      else
         diffPort1='T/O'
   fi
   echo "log - relax"
   echo \\bench{$file} $diffPort1
done

echo "POWER"
for file in $(find benchmarks -name '*.pts' | sort);
do
   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java -Xmx128m dartagnan/Dartagnan -t power -i $file -unroll 2 -relax)
   END=$(python -c 'import time; print time.time()')
   if [ $(echo $EXEC | grep -e "Condition" | wc -l) = 1 ]
      then
         diffPort1=$(echo "$END - $START" | bc)
      else
         diffPort1='T/O'
   fi
   echo "log - relax"
   echo \\bench{$file} $diffPort1
done

echo "ARM"
for file in $(find benchmarks -name '*.pts' | sort);
do
   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java -Xmx128m dartagnan/Dartagnan -t arm -i $file -unroll 2 -relax)
   END=$(python -c 'import time; print time.time()')
   if [ $(echo $EXEC | grep -e "Condition" | wc -l) = 1 ]
      then
         diffPort1=$(echo "$END - $START" | bc)
      else
         diffPort1='T/O'
   fi
   echo "log - relax"
   echo \\bench{$file} $diffPort1
done

