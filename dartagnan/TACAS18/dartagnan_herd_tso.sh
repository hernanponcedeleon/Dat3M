for file in ../benchmarks/all_rx/*.pts;
do
   echo $file
   START1=$(python -c 'import time; print time.time()')
   timeout 600 java dartagnan/Dartagnan -t tso -i $file
   END1=$(python -c 'import time; print time.time()')
   DIFF1=$(echo "$END1 - $START1" | bc)
   echo $DIFF1
done

#for file in ../benchmarks/all_rx/*.litmus;
#do
#   echo $file
#   START2=$(python -c 'import time; print time.time()')
#   timeout 60 herd7 -model ~/Documents/Projects/Memory-Models/herd/tso.cat $file
#   END2=$(python -c 'import time; print time.time()')
#   DIFF2=$(echo "$END2 - $START2" | bc)
#   echo $DIFF2
#done


