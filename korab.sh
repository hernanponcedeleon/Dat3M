#!/bin/bash

for file in $(find ~/git/korab/Dat3M/thesis/out/litmus/C/ -name '*.c')
do
    echo $file
    timeout 15 java -jar svcomp/target/svcomp-2.0.7-jar-with-dependencies.jar -cat cat/linux-kernel.cat -i $file -p ~/git/sv-benchmarks/c/properties/unreach-call.prp
done

for file in $(find ~/git/korab/Dat3M/thesis/out/litmus/AARCH64/ -name '*.c')
do
    echo $file
    timeout 15 java -jar svcomp/target/svcomp-2.0.7-jar-with-dependencies.jar -cat cat/aarch64.cat -i $file -p ~/git/sv-benchmarks/c/properties/unreach-call.prp
done

for file in $(find ~/git/korab/Dat3M/thesis/out/litmus/X86/ -name '*.c')
do
    echo $file
    timeout 15 java -jar svcomp/target/svcomp-2.0.7-jar-with-dependencies.jar -cat cat/tso.cat -i $file -p ~/git/sv-benchmarks/c/properties/unreach-call.prp
done

for file in $(find ~/git/korab/Dat3M/thesis/out/litmus/PPC/ -name '*.c')
do
    echo $file
    timeout 15 java -jar svcomp/target/svcomp-2.0.7-jar-with-dependencies.jar -cat cat/power.cat -i $file -p ~/git/sv-benchmarks/c/properties/unreach-call.prp
done
