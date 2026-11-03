# Branch `agentic/trust`: stateless model checking (TruSt) in Dartagnan

This branch adds a new task to Dartagnan: **exploration**. It enumerates the consistent executions of a program with the
TruSt algorithm (Kokologiannakis et al., *Truly Stateless, Optimal Dynamic Partial Order Reduction*, POPL'22,
[doi:10.1145/3498711](https://dl.acm.org/doi/10.1145/3498711)). Each execution graph is checked directly against the CAT
model. No SMT solver is involved, and loops are not unrolled.

```
dartagnan cat/aarch64.cat --target=arm8 program.c --mode=exploration \
    [--exploration.order=po|dependencies] [--exploration.threads=N] \
    [--exploration.spinLast=true|false] [--exploration.awaits=true|false] \
    [--exploration.maxEventsPerThread=N] [--exploration.threadCreationBound=N] \
    [--exploration.printExecutions=true]
```

## Options

| Option | Default | Meaning |
|---|---|---|
| `exploration.order` | `po` | Exploration order: `po` (the paper's algorithm) or `dependencies` (see Assumptions). |
| `exploration.threads` | 1 | Number of worker threads exploring graphs in parallel. |
| `exploration.spinLast` | true | Schedules threads with store-free loops after the other threads. |
| `exploration.awaits` | false | Awamoche-style in-place revisits of await reads. Ignored with `maxEventsPerThread`. |
| `exploration.maxEventsPerThread` | 0 (unbounded) | Cuts off executions longer than this bound; the result becomes `UNKNOWN`. |
| `exploration.threadCreationBound` | 8 | Unrolling bound for loops that create threads, the only loops that are unrolled. |
| `exploration.printExecutions` | false | Prints every complete execution, which disables early termination. |

Result semantics:
- `FAIL`: a violation was found (assertion, CAT flag, termination), or an `exists` specification is unreachable and the
  exploration was exhaustive.
- `PASS`: the exploration was exhaustive and found no violation, or an `exists` specification was reached.
- `UNKNOWN`: otherwise, i.e. some execution exceeded a bound.

## Architecture

### Task and plumbing

- `ExplorationTask`, `ExplorationTaskSolver` and `ExplorationResult` live in `task/exploration/`, next to
  `task/verification/` and `task/enumeration/`.
- `--mode=exploration` is a new value of `configuration.Mode`. The branch also adds output and exit codes in
  `OutputGenerator` and option registration (`OptionInfo`, native-image `reflect-config.json`).
- `ExplorationTaskSolver` reads the options, runs the exploration pipeline and builds an `ExplorationSettings` record,
  which it hands to `TruStExplorer`.

### Core (`task/exploration/`, about 4,800 lines)

| Class | Role |
|---|---|
| `TruStExplorer` | Algorithm 1 of the paper: read/write visits, coherence placements, backward revisits, the maximal-extension check, full graphs, pruning rules, Awamoche in-place revisits and statistics. Each recursive call is a work item handed to the `WorkScheduler`. |
| `WorkScheduler` | Runs work items either sequentially on an explicit stack (depth-first) or in parallel on per-worker deques with work stealing. |
| `ThreadAnalysis` | Static facts about the thread code: which threads have store-free loops, the header of each spin loop, and from which program points a thread may still write. |
| `ExplorationSettings` | The explorer's options (order, bound, awaits, spinLast, printExecutions, threads). |
| `ExplorationGraph` | Execution graph: nodes, `rf`, `co` per location, per-thread nodes and porf-prefix computation. Holes are allowed in dependencies mode. |
| `ThreadInterpreter`, `ThreadState` | Concrete interpreter of the processed (non-unrolled) program. It tracks data, address and control dependencies at run time, replays a thread against an existing graph, and tracks the iteration start of each spin loop. |
| `ConcreteEvaluator`, `Values` | Concrete expression evaluation. Values are bit-vectors stored modulo 2^w, plus a lazy `UNDEFINED` for nondeterministic values. |
| `MemoryLayout` | Deterministic addresses for static objects and per-instance dynamic allocations, plus init nodes. Thread-safe, with lock-free lookups. |
| `ConsistencyChecker`, `BitMatrix` | Evaluates arbitrary `.cat` models on a graph with bit matrices, using fixpoints for recursive definitions. Supports the axioms (acyclic, irreflexive, empty, flagged), a per-location pre-check, and the base relations used by the CPU models. |
| `ExplorationOrder` | The exploration order E (`po` or `dependencies`) and the per-thread tracker that computes E-predecessors of new events. |
| `Node` | Immutable event instance, shared between graphs, with a per-node tag cache. |

### Parallel exploration

TruSt is stateless: the exploration of a graph depends only on the graph itself, because the maximality checks of
backward revisits do not consult other graphs. Work items can therefore run in any order and in parallel, and the set
of visited graphs does not depend on the schedule.

- **Workers:** each worker runs its own deque depth-first and steals the oldest items (the largest subtrees) from other
  workers.
- **Termination:** the exploration ends when no item is queued or running, or when a violation stops it.
- **Delayed publication:** items a worker pushes while visiting a graph are published only after the visit finishes,
  because the visit may still modify the graph temporarily (`isPlausibleCo`).
- **Shared state:**
  - per-worker statistics, summed at the end;
  - concurrent maps in `MemoryLayout` and `ConsistencyChecker`;
  - a single volatile word for each node's tag cache;
  - synchronized violation and outcome reporting.

### Changes outside the new package

- `ProcessingManager.forExploration`: the pipeline without loop unrolling (no `NaiveLoopBoundAnnotation`, no
  `NonterminationDetection`). It also skips the post-unrolling simplifications (assignment inlining, constant
  propagation, dead assignment elimination), which assume loop-free code.
- `LoopUnrolling.forThreadCreatingLoops`: unrolls only loops that contain thread creation.
- `DynamicSpinLoopDetection.withZeroInitializedTracking`: in exploration mode, the registers tracked by the
  instrumentation are zero-initialised instead of nondet. BMC is unchanged.
- `Intrinsics.matches`: recognises the Darwin symbol prefix `\01` (e.g. `\01_pthread_join`).
- `OptionNames`: the `exploration.*` options.
- `README.md`: new section "Stateless model checking (exploration)".

## What is implemented

### TruSt core
- Read/write visits, coherence placements, backward revisits and maximal extensions (Algorithm 1).
- Two exploration orders: `po`, and `dependencies` for weak models (Power, ARMv8, RISC-V, LKMM).
- CAT flags, assertions, `exists` specifications and termination (liveness) violations.

### Loops without unrolling
- **Spin loops:**
  - `DynamicSpinLoopDetection` instruments every loop.
  - An iteration without side effects (a taken `SPINLOOP` jump) blocks the thread, and the execution is counted as
    *blocked*.
  - Statically side-effect-free loops lose their back jump; a `LoopBound` annotation marks their start instead.
- **Per-loop iteration start:** each spin loop records where its current iteration started, so a nested inner loop
  does not overwrite the outer loop's iteration. This used to cause a false termination violation on harris-3.
- **Liveness:** a full graph is a liveness violation if all reads in a spinning thread's last iteration read
  co-maximal writes.
- **Programs with infinite executions:** these run forever unless `exploration.maxEventsPerThread` is set.

### Performance
1. **Faster consistency checks:**
   - word-level construction of `po`, `int`, `ext`, `loc` and `co`;
   - masked compositions with sets;
   - `acyclic(r+)` checked as `acyclic(r)`.
2. **Per-location pre-check:** the branch detects, from the CAT model, the axioms that only relate same-location
   events (coherence, atomicity). Before building a graph for an `rf` or `co` choice, these axioms are checked on that
   location only. This avoids about 90% of inconsistent graphs.
3. **Deferred consistency checks:**
   - The models are prefix-closed, so the check of a graph can be deferred to its extension as long as the exploration
     does not branch.
   - Steps that add a fence, a thread event, or a read with a single candidate write are not checked.
   - If a graph is inconsistent, its unchecked ancestors are checked for flagged violations.
4. **Parallel exploration** (`exploration.threads`), described above.
5. **Fewer blocked executions:**
   - **Permanently spinning threads** (GenMC's "moot" executions): a spinning thread whose last node was not added
     maximally cannot be changed by any revisit, so the graph is pruned.
   - **`pthread_join`:** the join reads only the latest write to the joined thread's state word. Reading an older value
     could only block the join. This is skipped for programs that use `pthread_detach`.
   - **Spin-last scheduling** (`exploration.spinLast`): threads with store-free loops are scheduled after the other
     threads. The priority is fixed, which keeps TruSt complete; an earlier dynamic, graph-dependent priority lost
     executions. On seqlock it cut visited graphs from 5.97M to 323k.
   - **No future writes:** a graph is pruned when some spinning thread has a stale read in its current iteration and no
     running thread can still write. `ThreadAnalysis.mayWriteLater` decides this statically with a backward fixpoint
     over each thread's control flow; writes to pthread state words are ignored. On seqlock it cut visited graphs
     further from 323k to 28k, with 0 blocked executions.
6. **Awamoche awaits** (`exploration.awaits`, off by default; Kokologiannakis, Marmanis, Vafeiadis, CAV'23):
   - Single-read await loops are revisited in place.
   - The precondition (unique co placement of each write) is checked on the fly; if it fails, the exploration restarts
     without the optimization.
   - It does not help multi-read loops or CAS retry loops, which dominate the benchmarks. The pruning rules above made
     it unnecessary there.

## Assumptions

1. **Extensibility via an acyclic exploration order.** TruSt assumes `po ∪ rf` is acyclic in all consistent
   executions. This branch generalises it to `E ∪ rf` for an order E:
   - `po` mode: E = `po`. This is valid for SC, TSO and RC11.
   - `dependencies` mode: E = `data | addr | branch;po | addr;po | po-loc | rmw | po;[S] | [S];po`, where S ("strong") is:
     - fences, except instruction fences (`ISB`, `isync`);
     - thread events and failed exclusive stores;
     - exclusive accesses;
     - accesses whose ordering tags are not in the per-architecture "relaxed" set.
   - `branch` covers **all** read-dependent branches, not only the model's `ctrl`.
   - **The user is responsible for the model forbidding `E ∪ rf` cycles.** If the model allows such a cycle, the
     exploration misses those executions (incompleteness), but never reports an inconsistent one.
2. **Thread creation.** The first load of a spawned thread must read from its creator's store, and it is never
   revisited. Thread-creating loops are unrolled.
3. **Not supported** (rejected with an error):
   - mixed-size accesses (`--mixedSize=true`);
   - computations on nondeterministic values (`__VERIFIER_nondet_*` used in arithmetic or branches);
   - CAT relations outside the supported set (e.g. GPU-specific ones);
   - allocation sites that allocate objects of varying size.
4. **Weak store-exclusives** may fail spuriously. The failed node counts as maximally added only if success was
   impossible.

## Correctness status

The status is "tested", not proven.

### Litmus tests

Each test's exploration result is compared with the expected result in the suite's CSV
(`AbstractLitmusTest#testExploration`). All 22,878 tests were re-run on the final code, with `spinLast` on and off:
0 mismatches.

| Suite | Order | Run | Mismatches | Skipped |
|---|---|---|---|---|
| X86 (TSO) | po | 487 | 0 | 0 |
| RC11 | po | 135 | 0 | 8 |
| C11 | dependencies | 135 | 0 | 8 |
| PPC (Power) | dependencies | 2,363 | 0 | 0 |
| RISC-V | dependencies | 6,800 | 0 | 83 |
| LKMM | dependencies | 5,105 | 0 | 97 |
| AARCH64 | dependencies | 7,853 | 0 | 2,743 (mostly mixed-size) |

- **Skipped tests are known incompleteness** (`dartagnan/src/test/resources/exploration-skip.csv`).
  - Apart from mixed-size tests, they need an `E ∪ rf` cycle that the conservative E forbids. On such programs the
    exploration can report `PASS` where the answer is `FAIL`.
  - 37 LKMM tests are skipped because they use nondeterministic values.
- **RISC-V breakdown** (83 tests):

  | Tests | Cause |
  |---|---|
  | 55 | `.aq`/`.rl`, LR/SC and AMOs are treated as two-way barriers. |
  | 12 | Partial fences (`fence.w.w`, `fence.r.rw`) are treated as full fences, and `fence.i` counts as a fence. |
  | 15 | `po-loc` orders write→read same-location pairs (store forwarding, the `rfi`/`wsi` patterns). |
  | 1 | `Luc01+Rlx`, not yet analysed. |

### Other checks

- **JUnit:** `ExplorationTest` and `OptionRegistrationTest` pass (42 tests). They cover spin loops, infinite loops
  with and without a bound, load buffering in loops, and lock benchmarks.
- **Execution sets:** every optimization was validated by dumping the set of complete executions and comparing it with
  the sequential baseline, with 0 lost, 0 extra and no duplicates. This covered parallel vs. sequential, spinLast
  on/off, and the pruning rules, on all benchmarks that finish.
- **Optimality:** complete executions were compared against distinct executions over about 500k executions, in both
  orders, with no duplicates.

## Performance results

### Setup
- **Benchmarks:** all of `benchmarks/locks`, `benchmarks/lfds` and `benchmarks/challenging` (21 programs) under RC11
  (`--target=c11`), Power and aarch64.
- **Eager BMC** (`--method=eager`): bound search from 1 up to 10. The table shows the time of the smallest bound that
  gives `PASS` or `FAIL`, with that bound in parentheses. Eager runs 4 in parallel.
- **TruSt** (exploration): `--exploration.order=dependencies --exploration.threads=16`, default options otherwise
  (spinLast on, awaits off). Runs one at a time. Executions are complete executions.
- **Machine:** MacBook (Apple Silicon), JVM jar (`java -Xss512m -jar`).
- **Timeout:** 15 minutes per run. For Eager, the bound in parentheses on a timeout is the bound that timed out.
- **Why the JVM and not the native image:**
  - The GraalVM native image was about 2× slower for TruSt (e.g. Power chase-lev 8.4 s vs 4.9 s, linuxrwlock 28 s vs
    16 s), even with PGO and `-march=native`.
  - On macOS the native image only has the serial GC, which paused 3.4 s of a 9 s run with all 16 workers idle.
  - Native only wins on start-up, e.g. about 0.1 s vs 1 s for a short Eager run.

### RC11
| Benchmark | Eager | TruSt | Faster |
|---|---|---|---|
| locks/ticketlock | 1.3s PASS (1) | 0.7s PASS (6) | TruSt |
| locks/spinlock | 1.2s PASS (1) | 0.8s PASS (36) | TruSt |
| locks/deadlock | 1.6s FAIL (1) | 0.6s FAIL (0) | TruSt |
| locks/pthread_mutex | 1.1s FAIL (1) | 1.2s FAIL (0) | Eager |
| locks/ttas | 1.5s PASS (3) | 0.9s PASS (162) | TruSt |
| locks/ticket_awnsb_mutex | 3.6s PASS (1) | error (varying-size allocation) | Eager |
| locks/clh_mutex | 1.8s PASS (2) | 1.2s PASS (24) | TruSt |
| locks/mutex | 5.7s PASS (3) | 2.8s PASS (7,086) | TruSt |
| locks/seqlock | 1.2s PASS (1) | 1.2s PASS (1,000) | tie |
| locks/linuxrwlock | 672.2s PASS (4) | 19.6s PASS (38,033) | TruSt |
| locks/mutex_musl | 112.8s PASS (6) | timeout | Eager |
| locks/cna | 7.9s PASS (2) | error (nondet values) | Eager |
| lfds/hash_table | 1.3s PASS (1) | 0.8s PASS (16) | TruSt |
| lfds/chase-lev | 2.0s PASS (1) | 2.6s PASS (11,384) | Eager |
| lfds/dglm | 49.2s PASS (3) | 3.3s PASS (1,488) | TruSt |
| lfds/ms | 206.9s PASS (3) | 2.8s PASS (1,368) | TruSt |
| lfds/treiber | 53.7s PASS (5) | 3.0s PASS (4,812) | TruSt |
| lfds/safe_stack | 34.1s FAIL (2) | timeout | Eager |
| challenging/wsq | 294.2s PASS (5) | 51.3s PASS (7,980) | TruSt |
| challenging/harris-3 | timeout (2) | timeout | — |
| challenging/cna | timeout (3) | error (nondet values) | — |

### Power
| Benchmark | Eager | TruSt | Faster |
|---|---|---|---|
| locks/ticketlock | 1.1s PASS (1) | 0.7s PASS (6) | TruSt |
| locks/spinlock | 1.1s PASS (1) | 0.7s PASS (36) | TruSt |
| locks/deadlock | 1.2s FAIL (1) | 0.6s FAIL (0) | TruSt |
| locks/pthread_mutex | 1.0s FAIL (1) | 0.8s FAIL (0) | TruSt |
| locks/ttas | 1.4s PASS (3) | 0.9s PASS (162) | TruSt |
| locks/ticket_awnsb_mutex | 3.3s PASS (1) | 1.1s PASS (162) | TruSt |
| locks/clh_mutex | 1.4s PASS (2) | 1.1s PASS (24) | TruSt |
| locks/mutex | 4.6s PASS (3) | 3.3s PASS (7,086) | TruSt |
| locks/seqlock | 1.2s PASS (1) | 1.4s PASS (1,000) | Eager |
| locks/linuxrwlock | 444.6s PASS (4) | 17.6s PASS (38,033) | TruSt |
| locks/mutex_musl | 102.5s PASS (6) | timeout | Eager |
| locks/cna | 111.9s PASS (2) | error (nondet values) | Eager |
| lfds/hash_table | 1.2s PASS (1) | 0.8s PASS (16) | TruSt |
| lfds/chase-lev | 1.8s PASS (1) | 4.5s PASS (11,384) | Eager |
| lfds/dglm | 180.9s PASS (3) | 5.2s PASS (1,488) | TruSt |
| lfds/ms | 133.5s PASS (3) | 4.7s PASS (1,368) | TruSt |
| lfds/treiber | 40.1s PASS (5) | 4.4s PASS (4,812) | TruSt |
| lfds/safe_stack | timeout (2) | timeout | — |
| challenging/wsq | timeout (1) | 71.0s PASS (7,980) | TruSt |
| challenging/harris-3 | timeout (2) | timeout | — |
| challenging/cna | timeout (1) | error (nondet values) | — |

### aarch64
| Benchmark | Eager | TruSt | Faster |
|---|---|---|---|
| locks/ticketlock | 1.1s PASS (1) | 0.7s PASS (6) | TruSt |
| locks/spinlock | 1.1s PASS (1) | 0.8s PASS (36) | TruSt |
| locks/deadlock | 1.0s FAIL (1) | 0.6s FAIL (0) | TruSt |
| locks/pthread_mutex | 1.3s FAIL (1) | 0.9s FAIL (0) | TruSt |
| locks/ttas | 1.2s PASS (3) | 0.9s PASS (162) | TruSt |
| locks/ticket_awnsb_mutex | 1.9s PASS (1) | 1.1s PASS (162) | TruSt |
| locks/clh_mutex | 2.3s PASS (2) | 0.9s PASS (24) | TruSt |
| locks/mutex | 2.0s PASS (3) | 1.9s PASS (6,750) | TruSt |
| locks/seqlock | 1.2s PASS (1) | 1.2s PASS (1,000) | tie |
| locks/linuxrwlock | 162.4s PASS (4) | 7.6s PASS (38,033) | TruSt |
| locks/mutex_musl | 23.0s PASS (6) | timeout | Eager |
| locks/cna | 3.2s PASS (2) | error (nondet values) | Eager |
| lfds/hash_table | 1.3s PASS (1) | 0.8s PASS (16) | TruSt |
| lfds/chase-lev | 1.5s PASS (1) | 1.9s PASS (6,800) | Eager |
| lfds/dglm | 9.9s PASS (3) | 2.2s PASS (1,488) | TruSt |
| lfds/ms | 35.0s PASS (3) | 2.2s PASS (1,368) | TruSt |
| lfds/treiber | 13.0s PASS (5) | 2.4s PASS (4,812) | TruSt |
| lfds/safe_stack | 30.1s FAIL (2) | timeout | Eager |
| challenging/wsq | 49.7s PASS (5) | 9.8s PASS (7,980) | TruSt |
| challenging/harris-3 | timeout (2) | timeout | — |
| challenging/cna | 124.5s PASS (3) | error (nondet values) | Eager |

### Summary

| Model | TruSt faster | Eager faster | Tie | Neither finishes |
|---|---|---|---|---|
| RC11 | 12 | 6 | 1 | 2 |
| Power | 14 | 4 | 0 | 3 |
| aarch64 | 14 | 5 | 1 | 1 |

- **Large TruSt wins:**
  - linuxrwlock: 19.6 s vs 672 s on RC11, 17.6 s vs 445 s on Power, 7.6 s vs 162 s on aarch64.
  - ms, dglm and treiber: 5–70× faster.
  - wsq on Power: TruSt passes in 71 s, while Eager times out already at bound 1.
  - TruSt gives `PASS` without a bound; Eager needs to find the right bound first.
- **Close losses:**
  - chase-lev: Eager is 0.4–2.7 s faster.
  - seqlock on Power and pthread_mutex on RC11: within 0.2 s.
- **Real gaps:**
  - mutex_musl: TruSt does not finish even with 20 minutes and 16 workers; Eager needs bound 6. The Godot paper
    reports 136,728 complete executions for mutex-musl(3) in GenMC.
  - safe_stack: Eager finds the termination bug at bound 2 on RC11 and aarch64, while TruSt has to explore everything
    first.
- **Errors are unsupported features, not wrong results:**
  - cna (nondeterministic values);
  - ticket_awnsb_mutex on RC11 only (an allocation whose size varies under the C11 target).

### Progress on this branch

The first version of this file reported, under aarch64:

| Benchmark (aarch64) | First version | Now |
|---|---|---|
| lfds/dglm | 53 s | 2.2 s |
| lfds/ms | 63 s | 2.2 s |
| challenging/wsq | 362 s (3,991 executions, as reported then) | 9.8 s (7,980 executions) |
| locks/linuxrwlock | timeout | 7.6 s |

Power treiber went from 182 s to 4.4 s. Where Eager used to be 2–4× faster on lfds, TruSt is now 5–70× faster.

## What is missing / next steps

1. **mutex_musl and harris-3:** these still time out. Candidates:
   - Godot's independent fetch-and-add (IFAA) and Partial Loop Purity (Jonsson et al., *Awaiting for Godot*);
   - a bug-finding search mode, which would also catch the safe_stack bug early.
2. **Incremental consistency checking:** consistency checking is still about 80% of the time per graph. On Power
   chase-lev, the time splits into compose 44%, the recursive `ppo` fixpoint 33% and transitive closure 17%. Updating
   relations for the new event, instead of re-evaluating the whole model, is the main remaining speed-up.
3. **Finer exploration order:**
   - one-directional acquire/release;
   - fences that order only the access types they name;
   - `fence.i` not counted as a fence.

   This would shrink the skip list for RISC-V, ARM and LKMM.
4. **Unsupported inputs:**
   - **nondeterministic values:** enumerate finite domains or use symbolic values; this is needed for cna;
   - **varying-size allocations:** needed for ticket_awnsb_mutex on RC11;
   - **mixed-size accesses**.
5. **Dynamic thread creation:** this would remove the need to unroll thread-creating loops.
6. **Native image:** it needs a parallel GC to be competitive. G1 is available on Linux, not macOS. Evaluate it on
   Linux.
