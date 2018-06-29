timeout=180

echo "TSO"
for file in benchmarks/*.pts;
do
   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java dartagnan/Dartagnan -t tso -i $file -unroll 2)
   END=$(python -c 'import time; print time.time()')
   if [ $(echo $EXEC | grep -e "reachable" | wc -l) == 1 ]
      then
         diffPort1=$(echo "$END - $START" | bc)
      else
         diffPort1='T/O'
   fi
   echo "log - no relax"
   echo \\bench{$file} $diffPort1

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java dartagnan/Dartagnan -t tso -i $file -unroll 2 -relax)
   END=$(python -c 'import time; print time.time()')
   if [ $(echo $EXEC | grep -e "reachable" | wc -l) == 1 ]
      then
         diffPort1=$(echo "$END - $START" | bc)
      else
         diffPort1='T/O'
   fi
   echo "log - relax"
   echo \\bench{$file} $diffPort1

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java dartagnan/Dartagnan -t tso -i $file -unroll 2 -idl)
   END=$(python -c 'import time; print time.time()')
   if [ $(echo $EXEC | grep -e "reachable" | wc -l) == 1 ]
      then
         diffPort1=$(echo "$END - $START" | bc)
      else
         diffPort1='T/O'
   fi
   echo "idl - no relax"
   echo \\bench{$file} $diffPort1

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java dartagnan/Dartagnan -t tso -i $file -unroll 2 -idl -relax)
   END=$(python -c 'import time; print time.time()')
   if [ $(echo $EXEC | grep -e "reachable" | wc -l) == 1 ]
      then
         diffPort1=$(echo "$END - $START" | bc)
      else
         diffPort1='T/O'
   fi
   echo "idl - relax"
   echo \\bench{$file} $diffPort1
   echo ""
done

echo "POWER"
for file in benchmarks/*.pts;
do
   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java dartagnan/Dartagnan -t power -i $file -unroll 2)
   END=$(python -c 'import time; print time.time()')
   if [ $(echo $EXEC | grep -e "reachable" | wc -l) == 1 ]
      then
         diffPort1=$(echo "$END - $START" | bc)
      else
         diffPort1='T/O'
   fi
   echo "log - no relax"
   echo \\bench{$file} $diffPort1

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java dartagnan/Dartagnan -t power -i $file -unroll 2 -relax)
   END=$(python -c 'import time; print time.time()')
   if [ $(echo $EXEC | grep -e "reachable" | wc -l) == 1 ]
      then
         diffPort1=$(echo "$END - $START" | bc)
      else
         diffPort1='T/O'
   fi
   echo "log - relax"
   echo \\bench{$file} $diffPort1

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java dartagnan/Dartagnan -t power -i $file -unroll 2 -idl)
   END=$(python -c 'import time; print time.time()')
   if [ $(echo $EXEC | grep -e "reachable" | wc -l) == 1 ]
      then
         diffPort1=$(echo "$END - $START" | bc)
      else
         diffPort1='T/O'
   fi
   echo "idl - no relax"
   echo \\bench{$file} $diffPort1

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java dartagnan/Dartagnan -t power -i $file -unroll 2 -idl -relax)
   END=$(python -c 'import time; print time.time()')
   if [ $(echo $EXEC | grep -e "reachable" | wc -l) == 1 ]
      then
         diffPort1=$(echo "$END - $START" | bc)
      else
         diffPort1='T/O'
   fi
   echo "idl - relax"
   echo \\bench{$file} $diffPort1
   echo ""
done

echo "ARM"
for file in benchmarks/*.pts;
do
   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java dartagnan/Dartagnan -t arm -i $file -unroll 2)
   END=$(python -c 'import time; print time.time()')
   if [ $(echo $EXEC | grep -e "reachable" | wc -l) == 1 ]
      then
         diffPort1=$(echo "$END - $START" | bc)
      else
         diffPort1='T/O'
   fi
   echo "log - no relax"
   echo \\bench{$file} $diffPort1

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java dartagnan/Dartagnan -t arm -i $file -unroll 2 -relax)
   END=$(python -c 'import time; print time.time()')
   if [ $(echo $EXEC | grep -e "reachable" | wc -l) == 1 ]
      then
         diffPort1=$(echo "$END - $START" | bc)
      else
         diffPort1='T/O'
   fi
   echo "log - relax"
   echo \\bench{$file} $diffPort1

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java dartagnan/Dartagnan -t arm -i $file -unroll 2 -idl)
   END=$(python -c 'import time; print time.time()')
   if [ $(echo $EXEC | grep -e "reachable" | wc -l) == 1 ]
      then
         diffPort1=$(echo "$END - $START" | bc)
      else
         diffPort1='T/O'
   fi
   echo "idl - no relax"
   echo \\bench{$file} $diffPort1

   START=$(python -c 'import time; print time.time()')
   EXEC=$(timeout $timeout java dartagnan/Dartagnan -t arm -i $file -unroll 2 -idl -relax)
   END=$(python -c 'import time; print time.time()')
   if [ $(echo $EXEC | grep -e "reachable" | wc -l) == 1 ]
      then
         diffPort1=$(echo "$END - $START" | bc)
      else
         diffPort1='T/O'
   fi
   echo "idl - relax"
   echo \\bench{$file} $diffPort1
   echo ""
done

