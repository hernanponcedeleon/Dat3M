# Recurrence Sets for Proving Fair Non-termination under Axiomatic Memory Consistency Models (Artifact)

## List of claims

This artifact allows reproducing Tables 1-4 from the Evaluation section.

## Download, installation, and sanity-testing

The artifact (available on Zenodo) consists of a docker image with the tools and benchmarks
that are required to validate the claims made in the paper.

To load the docker image, run
```
docker load < dat3m-popl26-artifact.tar
```
and start the docker container
```
docker run -it --rm dat3m-popl26-artifact
```

As sanity-testing, you can run dartagnan on a small example
```
java -DlogLevel=off -jar $DAT3M_HOME/dartagnan/target/dartagnan.jar $DAT3M_HOME/cat/imm.cat $DAT3M_HOME/benchmarks/locks/ttas.c --bound=3
```
and expect to observe
```
Test: $DAT3M_HOME/benchmarks/locks/ttas.c
Result: PASS
Time: X secs
```

## Evaluation instructions

To generate the data to reproduce Table 1, run
```
bash $DAT3M_HOME/artifact-popl/scripts/generate-table1.sh
```
The script runs dartagnan on all synthetic benchmarks using imm as the memory model with a 60s timeout for each verification run.

**Expected running time:** 1m.

Upon completion, the results can be found in `table1.csv`. Running
```
bash $DAT3M_HOME/artifact-popl/scripts/display-table1.sh
```
will display the results in the console.

#

To generate the data to reproduce Table 2, run
```
bash $DAT3M_HOME/artifact-popl/scripts/generate-table2.sh
```
The script runs dartagnan on all forward progress litmus tests, for each of the forward progress models (i.e., schedulers), and using vulkan as the memory model. 

**Expected running time:** 10m.

Upon completion, each of the `table2-rX` files contains one row from the table. Running
```
bash $DAT3M_HOME/artifact-popl/scripts/display-table2.sh
```
will display the results in the console.

#

To generate the data to reproduce Table 3, run
```
bash $DAT3M_HOME/artifact-popl/scripts/generate-table3.sh
```
The script runs both genmc (once using manual annotations and once using automatic spin loop detection) and dartagnan (using automatic spin loop detection) on all spinlock benchmarks of the libvsync library. Both tools use imm as the memory model. For dartagnan, each benchmark uses a specific unrolling bound (shown in the table).

**Expected running time:** 4h.

Upon completion, the results can be found in `table3.csv`. Running
```
bash $DAT3M_HOME/artifact-popl/scripts/display-table3.sh
```
will display the results in the console.

#

To generate the data to reproduce Table 4, run
```
bash $DAT3M_HOME/artifact-popl/scripts/generate-table4.sh
```
The script runs dartagnan on all prefixsum implementations, for each of the forward progress models (i.e., schedulers), and using vulkan as the memory model. 

**Expected running time:** 1h.

Upon completion, the results can be found in `table4.csv`. Running
```
bash $DAT3M_HOME/artifact-popl/scripts/display-table4.sh
```
will display the results in the console.