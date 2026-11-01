# Online CAAT: memory-model consistency as a Z3 user propagator

## Motivation

The `lazy` method (`RefinementSolver`) implements CAAT ("CAAT: Consistency as a Theory", OOPSLA 2022) as an
*offline* theory solver: the SMT solver produces a complete execution, CAAT checks it, and if it is inconsistent
the reasons are added as refinement clauses and the SMT solver is restarted.
Conflicts are only found on complete models, and every refinement iteration re-runs the SMT search.

This branch adds `--method=online`, which integrates the same CAAT theory into Z3 as a **user propagator**
(via java-smt's `UserPropagator` API). The theory is consulted on **partial** assignments, so inconsistencies are
detected as soon as the assigned atoms imply them, and the SMT search is never restarted.
Some ideas (theory propagation of literals that would close cycles) follow the spirit of
"Satisfiability Modulo Ordering Consistency Theory" (He et al., OOPSLA 2022).

## What was implemented

**Online theory solver** (`solver/onlinecaat/`):
- `OnlineCAATPropagator`: theory atoms are the execution variables of events, the edge variables of encoded
  relations (rf, co, relations below the cut), and a few address equalities. When atoms get fixed, the
  corresponding base edges are added to the CAAT model (timestamped with the decision level) and propagated
  to derived relations; on backtracking, the model is backtracked by timestamp.
  Violations are translated back into fixed atoms and reported as conflicts.
  Soundness: every materialized edge is implied by the currently fixed atoms and the CAAT axioms are monotone,
  so any violation found on a partial assignment is a genuine conflict.
- `OnlineBaseGraph` / `OnlineBaseSet`: base relations defined by candidate pairs (may-sets); an edge holds once
  both endpoints are executed and its atom is true (or the pair is a must-pair).
  Derived relations that only depend on static relations and whose may/must sets coincide are treated as
  static base relations.
- `AntiMonotoneGraphView` / `AntiMonotoneSetView`: relations used on the right-hand side of differences are
  represented by "not known to be absent" views, so differences under-approximate soundly.
- `loc` is derived from rf/co (`(id_W | rf^-1);(id_W | co | co^-1);(id_W | rf)`) plus must-alias pairs and a
  few address equalities (read/init-write pairs, possibly uninitialized reads), because registering all address
  equalities slows Z3 down considerably.

**Performance techniques:**
- *Symmetric learning*: like the offline solver, conflicts are mapped through thread-symmetry generators and
  the symmetric clauses are added as lemmas. Z3 needs `smt.up.persist_clauses=true` (set by `RefinementSolver`
  for the online method) or it discards such lemmas on backtracking — this alone reduced conflicts by 3–5×.
- *Batched processing*: fixed atoms are processed once the decision level is complete (push callback);
  conflicts found there are reported at the next callback. Atoms undone by Z3's own conflicts are never processed.
- *Theory propagation*: for acyclicity axioms, the negation of rf/co (and similar) atoms that would close a
  cycle is propagated.
- *Shorter reasons*: execution literals implied by other literals are dropped (as in `CoreReasoner`).
- *Dead-predicate pruning* in `PredicateHierarchy`: predicates whose changes are irrelevant (statically empty,
  only queried by intersections, all dependents dead) are not maintained.
- Faster CAAT data structures: dense/open-addressing edge storage (`EdgeStore`, `PairMap`), trail-based
  backtracking in `SimpleGraph`/`SimpleSet`, cached lookups in `PredicateHierarchy`.

**Integration:**
- New `Method.ONLINE` (`--method=online`), handled by `RefinementSolver.createOnline`. The offline refinement loop
  is kept as a safety net; in all benchmarks it needs no extra iteration. Conflicts found during the property
  check are re-added as permanent constraints for the bound check.
- Solvers without user-propagator support (e.g. Yices2, the default on Linux) fall back to offline refinement
  with a warning; use `--solver=z3`.
- `jni-config.json`: JNI entries for Z3's propagator callbacks, needed by the GraalVM native image.
- Tests: `testOnlineRefinement` in `AbstractVerificationTaskSolverTest` (runs online on all solver tests);
  `-Ddat3m.test.methods=lazy,online` restricts the tested methods. New `EdgeStorageTest`.

## Correctness

All lazy and online litmus tests pass (AArch64, PPC, RISC-V, x86, C11, RC11: 35,549 tests); results on all
CI benchmarks agree with `eager` and `lazy`.

## Results

Benchmarks from `.github/performance-benchmarks.yml`, GraalVM native builds, Z3, 180 s timeout, macOS ARM64.
Baseline = unmodified `master` (b81ec6c55). The three methods ran concurrently on a shared machine, so individual
timings vary by roughly ±15%.

| Benchmark | Model | eager | lazy | online |
|---|---|---:|---:|---:|
| locks/cna | vmm | 10.5 | 15.4 | **5.5** |
| locks/linuxrwlock (bound 2) | aarch64 | 10.8 | 15.3 | **8.7** |
| locks/linuxrwlock (bound 2) | power | 31.6 | **17.0** | 18.9 |
| locks/mutex_musl (bound 5) | aarch64 | **8.9** | 11.9 | 10.4 |
| locks/mutex_musl (bound 4) | power | 21.4 | **6.0** | 7.4 |
| locks/mutex_musl (bound 3) | vmm | 24.6 | 19.0 | **7.7** |
| lfds/dglm (bound 3) | aarch64 | **9.8** | 17.9 | 15.9 |
| lfds/dglm | power | 7.1 | **1.9** | 2.5 |
| lfds/dglm (bound 2) | vmm | 35.8 | 19.3 | **19.1** |
| lfds/ms (bound 2) | aarch64 | **9.9** | 28.1 | 20.6 |
| lfds/ms (bound 2) | power | 35.9 | **23.8** | 32.8 |
| lfds/ms (bound 2) | vmm | 58.3 | 54.1 | **30.9** |
| lfds/treiber (bound 4) | power | 17.1 | **7.9** | 9.2 |
| lfds/treiber (bound 3) | vmm | 9.5 | 10.2 | **7.5** |
| lfds/safe_stack | vmm | **7.4** | 29.5 | 9.7 |
| challenging/cna (bound 2) | aarch64 | 18.3 | **15.1** | 17.8 |
| challenging/cna | vmm | 25.0 | **4.9** | 6.4 |
| challenging/wsq | aarch64 | **11.2** | 23.7 | 32.1 |
| **Total** | | 353.2 | 321.2 | **263.2** |

- Online vs lazy: **1.22× faster in total**, faster on 10/18 configurations.
- Online vs eager: **1.34× faster in total**, faster on 13/18 configurations.
- By model: vmm is where online shines (up to ~2× over lazy); on aarch64 eager is usually best;
  on power lazy is still faster on all five configurations.

Across repeated runs the totals were consistent (online 1.13–1.26× faster than lazy, 1.27–1.42× faster than eager);
configurations within ~15% of each other flip between runs.

## Limitations and next steps

- **Power**: the model has transitive closures (`hb*`, `propbase*`) that are expensive to maintain incrementally
  under frequent backtracking; lazy recomputes them only ~100 times per benchmark. Checking those axioms only on
  final checks, or using a virtual reflexive closure, were both slower. A better incremental closure algorithm
  (e.g. dynamic topological order / Pearce-Kelly) is the main open item.
- The CI performance job runs the default (eager) method with the platform's default solver; to compare the
  online method there, it needs `--method=online --solver=z3`.
