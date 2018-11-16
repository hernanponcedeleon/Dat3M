#Build blacklist of tests, which should not be executed
blacklist=$(< litmus/herd-long-exec-time.txt)
blacklist+=$(< litmus/herd-not-supported.txt)

skip_fixpoint=$(< litmus/dart-fixpoint-long-exec-time.txt)

# Return 0 if file is in the blacklist, otherwise 1
function is_blacklisted() {
    for item in ${blacklist[@]}
    do
        if [[ $1 == $item ]]; then
            return 0
        fi
    done
    return 1
}

# Return 0 if file is in the skip_fixpoint list, otherwise 1
function skip_fixpoint() {
    for item in ${skip_fixpoint[@]}
    do
        if [[ $1 == $item ]]; then
            return 0
        fi
    done
    return 1
}

for file in $(find litmus/C/auto -name '*.litmus' | sort);
do
   if is_blacklisted $file; then
        continue
   fi

   herd7 -I cat -model cat/linux-kernel.cat -bell cat/linux-kernel.bell -macros cat/linux-kernel.def $file > ./herd_linux.out
   herd=$(grep -e 'No' herd_linux.out | wc -l)
   rm herd_linux.out

   if ! skip_fixpoint $file; then
      java dartagnan/Dartagnan -t sc -i $file -cat cat/linux-kernel.cat > ./dart_linux.out
      dart=$(grep -e 'No' dart_linux.out | wc -l)
      rm dart_linux.out
      if [ $dart != $herd ]; then
         echo $file
         break
      fi
   fi
   java dartagnan/Dartagnan -t sc -i $file -cat cat/linux-kernel.cat -idl > ./dart_linux.out
   dart=$(grep -e 'No' dart_linux.out | wc -l)
   rm dart_linux.out
   if [ $dart != $herd ]; then
      echo $file
      break
   fi
   java dartagnan/Dartagnan -t sc -i $file -cat cat/linux-kernel.cat -relax > ./dart_linux.out
   dart=$(grep -e 'No' dart_linux.out | wc -l)
   rm dart_linux.out
   if [ $dart != $herd ]; then
      echo $file
      break
   fi
done
