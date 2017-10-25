for file in ../benchmarks/all_rx/*.pts;
do
   echo $file
   START1=$(python -c 'import time; print time.time()')
   timeout 600 java porthos/Porthos -s sc -t tso -i $file -state
   END1=$(python -c 'import time; print time.time()')
   DIFF1=$(echo "$END1 - $START1" | bc)
   echo $DIFF1
done
