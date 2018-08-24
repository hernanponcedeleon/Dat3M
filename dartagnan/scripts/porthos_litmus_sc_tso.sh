for file in litmus/X86/*.litmus;
do
   rwm=$(grep -e 'XCHG\|xchg' $file | wc -l)
   if [ $rwm != 0 ]
   then
      continue
   fi
   java -Xmx128m porthos/Porthos -s sc -t tso -i $file > ./port_sc_tso.out
   port=$(grep -e 'not' port_sc_tso.out | wc -l)
   herd7 -model cat/sc.cat $file > ./herd_sc.out
   herd1=$(grep -e 'States' herd_sc.out)
   herd7 -model cat/tso.cat $file > ./herd_tso.out
   herd2=$(grep -e 'States' herd_tso.out)
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
   rm port_sc_tso.out
   rm herd_sc.out
   rm herd_tso.out
   rm herd.out
   if [ $port != $herd ]
   then
      echo $file
      break
   fi
done

