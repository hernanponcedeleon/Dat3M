#!/bin/bash

echo "Running fair model"
java -DlogLevel=off -jar $DAT3M_HOME/dartagnan/target/dartagnan.jar $DAT3M_HOME/cat/vulkan.cat --target=vulkan --property=termination --bound=4 --modeling.progress=fair $DAT3M_HOME/litmus/VULKAN/CADP/ > table2-r1.txt
echo

echo "Running obe model"
java -DlogLevel=off -jar $DAT3M_HOME/dartagnan/target/dartagnan.jar $DAT3M_HOME/cat/vulkan.cat --target=vulkan --property=termination --bound=4 --modeling.progress=obe $DAT3M_HOME/litmus/VULKAN/CADP/ > table2-r2.txt
echo

echo "Running hsa model"
java -DlogLevel=off -jar $DAT3M_HOME/dartagnan/target/dartagnan.jar $DAT3M_HOME/cat/vulkan.cat --target=vulkan --property=termination --bound=4 --modeling.progress=hsa $DAT3M_HOME/litmus/VULKAN/CADP/ > table2-r3.txt
echo

echo "Running hsa_obe model"
java -DlogLevel=off -jar $DAT3M_HOME/dartagnan/target/dartagnan.jar $DAT3M_HOME/cat/vulkan.cat --target=vulkan --property=termination --bound=4 --modeling.progress=hsa_obe $DAT3M_HOME/litmus/VULKAN/CADP/ > table2-r4.txt
echo

echo "Running unfair model"
java -DlogLevel=off -jar $DAT3M_HOME/dartagnan/target/dartagnan.jar $DAT3M_HOME/cat/vulkan.cat --target=vulkan --property=termination --bound=4 --modeling.progress=unfair $DAT3M_HOME/litmus/VULKAN/CADP/ > table2-r5.txt
echo
