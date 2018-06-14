for file in litmus/X86/*.litmus;
do
   java dartagnan/Dartagnan -t tso -i $file > ./dart_tso.out
   dart=$(grep -e 'not' dart_tso.out | wc -l)
   herd7 -model cat/tso.cat $file > ./herd_tso.out
   herd=$(grep -e 'Never' herd_tso.out | wc -l)
   rm dart_tso.out
   rm herd_tso.out
   if [ $dart != $herd ]
   then
      echo $file
      break
   fi
done


