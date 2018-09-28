for file in $(find litmus/PPC -name '*.litmus' | sort);
do
   herd7 -model cat/arm.cat $file > ./herd_arm.out
   herd=$(grep -e 'No' herd_arm.out | wc -l)
   rm herd_arm.out
   java -Xmx128m dartagnan/Dartagnan -t arm -i $file -cat cat/arm.cat > ./dart_arm.out
   dart=$(grep -e 'No' dart_arm.out | wc -l)
   rm dart_arm.out
   if [ $dart != $herd ]
   then
      echo $file
      break
   fi
   java -Xmx128m dartagnan/Dartagnan -t arm -i $file -cat cat/arm.cat -idl > ./dart_arm.out
   dart=$(grep -e 'No' dart_arm.out | wc -l)
   rm dart_arm.out
   if [ $dart != $herd ]
   then
      echo $file
      break
   fi
   java -Xmx128m dartagnan/Dartagnan -t arm -i $file -cat cat/arm.cat -relax > ./dart_arm.out
   dart=$(grep -e 'No' dart_arm.out | wc -l)
   rm dart_arm.out
   if [ $dart != $herd ]
   then
      echo $file
      break
   fi
done