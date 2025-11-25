# Recurrence Sets for Proving Fair Non-termination under Axiomatic Memory Consistency Models (Artifact)

## Content

This artifact contains an extension to the [dartagnan](https://github.com/hernanponcedeleon/Dat3M) tool for checking non-termination, the [GenMC](https://github.com/MPI-SWS/genmc) tool, and several benchmarks, including those from the [libvsync](https://github.com/open-s4c/libvsync) project.
The path to the corresponding licenses of each project can be find below.
```
/home/Dat3M/
/home/libvsync/
/root/genmc/
```

## List of claims

This artifact allows reproducing Tables 1-3 from the Evaluation section.

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

As sanity-testing, you can run Dartagnan
```
java -DlogLevel=off -jar $DAT3M_HOME/dartagnan/target/dartagnan.jar $DAT3M_HOME/cat/imm.cat $DAT3M_HOME/benchmarks/locks/ttas.c --bound=3 --solver=$SMTSOLVER
```
and expect to observe
```
Test: /home/Dat3M/benchmarks/locks/ttas.c
Result: PASS
Time: 1.418 secs
```
and GenMC
```
genmc -imm -check-liveness -disable-estimation $DAT3M_HOME/benchmarks/locks/ttas.c
```
and expect to observe
```
...

*** Verification complete.
No errors were detected.
Number of complete executions explored: 36
Number of blocked executions seen: 60
Total wall-clock time: 0.05s
```

By default in this artifact, Dartagnan uses the `yices2` SMT solver. If you experience problems with the SMT solver, you can change to the `z3` solver via `export SMTSOLVER=z3`. Notice that `z3` is much slower than `yices2` in the benchmarks of this artifact.

## Evaluation instructions

To generate the data to reproduce Table 1 (left), run
```
bash $DAT3M_HOME/artifact-popl/scripts/generate-table1l.sh
```
The script runs Dartagnan on all synthetic benchmarks using imm as the memory model with a 10s timeout for each verification run.

**Expected running time:** 1m.

Upon completion, the results can be found in `table1l.csv`. Running
```
bash $DAT3M_HOME/artifact-popl/scripts/display-table1l.sh
```
will display the results in the console.

**Expected output (modulo time differences):**
```
Benchmark     | Result   | Time      
------------------------------------------
asymmetric    | ❌       | 0.7s      
complex       | ❌       | 1.0s      
oscillating   | ❌       | 0.5s      
weak          | ❌       | 0.8s      
xchg          | ❌       | 0.6s      
zero_effect   | ❌       | 6.9s  
```

**Supported claims:**
Dartagnan can prove non-termination for all the proposed synthetic benchmarks.

#

To generate the data to reproduce Table 1 (right), run
```
bash $DAT3M_HOME/artifact-popl/scripts/generate-table1r.sh
```
The script runs Dartagnan on all forward progress litmus tests, for each of the forward progress models (i.e., schedulers), and using vulkan as the memory model. 

**Expected running time:** 10m.

Upon completion, each of the `table1r-rX` files contains one row from the table. Running
```
bash $DAT3M_HOME/artifact-popl/scripts/display-table1r.sh
```
will display the results in the console.

**Expected output:**
```
  PASS |   FAIL |  UNKNOWN |   ERROR
--------------------------------------
   104 |    156 |      217 |       6
     8 |    453 |       16 |       6
    42 |    388 |       47 |       6
    46 |    367 |       64 |       6
     0 |    477 |        0 |       6
```

**Supported claims:**
Dartagnan can prove non-termination in the presence of side-effects and different forward progress models (i.e., schedulers).

#

To generate the data to reproduce Table 2, run
```
bash $DAT3M_HOME/artifact-popl/scripts/generate-table2.sh
```
The script runs both GenMC (once using manual annotations and once using automatic spin loop detection) and Dartagnan (using automatic spin loop detection) on all spinlock benchmarks of the libvsync library. Both tools use imm as the memory model. For Dartagnan, each benchmark uses a specific unrolling bound (shown in the table).

**Expected running time:** 4h.

Upon completion, the results can be found in `table2.csv`. Running
```
bash $DAT3M_HOME/artifact-popl/scripts/display-table2.sh
```
will display the results in the console.

**Expected output with the yices2 SMT solver (modulo time differences):**
```
Benchmark      | Genmc (M)    | Genmc (A)    | Dartagnan (A)
--------------------------------------------------------------------------
arraylock      | ✅ (0.1s)    | ✅ (0.1s)    | ✅ (1.7s / B=4)
caslock        | ✅ (0.2s)    | 🕒           | ✅ (2.0s / B=4)
clhlock        | ✅ (0.1s)    | 🕒           | ✅ (1.5s / B=4)
cnalock        | ❌ (0.2s)    | ❌ (0.2s)    | ❌ (11.9s / B=2)
hclhlock       | ❌ (0.5s)    | ❌ (0.5s)    | ❌ (1m 58s / B=2)
hemlock        | ✅ (0.2s)    | 🕒           | ✅ (2.3s / B=4)
hmcslock       | ❌ (0.3s)    | ❌ (0.3s)    | ❌ (44.3s / B=8)
mcslock        | ❌ (0.1s)    | 🕒           | ❌ (1.2s / B=2)
rec_mcslock    | ❌ (0.1s)    | 🕒           | ❌ (2.3s / B=4)
rec_seqlock    | ✅ (1.3s)    | ✅ (0.6s)    | ✅ (6.7s / B=4)
rec_spinlock   | ✅ (0.4s)    | 🕒           | ✅ (2.9s / B=4)
rec_ticketlock | ✅ (0.1s)    | 🕒           | ✅ (2.7s / B=4)
rwlock         | ✅ (0.5s)    | 🕒           | ✅ (20.8s / B=4)
semaphore      | ✅ (0.1s)    | ✅ (0.1s)    | ✅ (21.6s / B=4)
seqcount       | ✅ (0.1s)    | ✅ (0.1s)    | ✅ (0.6s / B=4)
seqlock        | ✅ (0.3s)    | ✅ (0.2s)    | ✅ (1.9s / B=4)
ticketlock     | ✅ (0.1s)    | 🕒           | ✅ (1.3s / B=4)
ttaslock       | ✅ (0.1s)    | 🕒           | ✅ (2.1s / B=4)
twalock        | ❌ (0.3s)    | 🕒           | ❌ (1.7s / B=2)
```

**Expected output with the z3 SMT solver (modulo time differences):**
```
Benchmark      | GenMC (M)    | GenMC (A)    | Dartagnan (A)       
--------------------------------------------------------------------------
arraylock      | ✅ (0.1s)    | ✅ (0.1s)    | ✅ (3.8s / B=4)      
caslock        | ✅ (0.2s)    | N/A (🕒)     | ✅ (2.2s / B=4)      
clhlock        | ✅ (0.1s)    | N/A (🕒)     | ✅ (2.0s / B=4)      
cnalock        | ❌ (0.2s)    | ❌ (0.2s)    | ❌ (30.1s / B=2)     
hclhlock       | ❌ (0.5s)    | ❌ (0.5s)    | ❌ (4m 25s / B=2)    
hemlock        | ✅ (0.2s)    | N/A (🕒)     | ✅ (3.9s / B=4)      
hmcslock       | ❌ (0.3s)    | ❌ (0.3s)    | ❌ (36.4s / B=8)     
mcslock        | ❌ (0.1s)    | N/A (🕒)     | ❌ (1.8s / B=2)      
rec_mcslock    | ❌ (0.1s)    | N/A (🕒)     | ❌ (2.2s / B=4)      
rec_seqlock    | ✅ (1.3s)    | ✅ (0.6s)    | ✅ (13.5s / B=4)     
rec_spinlock   | ✅ (0.4s)    | N/A (🕒)     | ✅ (4.0s / B=4)      
rec_ticketlock | ✅ (0.1s)    | N/A (🕒)     | ✅ (4.2s / B=4)      
rwlock         | ✅ (0.5s)    | N/A (🕒)     | ✅ (1m 3s / B=4)     
semaphore      | ✅ (0.1s)    | ✅ (0.1s)    | ✅ (1m 9s / B=4)     
seqcount       | ✅ (0.1s)    | ✅ (0.1s)    | ✅ (0.7s / B=4)      
seqlock        | ✅ (0.3s)    | ✅ (0.2s)    | N/A (🕒 / B=4)       
ticketlock     | ✅ (0.1s)    | N/A (🕒)     | ✅ (1.7s / B=4)      
ttaslock       | ✅ (0.1s)    | N/A (🕒)     | ✅ (2.9s / B=4)      
twalock        | ❌ (0.3s)    | N/A (🕒)     | ❌ (3.4s / B=2)        
```

**Supported claims:**
GenMC fails to detect many non-termination examples when the program is not manually annotated. GenMC (using manual annotations) and Dartagnan (using automatic spin loop detection) can find all non-termination instances. When both tools find a violation, GenMC is usually much faster.

#

To generate the data to reproduce Table 3, run
```
bash $DAT3M_HOME/artifact-popl/scripts/generate-table3.sh
```
The script runs Dartagnan on all prefixsum implementations, for each of the forward progress models (i.e., schedulers), and using vulkan as the memory model. 

**Expected running time:** 2.5h.

Upon completion, the results can be found in `table3.csv`. Running
```
bash $DAT3M_HOME/artifact-popl/scripts/display-table3.sh
```
will display the results in the console.

**Expected output with the yices2 SMT solver (modulo time differences):**
```
Prefixsum        | Scheduler  | Terminates | Time
-----------------------------------------------------------
Ours (ids)       | fair       | ✅         | 14.3s (B=3)
Ours (ids)       | obe        | ❌         | 15.7s (B=3)
Ours (ids)       | hsa        | ✅         | 15.1s (B=3)
Ours (ids)       | hsa_obe    | ✅         | 15.0s (B=3)
Ours (ids)       | lobe       | ✅         | 15.2s (B=3)
Ours (ids)       | unfair     | ❌         | 15.1s (B=3)
-----------------------------------------------------------
Ours (ticket)    | fair       | ✅         | 12.6s (B=3)
Ours (ticket)    | obe        | ✅         | 13.0s (B=3)
Ours (ticket)    | hsa        | ❌         | 13.6s (B=3)
Ours (ticket)    | hsa_obe    | ✅         | 13.0s (B=3)
Ours (ticket)    | lobe       | ✅         | 13.5s (B=3)
Ours (ticket)    | unfair     | ❌         | 13.3s (B=3)
-----------------------------------------------------------
UCSC (ticket)    | fair       | ✅         | 4.0s (B=2)
UCSC (ticket)    | obe        | ✅         | 4.5s (B=2)
UCSC (ticket)    | hsa        | ❌         | 4.0s (B=2)
UCSC (ticket)    | hsa_obe    | ✅         | 4.1s (B=2)
UCSC (ticket)    | lobe       | ✅         | 4.2s (B=2)
UCSC (ticket)    | unfair     | ❌         | 4.0s (B=2)
-----------------------------------------------------------
Vello (ticket)   | fair       | ✅         | 7m 27s (B=8)
Vello (ticket)   | obe        | ✅         | 8m 5s (B=8)
Vello (ticket)   | hsa        | ✅         | 7m 48s (B=8)
Vello (ticket)   | hsa_obe    | ✅         | 8m 21s (B=8)
Vello (ticket)   | lobe       | ✅         | 7m 13s (B=8)
Vello (ticket)   | unfair     | ✅         | 8m 17s (B=8)
-----------------------------------------------------------
```

**Expected output with the z3 SMT solver (modulo time differences):**
```
Prefixsum        | Scheduler  | Terminates | Time        
-----------------------------------------------------------
Ours (ids)       | fair       | ✅         | 22.2s (B=3) 
Ours (ids)       | obe        | ❌         | 1m 18s (B=3)
Ours (ids)       | hsa        | ✅         | 22.8s (B=3) 
Ours (ids)       | hsa_obe    | ✅         | 22.9s (B=3) 
Ours (ids)       | lobe       | ✅         | 24.4s (B=3) 
Ours (ids)       | unfair     | ❌         | 1m 26s (B=3)
-----------------------------------------------------------
Ours (ticket)    | fair       | ✅         | 19.4s (B=3) 
Ours (ticket)    | obe        | ✅         | 22.9s (B=3) 
Ours (ticket)    | hsa        | ❌         | 55.4s (B=3) 
Ours (ticket)    | hsa_obe    | ✅         | 21.3s (B=3) 
Ours (ticket)    | lobe       | ✅         | 23.2s (B=3) 
Ours (ticket)    | unfair     | ❌         | 51.1s (B=3) 
-----------------------------------------------------------
UCSC (ticket)    | fair       | ✅         | 6.4s (B=2)  
UCSC (ticket)    | obe        | ✅         | 7.8s (B=2)  
UCSC (ticket)    | hsa        | ❌         | 10.2s (B=2) 
UCSC (ticket)    | hsa_obe    | ✅         | 7.4s (B=2)  
UCSC (ticket)    | lobe       | ✅         | 7.5s (B=2)  
UCSC (ticket)    | unfair     | ❌         | 18.8s (B=2) 
-----------------------------------------------------------
Vello (ticket)   | fair       | ✅         | 13m 50s (B=8)
Vello (ticket)   | obe        | ✅         | 21m 51s (B=8)
Vello (ticket)   | hsa        | ✅         | 18m 39s (B=8)
Vello (ticket)   | hsa_obe    | ✅         | 18m 37s (B=8)
Vello (ticket)   | lobe       | ✅         | 15m 20s (B=8)
Vello (ticket)   | unfair     | ✅         | 24m 49s (B=8)
-----------------------------------------------------------
```

**Supported claims:**
Dartagnan can verify different implementations of the Prefixsum algorithm. For the variant using the workgroup id to decide its predecessor, it shows that OBE and unfair schedulers lead to non-termination. For the variants using a ticket (and not implementing scalar fallback), HSA and unfair schedulers lead to non-termination. For Vello (which implements scalar fallback) the program terminates independently of the scheduler.

## Artifact organization

**Benchmarks:**
- Synthetic benchmarks are located in `$DAT3M_HOME/artifact-popl/benchmarks/synthetic/`.
- Forward progress litmus tests are located in `$DAT3M_HOME/litmus/VULKAN/CADP/`.
- Libvsync benchmarks are located in `$LIBVSYNC_HOME/test/spinlock/` with the core logic of the algorithms located in `$LIBVSYNC_HOME/include/vsync/spinlock`.
- Prefixsum benchmarks are located in `$DAT3M_HOME/artifact-popl/benchmarks/prefixsum`.

**Implementation:**
The encoding of the non-termination witness is implemented in `$DAT3M_HOME/dartagnan/src/main/java/com/dat3m/dartagnan/encoding/NonTerminationEncoder.java`.

## Running your own examples

For testing your own C examples, run
```
CFLAGS="<if-needed>" java -jar $DAT3M_HOME/dartagnan/target/dartagnan.jar --property=termination $DAT3M_HOME/cat/imm.cat --bound=<int> <your-benchmark.c>
```

Dartagnan reads GPU computing kernels in SPIR-V (OpenCL, slang, hlsl, gls can all be compiled to SPIR-V). The SPIR-V code should be annotated with a configuration of the form `; @Config: X, Y, Z` specifying the number of threads per subgroup, the number of subgroups per workgroup, and the number of workgroups in the device. The initial value of buffers needs to be specified with the annotation `; @Input: ...`. See the Prefixsum benchmarks for more details.

For testing your own SPIR-V examples, run
```
java -jar $DAT3M_HOME/dartagnan/target/dartagnan.jar --property=termination $DAT3M_HOME/cat/vulkan.cat --target=vulkan --bound=X <your-benchmark.spvasm>
```
If you want to test different schedulers, you can add option `--modeling.progress=[X=Y]` where `X in {SG, WG, QF}` and `Y in {fair, obe, hsa, hsa_obe, lobe, unfair}`.