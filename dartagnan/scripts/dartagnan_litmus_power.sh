for file in litmus/reach/power/*.litmus;
do
   java dartagnan/Dartagnan -t power -i $file > ./dart_power.out
   dart=$(grep -e 'not' dart_power.out | wc -l)
   herd7 -model cat/power.cat $file > ./herd_power.out
   herd=$(grep -e 'Never' herd_power.out | wc -l)
   rm dart_power.out
   rm herd_power.out
   if [ $dart != $herd ]
   then
      echo $file
      break
   fi
done


