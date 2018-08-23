for file in $(find litmus/X86 -name '*.litmus' | sort);
do
   java -Xmx128m dartagnan/Dartagnan -t tso -i $file > ./dart_tso.out
   dart=$(grep -e 'No' dart_tso.out | wc -l)
   herd7 -model cat/tso.cat $file > ./herd_tso.out
   herd=$(grep -e 'No' herd_tso.out | wc -l)
   rm dart_tso.out
   rm herd_tso.out
   if [ $dart != $herd ]
   then
      echo $file
      break
   fi
   java -Xmx128m dartagnan/Dartagnan -t tso -i $file -cat cat/tso.cat > ./dart_tso.out
   dart=$(grep -e 'No' dart_tso.out | wc -l)
   rm dart_tso.out
   if [ $dart != $herd ]
   then
      echo $file
      break
   fi
done