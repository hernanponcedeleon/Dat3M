#!/bin/bash

echo "Running fair model"
java -DlogLevel=off -jar $DAT3M_HOME/dartagnan/target/dartagnan.jar $DAT3M_HOME/cat/vulkan.cat --target=vulkan --property=termination --bound=4 --solver=${SMTSOLVER} --modeling.progress=fair $DAT3M_HOME/litmus/VULKAN/CADP/ > table1r-r1.txt
echo

echo "Running obe model"
java -DlogLevel=off -jar $DAT3M_HOME/dartagnan/target/dartagnan.jar $DAT3M_HOME/cat/vulkan.cat --target=vulkan --property=termination --bound=4 --solver=${SMTSOLVER} --modeling.progress=obe $DAT3M_HOME/litmus/VULKAN/CADP/ > table1r-r2.txt
echo

echo "Running hsa model"
java -DlogLevel=off -jar $DAT3M_HOME/dartagnan/target/dartagnan.jar $DAT3M_HOME/cat/vulkan.cat --target=vulkan --property=termination --bound=4 --solver=${SMTSOLVER} --modeling.progress=hsa $DAT3M_HOME/litmus/VULKAN/CADP/ > table1r-r3.txt
echo

echo "Running hsa_obe model"
java -DlogLevel=off -jar $DAT3M_HOME/dartagnan/target/dartagnan.jar $DAT3M_HOME/cat/vulkan.cat --target=vulkan --property=termination --bound=4 --solver=${SMTSOLVER} --modeling.progress=hsa_obe $DAT3M_HOME/litmus/VULKAN/CADP/ > table1r-r4.txt
echo

echo "Running unfair model"
java -DlogLevel=off -jar $DAT3M_HOME/dartagnan/target/dartagnan.jar $DAT3M_HOME/cat/vulkan.cat --target=vulkan --property=termination --bound=4 --solver=${SMTSOLVER} --modeling.progress=unfair $DAT3M_HOME/litmus/VULKAN/CADP/ > table1r-r5.txt
echo
