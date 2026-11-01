# Branch `agentic/trust`: stateless model checking (TruSt) in Dartagnan

This branch adds a new task to Dartagnan: **exploration**. It enumerates the consistent executions of a program with the
TruSt algorithm (Kokologiannakis et al., *Truly Stateless, Optimal Dynamic Partial Order Reduction*, POPL'22,
[doi:10.1145/3498711](https://dl.acm.org/doi/10.1145/3498711)). Each execution graph is checked directly against the CAT
model. No SMT solver is involved, and loops are not unrolled.

```
dartagnan cat/aarch64.cat --target=arm8 program.c --mode=exploration \
    [--exploration.order=po|dependencies] [--exploration.maxEventsPerThread=N] \
    [--exploration.threadCreationBound=N] [--exploration.printExecutions=true]
```

## What is implemented

### Task and plumbing

- `ExplorationTask`, `ExplorationTaskSolver` and `ExplorationResult` live in `task/exploration/`, next to
  `task/verification/` and `task/enumeration/`.
- `--mode=exploration` (a new value of `configuration.Mode`), output and exit codes in `OutputGenerator`, option registration
  (`OptionInfo`, native-image `reflect-config.json`).
- Options:
  - `exploration.order`: `po` (default, the paper's algorithm) or `dependencies` (see Assumptions).
  - `exploration.maxEventsPerThread`: cuts off executions longer than this bound. The default 0 means unbounded.
  - `exploration.threadCreationBound`: unrolling bound for loops that create threads (default 8).
  - `exploration.printExecutions`: prints every complete execution.
- Result semantics:
  - `FAIL`: a violation was found (assertion, CAT flag, termination), or an `exists` specification is unreachable
    and the exploration was exhaustive.
  - `PASS`: the exploration was exhaustive and found no violation, or an `exists` specification was reached.
  - `UNKNOWN`: otherwise, i.e. some execution exceeded a bound.

### Core (`task/exploration/`)

| Class | Role |
|---|---|
| `TruStExplorer` | Algorithm 1 of the paper, using an explicit work stack: read/write visits, coherence placements, backward revisits, the maximal-extension check, handling of full graphs and statistics. |
| `ExplorationGraph` | Execution graph: nodes, `rf`, `co` per location, per-thread nodes and porf-prefix computation. Holes are allowed in dependencies mode. |
| `ThreadInterpreter`, `ThreadState` | Concrete interpreter of the processed (non-unrolled) program. It tracks data, address and control dependencies at run time and replays a thread against an existing graph. |
| `ConcreteEvaluator`, `Values` | Concrete expression evaluation. Values are bit-vectors stored modulo 2^w, plus a lazy `UNDEFINED` for nondeterministic values. |
| `MemoryLayout` | Deterministic addresses for static objects and per-instance dynamic allocations, plus init nodes. |
| `ConsistencyChecker`, `BitMatrix` | Evaluates arbitrary `.cat` models on a graph with bit matrices, using fixpoints for recursive definitions. Supports the axioms (acyclic, irreflexive, empty, flagged) and the base relations used by the CPU models. |
| `ExplorationOrder` | The exploration order E (`po` or `dependencies`) and the per-thread tracker that computes E-predecessors of new events. |
| `Node` | Immutable event instance. |

### Loops without unrolling

- **Spin loops.** `DynamicSpinLoopDetection` instruments every loop. An iteration without side effects (a taken
  `SPINLOOP` jump) blocks the thread: the execution is counted as *blocked* and not extended.
- **Liveness.** A full graph is a liveness violation if a spinning thread's last-iteration reads all read
  co-maximal writes.
- **Programs with infinite executions.** These run forever, unless `exploration.maxEventsPerThread` is set; with the
  bound, the result is `UNKNOWN` unless a violation is found.

### Changes outside the new package

- `ProcessingManager.forExploration`: the pipeline without loop unrolling (no `NaiveLoopBoundAnnotation`, no
  `NonterminationDetection`).
- `LoopUnrolling.forThreadCreatingLoops`: unrolls only loops that contain thread creation.
- `DynamicSpinLoopDetection.withZeroInitializedTracking`: in exploration mode, the registers tracked by the
  instrumentation are zero-initialised instead of nondet. Any value is a valid choice, and the concrete interpreter
  needs a defined one. BMC is unchanged.
- `Intrinsics.matches`: recognises the Darwin symbol prefix `\01` (e.g. `\01_pthread_join`). Without this, joins in C
  files compiled on macOS were silently dropped.
- `README.md`: new section "Stateless model checking (exploration)".

## Assumptions

1. **Extensibility via an acyclic exploration order.** TruSt assumes `po ∪ rf` is acyclic in all consistent
   executions. This branch generalises it to `E ∪ rf` for an order E:
   - `po` mode: E = `po`. This is valid for SC, TSO and RC11.
   - `dependencies` mode: E = `data | addr | branch;po | addr;po | po-loc | rmw | po;[S] | [S];po`, where S ("strong") is:
     - fences, except instruction fences (`ISB`, `isync`);
     - thread events and failed exclusive stores;
     - exclusive accesses;
     - accesses whose ordering tags are not in the per-architecture "relaxed" set.
   - `branch` covers **all** read-dependent branches, not only the model's `ctrl`. LKMM's `if` gives `ctrl` only to the
     branch body, but whether later events exist depends on the branch; using only `ctrl` broke replay.
   - **The user is responsible for the model forbidding `E ∪ rf` cycles.** If the model allows such a cycle, the
     exploration misses those executions (incompleteness), but never reports an inconsistent one.
2. **Thread creation.** The first load of a spawned thread must read from its creator's store, and it is never
   revisited. Thread-creating loops are unrolled, because Dat3M's thread lowering assumes one thread per creation site.
3. **Not supported** (rejected with an error):
   - mixed-size accesses (`--mixedSize=true`; otherwise locations are address-based, as in BMC by default);
   - computations on nondeterministic values (`__VERIFIER_nondet_*` used in arithmetic or branches);
   - CAT relations outside the supported set (e.g. GPU-specific ones);
   - allocation sites that allocate objects of varying size.
4. **Weak store-exclusives** may fail spuriously. The failed node counts as maximally added only if success was
   impossible.

## Correctness status

The status is "tested", not proven.

### Litmus tests

Each test's exploration result is compared with the expected result in the suite's CSV (`AbstractLitmusTest#testExploration`).

| Suite | Order | Run | Mismatches | Skipped |
|---|---|---|---|---|
| X86 (TSO) | po | 487 | 0 | 0 |
| RC11 | po | 135 | 0 | 8 |
| C11 | dependencies | 135 | 0 | 8 |
| PPC (Power) | dependencies | 2,363 | 0 | 0 |
| RISC-V | dependencies | 6,800 | 0 | 83 |
| LKMM | dependencies | 5,105 | 0 | 97 |
| AARCH64 | dependencies | 7,853 | 0 | 2,743 (mostly mixed-size) |

- **No unsound results.** No test reports a behaviour the model forbids.
- **Optimality.** I compared complete executions against distinct executions over about 500k executions, in both
  orders, and found no duplicates.
- **Skipped tests are known incompleteness** (`dartagnan/src/test/resources/exploration-skip.csv`). Apart from
  mixed-size tests, they need an `E ∪ rf` cycle that the conservative E forbids. On such programs the exploration
  can report `PASS` where the answer is `FAIL`. One exception: 37 LKMM tests are skipped because they use
  nondeterministic values.
- **RISC-V breakdown** (83 tests):

  | Tests | Cause |
  |---|---|
  | 55 | `.aq`/`.rl`, LR/SC and AMOs are treated as two-way barriers. |
  | 12 | Partial fences (`fence.w.w`, `fence.r.rw`) are treated as full fences, and `fence.i` counts as a fence. |
  | 15 | `po-loc` orders write→read same-location pairs (store forwarding, the `rfi`/`wsi` patterns). |
  | 1 | `Luc01+Rlx`, not yet analysed. |

  Narrowing the first two groups (one-directional acquire/release, fences that order only the access types they name)
  is sound and would recover most of these. The same applies to ARM and LKMM.

### Other tests

- `ExplorationTest` has 40 tests: spin loops, infinite loops (with and without a bound), load buffering in loops, and
  lock benchmarks. It includes exhaustiveness checks, and an unbounded program must not terminate.
- Re-run without regressions:
  - before the last change: `OptionRegistrationTest`, program processing and analysis tests, `CLocksTest`,
    `MiscellaneousTest`;
  - after it: `RC11LocksTest`.
- **Not yet re-run since the last change (`DynamicSpinLoopDetection` zero-init):** the litmus exploration suites.
  Litmus tests rarely have loops, so no effect is expected.

## Current results: performance benchmarks

Benchmarks are from `.github/performance-benchmarks.yml`:
- **Eager BMC** (`--method=eager`) runs at the *smallest bound that gives PASS*.
- **Exploration** runs with `--exploration.order=dependencies` and no bound.
- **Setup:** 15-minute timeout, one run each, JVM jar, 4 runs in parallel on a MacBook (Apple Silicon).
- **Columns:** Complete = executions where all threads terminated; Blocked = executions with a spinning thread;
  Graphs = all graphs visited; n/r = not recorded; ? = timed out before printing.
- **Best time** is in bold.

| Benchmark | Model | Eager bound | Eager time | Exploration result | Exploration time | Complete | Blocked | Graphs | Revisits |
|---|---|---|---|---|---|---|---|---|---|
| lfds/dglm | aarch64 | 3 | **15 s** | PASS | 53 s | 1,488 | 21,008 | 444,359 | 9,982 |
| lfds/dglm | vmm | 3 | 91 s | PASS | **90 s** | 1,488 | 28,640 | 507,517 | 10,850 |
| lfds/dglm | power | 3 | **237 s** | PASS | 243 s | 1,488 | n/r | 648,648 | n/r |
| lfds/ms | aarch64 | 3 | **32 s** | PASS | 63 s | 1,368 | 35,784 | 566,041 | 16,602 |
| lfds/ms | vmm | 3 | 302 s | PASS | **74 s** | 1,368 | 37,032 | 577,897 | 17,018 |
| lfds/ms | power | 3 | **236 s** | PASS | 256 s | 1,368 | n/r | 762,316 | n/r |
| lfds/treiber | vmm | 5 | 74 s | PASS | **65 s** | 4,812 | 28,264 | 951,826 | 23,075 |
| lfds/treiber | power | 5 | **60 s** | PASS | 182 s | 4,812 | n/r | 1,129,931 | n/r |
| lfds/safe_stack | vmm | none | > 900 s (at 2) | TIMEOUT | > 900 s | ? | ? | ? | ? |
| locks/mutex_musl | aarch64 | 6 | **31 s** | TIMEOUT | > 900 s | ? | ? | ? | ? |
| locks/mutex_musl | vmm | 6 | **532 s** | TIMEOUT | > 900 s | ? | ? | ? | ? |
| locks/mutex_musl | power | 6 | **116 s** | TIMEOUT | > 900 s | ? | ? | ? | ? |
| locks/linuxrwlock | aarch64 | 4 | **163 s** | TIMEOUT | > 900 s | ? | ? | ? | ? |
| locks/linuxrwlock | power | 4 | **439 s** | TIMEOUT | > 900 s | ? | ? | ? | ? |
| locks/cna | vmm | 2 | **19 s** | unsupported (nondet) | – | – | – | – | – |
| challenging/cna | aarch64 | 3 | **150 s** | unsupported (nondet) | – | – | – | – | – |
| challenging/cna | vmm | none | > 900 s (at 3) | unsupported (nondet) | – | – | – | – | – |
| challenging/wsq | aarch64 | 5 | **50 s** | PASS | 362 s | 3,991 | n/r | 1,851,271 | n/r |

### Observations

- **Lock-free data structures:** exploration proves all 8 dglm/ms/treiber configurations, without needing a bound.
  - Under `vmm` it is on par with or faster than eager (ms: 74 s vs 302 s).
  - Under `aarch64`, eager is 2–4× faster. Under `power` they are about even, except treiber (3×).
- **Locks:** eager wins clearly. Exploration times out on mutex_musl and linuxrwlock.
- **The cost is per graph.** About 8–15k graphs/s under vmm/aarch64, but only about 2.5–6k under power, because the
  whole CAT model is re-evaluated on every graph.
- **Blocked spin iterations** outnumber complete executions by 6–27×.
- **Earlier result (RC11 lock benchmarks):** ttas and the three mutex variants give `PASS` with exploration, where BMC
  at bound 1 says `UNKNOWN`. The buggy variants give `FAIL` with both.

## Next steps

1. **Incremental consistency checking:** update relations for the new event instead of re-evaluating the whole model.
   This is the main performance bottleneck.
2. **Finer exploration order:** one-directional acquire/release, fence types that order only the access types they
   name, and `fence.i` not counted as a fence. This would shrink the skip list for RISC-V, ARM and LKMM.
3. **Fewer blocked executions:** prune them earlier, e.g. avoid revisits that only lead to blocked graphs.
4. **Dynamic thread creation:** removes the need to unroll thread-creating loops.
5. **Nondeterministic values:** enumerate finite domains (bool) or use symbolic values; this is needed for cna.
6. **Re-run the litmus exploration suites** after the `DynamicSpinLoopDetection` change.
