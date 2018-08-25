for file in litmus/PPC/*.litmus;
do
   rwm=$(grep -e 'XCHG\|xchg' $file | wc -l)
   if [ $rwm != 0 ]
   then
      continue
   fi
   java -Xmx128m porthos/Porthos -s tso -t arm -i $file > ./port_tso_arm.out
   port=$(grep -e 'not' port_tso_arm.out | wc -l)
   herd7 -model cat/tso.cat $file > ./herd_tso.out
   herd1=$(grep -e 'States' herd_tso.out)
   herd7 -model cat/arm.cat $file > ./herd_arm.out
   herd2=$(grep -e 'States' herd_arm.out)
   herd1=${herd1#*States} 
   herd2=${herd2#*States}
   expr $herd1 - $herd2 > ./herd.out
   herd=$(grep -e '0' herd.out | wc -l)
   if [ $herd == 0 ]
   then
      herd=1
   else
      herd=0
   fi
   rm port_tso_arm.out
   rm herd_tso.out
   rm herd_arm.out
   rm herd.out
   if [ $port != $herd ]
   then
      echo $file
      break
   fi
done

