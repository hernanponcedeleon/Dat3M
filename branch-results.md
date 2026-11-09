# Lazy transitive closures for the eager encoding

Branch `agentic/lazy-closures`, based on `development` (`c279ca9b0`). This file documents what the branch
does, how it was tested, the performance results, and what is still open.

The branch was first developed on `f5c2eb3cf` and then rebased onto `development`, which in the meantime got
a polarity-aware encoding of the memory model (#1154) and a cheaper eager encoding of transitive closures
(#1159). After the rebase, the branch reuses the polarity analysis of #1154 instead of its own, and the
performance numbers below were measured again against the new `development`.

## Summary

In the eager method (`AssumeSolver`), transitive closures that the memory model only uses negatively are no
longer encoded with the cubic eager definition. Instead, a Z3 user propagator (`ClosurePropagator`) enforces
them during the search: as soon as the current assignment contains a path, the corresponding closure edge is
propagated, with the literals of the path as the reason.

- Which closures qualify is computed from the `.cat` model (`PolarityAnalysis`, from `development`). Nothing has
  to be configured.
- **Against the current `development`, lazy closures no longer pay off.** On the 18 configurations of the CI
  performance job (3 runs each, CI script), total time goes from 215.2 s to 225.8 s: 4.9% slower (99%
  confidence interval: 11.2% slower to 1.3% faster). vmm is significantly slower (10.8%), power and aarch64 are
  unchanged overall. See [Performance](#performance).
- With larger bounds (chosen so that `development` returns PASS/FAIL, which 17 of the 18 configurations now do),
  the picture is the same: 653.9 s vs 693.2 s, 6.0% slower (not significant). Lazy closures help on power
  `lfds/dglm.c` (45% faster) and vmm `locks/cna.c` (13%), and hurt on power `locks/linuxrwlock.c` (31% slower)
  and vmm `lfds/treiber.c` (8%); vmm `lfds/dglm.c`, `lfds/ms.c` and `lfds/safe_stack.c` are slower in every
  pair (16–48% on average) but too noisy to be significant.
- Before the rebase, against `f5c2eb3cf`, the same change made the CI benchmarks 35% faster (391.0 s to
  254.2 s). Most of that gain is now delivered by `development` itself: #1154 and #1159 encode the closures
  more cheaply, and `development` went from 391.0 s to 215.2 s on these benchmarks.
- The option `encoding.wmm.lazyClosures` is on by default (`--encoding.wmm.lazyClosures=false` disables it).
  It only has an effect with the eager method and Z3. Given the numbers above, it should probably be off by
  default (see [TODOs](#todos-and-possible-improvements)).

## Motivation

The numbers in this section were measured on `f5c2eb3cf`, before #1154 and #1159; the reasoning still applies,
but #1159 made the eager closure encoding cheaper (see [Performance](#performance) for the current comparison).

On the CI benchmarks, each run is dominated by a single UNSAT `solver.check()`; parsing, compilation and
encoding take about 2 s. Z3's statistics show that the solver does not search much, but it propagates a lot:

| `lfds/ms.c`, bound 2 | Time | Conflicts | Propagations |
|---|---:|---:|---:|
| vmm, program spec only | 9.9 s | 15.7k | 50M |
| vmm, CAT spec only (data race flags) | 44.2 s | 19.3k | 740M |
| vmm, all properties (default) | 52.5 s | 19.1k | 683M |
| aarch64, all properties | 10.7 s | 14.0k | 68M |
| power, all properties | 37.5 s | 14.6k | 468M |

The extra propagations come from the eager encoding of transitive closures: vmm's `hb^+` (used only by the data
race flags) and power's `hb*`, `com*` and `propbase*`. The eager encoding defines every closure edge as a
disjunction over intermediate events, which is cubic. These closures are only used negatively (under
`acyclic`, `irreflexive` and `empty` axioms, or as what the race flags subtract), so the solver never needs
"closure edge implies path", only "path implies closure edge". Since #1154, `development` already encodes only
that direction, but it still encodes it upfront for every closure edge. A propagator can enforce it on demand
instead.

## What the branch changes

### Which closures become lazy: `PolarityAnalysis`

`PolarityAnalysis` (added to `development` by #1154) computes in which direction each relation is used:

- Axioms (`acyclic`, `irreflexive`, `empty`) use their relation negatively, negated axioms (`~empty`, ...)
  positively. Flagged axioms are treated the same way, because a flag is raised when its axiom holds.
- A difference passes the polarity on to the minuend and flips it for the subtrahend. Every other definition is
  monotone and passes it on to its operands.
- `PolarityAnalysis` names polarities syntactically, so a relation that occurs only under non-negated axioms is
  `POSITIVE` there. This file says "used negatively" for it, as in the code comments of the branch.

The branch originally had its own analysis (`RelationPolarity`). It computed the same polarities, except that it
treated `Assumption` constraints as using their relation in both directions; those are only created by the
refinement solver, which never uses lazy closures. `WmmEncoder.getNegativelyUsedClosures` now just selects the
transitive closures that `PolarityAnalysis` reports as `POSITIVE`.

A transitive closure that is only used negatively becomes lazy. For the shipped models:

| Model | Lazy closures |
|---|---|
| power | `hb^+`, `com^+`, `propbase^+`, `__iddTrans` |
| arm | `hb^+`, `propbase^+`, `__iddTrans` |
| vmm | `hb^+` |
| rc11 | `hb`, `eco`, `(rf ; myrmw)^+` |
| imm | `hb`, `(deps \| rfi)^+`, `(((po-loc \| id) ; rf) ; rmw)^+`, `__iddTrans` |
| linux-kernel | `hb^+`, `pb^+`, `cumul-fence^+`, `((hb \| pb) \| rb)^+`, `(rf ; rmw)^+`, `(data ; ... ; rf)^+`, `(data ; ... ; rfi)^+`, `__iddTrans` |
| ptx-v6.0, ptx-v7.5 | `(((sync \| sync_fence) \| sync_barrier) ; (po \| id))^+`, `__iddTrans`, and `observation^+` in v7.5 |
| vulkan, vulkan-chains | 19 closures, e.g. `ssw^+`, `([W] ; locord)^+` and the scoped synchronization closures |
| svcomp | `hb-race` |
| aarch64, riscv, riscv-orig | `__iddTrans` |
| sc, tso, c11, opencl, ... | none |

Whether a closure is actually handled by the propagator also depends on the program: closures without lazy
edges (see below) keep their eager encoding, which is linear in that case.

### Why this is sound

If a closure `R^+` is only used negatively, removing edges from `R^+` can never falsify a constraint. So the
encoding only needs the lower bound "path in `R` implies edge in `R^+`": any model of the weakened encoding can
be turned into a model of the full one by setting `R^+` to the actual transitive closure. Satisfiability, and
therefore every verdict, is unchanged.

- Must-edges of the closure keep their definition in the formula ("both events execute", in the direction
  required by the polarity-aware encoding).
- The remaining edges of the closure's active set (the *lazy edges*) get no definition in the formula. The
  propagator forces them to true when a path exists.
- The propagator builds paths from edges of the operand in its active set, must-edges of the operand or of the
  closure (which hold iff both events execute), and closure must-edges that end in the target of a lazy edge.
  These include all steps of the eager encoding (`WmmEncoder.visitTransitiveClosure`; since #1159 it skips
  steps implied by must-edges), so the propagator forces at least every closure edge that the eager encoding
  would force. The comments in `ClosurePropagator` give the details.
- The polarity-aware encoding of #1154 may let edge variables of the operand be true without the edge being in
  the relation. The propagator then forces more closure edges than necessary, which only restricts the solver in
  a direction it can always undo (by setting the operand edge to false), so verdicts are unaffected.

### The propagator: `ClosurePropagator`

- One graph per lazy closure over the events involved. Reachability is stored as bitset rows, so a closure with
  more than 2048 events keeps its eager encoding (logged at INFO level).
- When a step literal (or the execution literal of an event, for steps that hold iff both events execute)
  becomes true, the transitive closure is updated incrementally: every event that reaches `u` now also reaches
  `v` and everything `v` reaches.
- Every newly reachable pair that is a lazy edge is propagated. The reason is the conjunction of the step and
  execution literals of a witnessing path, rebuilt from a table that records the step that last extended a path.
  In the runs we inspected, the average reason has 1–6 literals.
- Changes are recorded on a trail and undone when the solver backtracks (`onPush`/`onPop`).
- Edges implied by steps that always hold are known before the solver starts. They are returned by
  `encodeInitialFacts()` and asserted with the rest of the formula.
- At INFO level, the solver logs which closures were lazy and how much was propagated, e.g.
  `Lazy closures: hb^+: 138 events, 3466 steps; #propagations: 2647160, avg. reason size: 6.1`.

### Where it is used

- `WmmEncoder.withContext(context, allowLazyClosures)`. Only `AssumeSolver` allows lazy closures; every other
  user of `WmmEncoder` (e.g. `RefinementSolver`) keeps the full eager encoding.
- `SMTModelChecker.canUseUserPropagators()`: only Z3 supports user propagators in JavaSMT, and a dumped SMT-LIB
  file would not be self-contained without the propagator, so lazy closures are off when dumping.
- Lazy closures are also off when symmetry breaking is enabled: its constraints can use any relation and are not
  seen by the polarity analysis.
- Execution models and witness graphs are not affected: `ExecutionModelManager` rebuilds closures from their
  operands instead of reading the closure literals. The list of violated flags is (see TODO 4).

### Files

| File | Change |
|---|---|
| `encoding/ClosurePropagator.java` | new: the user propagator |
| `encoding/WmmEncoder.java` | option, lazy closure candidates from `PolarityAnalysis`, lazy path in `visitTransitiveClosure`, `getLazyClosures()` |
| `task/verification/AssumeSolver.java` | registers the propagator, logs its statistics |
| `task/SMTModelChecker.java` | `canUseUserPropagators()` |
| `encoding/SymmetryEncoder.java` | `isEnabled()` |
| `configuration/OptionNames.java` | `LAZY_CLOSURES` |
| `META-INF/native-image/.../jni-config.json` | the 8 callbacks of the Z3 propagator, for the native image |
| `.github/scripts/check-native-and-solvers.py` | native check that runs a configuration with lazy closures |
| `.github/workflows/maven.yml` | new "Encoding tests" step (no CI step ran `com/dat3m/dartagnan/encoding/**` before) |
| `LazyClosureCandidatesTest`, `LazyClosuresTest` | new tests |
| `benchmarks/miscellaneous/dataRaceWrites.c`, `dataRaceFreeChain.c` (+ `.ll`) | new programs for the vmm race flags |

## Testing

- `LazyClosureCandidatesTest` (5 tests): which closures become lazy (axioms, negated axioms, flags,
  differences) and the closures of the shipped vmm and power models.
- `LazyClosuresTest` (9 configurations, eager method): power, rc11 and imm consistency (PASS, FAIL and UNKNOWN),
  and the vmm data race flags: a racy program (FAIL), a race-free one (PASS) and `lfds/ms` (UNKNOWN).
- Regression run with the option forced on (before it became the default), with the same propagator on the
  previous `development` commit (`f6af468b6`): all litmus suites (including the exploration tests) and all LLVM
  suites, with both methods. 86,440 tests, 0 failures, 7,935 skipped, 28 errors, all of them
  "The SMT solver YICES2 is not available on this machine". The only change since then: closures without lazy
  edges keep their eager encoding.
- Before the rebase, on the branch's code: the CI code-style check passed, and `RelationPolarityTest`,
  `LazyClosuresTest`, `LitmusPPCTest` and `CLocksTest` passed (4,973 tests).
- After the rebase (with `PolarityAnalysis` and the polarity-aware encoding of #1154): the CI code-style check
  (`mvn -Pstyle-check clean test-compile`) passes, and `LazyClosureCandidatesTest`, `LazyClosuresTest`,
  `RC11LocksTest`, `IMMLocksTest` and `CLocksTest` pass (360 tests). The full regression run above was not
  repeated after the rebase.
- `PolarityAnalysis` and the former `RelationPolarity` select the same lazy closures for every `.cat` file in
  `cat/` (checked with a throwaway test), so the table of lazy closures per model above still holds.
- Not run locally: the native image. The CI native job builds it on all platforms and runs the new lazy
  closures check.

## Performance

### Setup

- The CI's own `scripts/compare_performance.py` with `.github/performance-benchmarks.yml`: 18 configurations,
  3 runs each, `--jobs 1`, `--timeout 180`. The script alternates which version runs first in each pair.
- Base: `development` (`c279ca9b0`). PR: this branch (`88e6ea7c1`, i.e. after the rebase and the switch to
  `PolarityAnalysis`).
- Differences from the CI: the jar ran on the JVM (Oracle GraalVM 25.0.4, Z3 4.14.0) instead of a native
  image, using a small launcher at `dartagnan/target/dartagnan`. The machine (macOS, 18 CPUs) was shared with
  other jobs (load average 9–13).
- Two configurations were measured again with the same script, and the table uses the second measurement:
  vmm `lfds/dglm.c`, because one base run reported 923 s (above the 180 s timeout, so the machine most likely
  slept during that run; the other runs of both versions took 12.5–15.7 s), and power `lfds/ms.c`, whose first
  measurement was very noisy for both versions (17.1–65.0 s base, 19.6–31.5 s branch). The second measurement
  gives 14.2–16.3 s and 13.6–15.5 s.
- Times are Dartagnan's `Time:` values, mean ± standard deviation over the 3 runs. "Faster by" is the mean of
  the paired relative improvements with its 99% confidence interval, as computed by the CI script (negative:
  this branch is slower).

### Results

| Model | Benchmark | Bound | development | this branch | Faster by (99% CI) | Result |
|---|---|---:|---:|---:|---:|---|
| vmm | locks/cna.c | 1 | 4.0 ± 0.3 s | 3.5 ± 0.2 s | +12.3% [-26.6%, +51.3%] | UNKNOWN |
| vmm | locks/mutex_musl.c | 3 | 6.2 ± 0.1 s | 6.2 ± 0.6 s | +0.2% [-55.4%, +55.8%] | UNKNOWN |
| vmm | lfds/dglm.c | 2 | 13.1 ± 0.4 s | 15.7 ± 0.3 s | **-20.5% [-30.0%, -10.9%]** | UNKNOWN |
| vmm | lfds/ms.c | 2 | 32.7 ± 0.7 s | 35.7 ± 1.0 s | -9.3% [-19.6%, +1.0%] | UNKNOWN |
| vmm | lfds/treiber.c | 3 | 10.1 ± 0.3 s | 12.3 ± 0.6 s | -22.1% [-66.4%, +22.1%] | UNKNOWN |
| vmm | lfds/safe_stack.c | 1 | 10.7 ± 0.4 s | 12.2 ± 0.8 s | -14.9% [-79.3%, +49.5%] | UNKNOWN |
| vmm | challenging/cna.c | 1 | 12.8 ± 0.5 s | 13.5 ± 0.5 s | -5.5% [-43.4%, +32.3%] | UNKNOWN |
| **vmm** | **total** | | **89.5 ± 1.4 s** | **99.2 ± 1.8 s** | **-10.8% [-20.0%, -1.6%]** | |
| power | locks/linuxrwlock.c | 2 | 11.3 ± 0.3 s | 14.2 ± 1.0 s | -26.1% [-93.2%, +41.0%] | UNKNOWN |
| power | locks/mutex_musl.c | 4 | 5.6 ± 0.1 s | 5.4 ± 0.0 s | +4.0% [-3.8%, +11.8%] | UNKNOWN |
| power | lfds/dglm.c | 1 | 4.2 ± 0.0 s | 3.2 ± 0.1 s | **+22.2% [+5.1%, +39.3%]** | UNKNOWN |
| power | lfds/ms.c | 2 | 14.9 ± 1.2 s | 14.6 ± 1.0 s | +1.7% [-54.8%, +58.2%] | UNKNOWN |
| power | lfds/treiber.c | 4 | 14.0 ± 0.2 s | 14.3 ± 0.5 s | -1.7% [-22.3%, +18.9%] | UNKNOWN |
| **power** | **total** | | **50.0 ± 1.4 s** | **51.7 ± 0.0 s** | -3.5% [-20.7%, +13.8%] | |
| aarch64 | locks/linuxrwlock.c | 2 | 9.3 ± 0.2 s | 9.4 ± 0.1 s | -1.0% [-7.8%, +5.7%] | UNKNOWN |
| aarch64 | locks/mutex_musl.c | 5 | 5.9 ± 0.1 s | 5.9 ± 0.1 s | -0.3% [-5.1%, +4.5%] | UNKNOWN |
| aarch64 | lfds/dglm.c | 3 | 7.8 ± 0.1 s | 7.9 ± 0.4 s | -1.4% [-35.8%, +33.1%] | PASS |
| aarch64 | lfds/ms.c | 2 | 10.3 ± 0.9 s | 11.0 ± 0.8 s | -7.3% [-20.8%, +6.2%] | UNKNOWN |
| aarch64 | challenging/cna.c | 2 | 22.3 ± 0.5 s | 20.6 ± 1.0 s | +7.6% [-25.7%, +40.8%] | UNKNOWN |
| aarch64 | challenging/wsq.c | 1 | 20.1 ± 2.5 s | 20.1 ± 2.9 s | +0.3% [-9.6%, +10.1%] | UNKNOWN |
| **aarch64** | **total** | | **75.7 ± 3.3 s** | **74.9 ± 4.6 s** | +1.1% [-13.6%, +15.7%] | |
| | **All 18** | | **215.2 ± 5.7 s** | **225.8 ± 3.9 s** | -4.9% [-11.2%, +1.3%] | |

Bold values are significant (the interval excludes zero).

- All 18 configurations give the same result with and without the change.
- vmm: slower in total (10.8%, significant). `lfds/dglm.c` is 20.5% slower, and `lfds/ms.c`, `lfds/treiber.c`
  and `lfds/safe_stack.c` are slower in every pair (by 1.2–3.0 s), but with only 3 runs their intervals include
  zero. Only `locks/cna.c` (under 5 s) is faster on average.
- power: unchanged in total. `lfds/dglm.c` is 22.2% faster (significant, but under 5 s), `locks/linuxrwlock.c`
  is slower in every pair (11.3 s vs 14.2 s on average).
- aarch64: unchanged. The 8% regression on `challenging/cna.c` measured before the rebase is gone (now 7.6%
  faster on average, not significant).
- Why the gain disappeared, compared with the results before the rebase (vmm 48% and power 47% faster): on
  `f5c2eb3cf`, a negatively used closure was encoded as a full equivalence with a cubic number of disjuncts.
  With #1154, `development` only encodes the "path implies edge" direction, as small implications, and #1159
  drops the steps implied by must-edges. `development` became 50% faster on vmm (180.2 s to 89.5 s) and 58% on
  power (118.8 s to 50.0 s), so there is little left for the propagator to save, while its own cost (Z3
  calling back into Java on every assignment, decision and backtrack) remains. This is a likely explanation,
  not a measured one: the Z3 statistics of both versions were not compared after the rebase.

<details>
<summary>Individual runs (seconds, development / this branch)</summary>

| Model | Benchmark | development | this branch |
|---|---|---|---|
| vmm | locks/cna.c | 4.4, 3.9, 3.8 | 3.6, 3.7, 3.3 |
| aarch64 | locks/linuxrwlock.c | 9.5, 9.3, 9.1 | 9.5, 9.3, 9.3 |
| power | locks/linuxrwlock.c | 11.0, 11.4, 11.4 | 15.3, 13.7, 13.6 |
| aarch64 | locks/mutex_musl.c | 5.9, 5.8, 6.0 | 5.9, 5.9, 5.9 |
| power | locks/mutex_musl.c | 5.6, 5.7, 5.7 | 5.4, 5.4, 5.4 |
| vmm | locks/mutex_musl.c | 6.1, 6.2, 6.3 | 5.9, 6.9, 5.8 |
| aarch64 | lfds/dglm.c | 7.9, 7.9, 7.7 | 8.2, 7.5, 8.1 |
| power | lfds/dglm.c | 4.1, 4.2, 4.1 | 3.4, 3.3, 3.1 |
| vmm | lfds/dglm.c | 12.8, 12.9, 13.5 | 15.6, 15.6, 16.0 |
| aarch64 | lfds/ms.c | 9.6, 9.9, 11.3 | 10.4, 10.8, 11.9 |
| power | lfds/ms.c | 14.2, 14.2, 16.3 | 13.6, 15.5, 14.6 |
| vmm | lfds/ms.c | 31.9, 33.0, 33.1 | 34.7, 36.7, 35.6 |
| power | lfds/treiber.c | 13.8, 14.1, 14.1 | 14.0, 13.9, 14.9 |
| vmm | lfds/treiber.c | 9.7, 10.4, 10.2 | 12.7, 12.6, 11.7 |
| vmm | lfds/safe_stack.c | 10.7, 11.0, 10.3 | 11.9, 11.6, 13.1 |
| aarch64 | challenging/cna.c | 21.7, 22.8, 22.5 | 20.9, 19.5, 21.5 |
| vmm | challenging/cna.c | 12.3, 12.7, 13.2 | 13.4, 14.0, 13.0 |
| aarch64 | challenging/wsq.c | 19.0, 18.3, 22.9 | 18.8, 18.0, 23.3 |

</details>

<details>
<summary>Results before the rebase (base: <code>f5c2eb3cf</code>)</summary>

Same setup, base `development` at `f5c2eb3cf`, branch with its own `RelationPolarity`. Total time 391.0 s vs
254.2 s: 35.0% faster [+27.2%, +42.7%]; vmm 48.0% faster (180.2 s to 93.6 s), power 47.0% (118.8 s to
63.0 s), aarch64 6.0% slower (92.0 s to 97.6 s, not significant; `challenging/cna.c` significantly slower by
8.2%).

</details>

### Results with larger bounds

At the CI bounds, most configurations take only 3–35 s on the current `development`, so the solver work that
lazy closures could save is small. To check whether the picture changes for harder instances, each bound was
raised (on `development`, one run per bound, 3 configurations in parallel) until the result became PASS/FAIL,
or until the next bound would take more than about 2 minutes. 17 of 18 configurations now end in PASS/FAIL. The
exception is power `locks/linuxrwlock.c`, which stays UNKNOWN at bound 3 because bound 4 took more than 200 s.
Because the calibration ran 3 jobs in parallel, the chosen bounds turned out cheaper than expected
when run alone: most configurations take 10–60 s, and vmm `challenging/cna.c` takes 2.5 minutes.

Same setup as above (CI script, 3 runs each, `--jobs 1`), with `--timeout 400`; no run timed out and no
configuration was measured again.

| Model | Benchmark | Bound | development | this branch | Faster by (99% CI) | Result |
|---|---|---:|---:|---:|---:|---|
| vmm | locks/cna.c | 2 | 3.2 ± 0.1 s | 2.7 ± 0.0 s | **+13.4% [+1.7%, +25.1%]** | PASS |
| vmm | locks/mutex_musl.c | 6 | 35.0 ± 2.6 s | 30.5 ± 4.5 s | +13.0% [-24.2%, +50.3%] | PASS |
| vmm | lfds/dglm.c | 3 | 21.1 ± 0.3 s | 28.3 ± 1.7 s | -34.1% [-83.9%, +15.7%] | PASS |
| vmm | lfds/ms.c | 3 | 44.8 ± 0.5 s | 51.9 ± 7.0 s | -15.9% [-110.4%, +78.5%] | PASS |
| vmm | lfds/treiber.c | 5 | 17.8 ± 0.4 s | 19.2 ± 0.4 s | **-7.8% [-12.9%, -2.7%]** | PASS |
| vmm | lfds/safe_stack.c | 2 | 59.6 ± 1.6 s | 87.7 ± 25.4 s | -47.8% [-317.5%, +221.8%] | FAIL |
| vmm | challenging/cna.c | 3 | 153.0 ± 2.6 s | 160.0 ± 0.0 s | -4.6% [-15.0%, +5.9%] | PASS |
| **vmm** | **total** | | **334.5 ± 4.6 s** | **380.3 ± 20.9 s** | -13.7% [-51.4%, +24.0%] | |
| power | locks/linuxrwlock.c | 3 | 31.3 ± 0.7 s | 40.9 ± 1.0 s | **-30.8% [-51.4%, -10.2%]** | UNKNOWN |
| power | locks/mutex_musl.c | 6 | 14.2 ± 1.4 s | 12.6 ± 1.2 s | +10.0% [-72.6%, +92.7%] | PASS |
| power | lfds/dglm.c | 3 | 49.2 ± 1.4 s | 27.2 ± 1.0 s | **+44.6% [+24.2%, +65.1%]** | PASS |
| power | lfds/ms.c | 3 | 31.5 ± 0.2 s | 35.6 ± 3.6 s | -13.2% [-73.1%, +46.8%] | PASS |
| power | lfds/treiber.c | 5 | 12.0 ± 0.1 s | 12.7 ± 0.3 s | -5.6% [-14.7%, +3.4%] | PASS |
| **power** | **total** | | **138.2 ± 0.5 s** | **129.1 ± 2.5 s** | +6.6% [-3.2%, +16.3%] | |
| aarch64 | locks/linuxrwlock.c | 4 | 52.8 ± 0.9 s | 52.3 ± 1.0 s | +0.9% [-5.9%, +7.7%] | PASS |
| aarch64 | locks/mutex_musl.c | 6 | 7.4 ± 0.3 s | 7.3 ± 0.0 s | +1.8% [-15.8%, +19.3%] | PASS |
| aarch64 | lfds/dglm.c | 3 | 8.6 ± 0.3 s | 8.8 ± 0.4 s | -2.8% [-41.6%, +36.0%] | PASS |
| aarch64 | lfds/ms.c | 3 | 25.8 ± 0.2 s | 26.4 ± 1.2 s | -2.2% [-32.6%, +28.3%] | PASS |
| aarch64 | challenging/cna.c | 3 | 58.0 ± 0.4 s | 61.0 ± 2.6 s | -5.1% [-32.3%, +22.0%] | PASS |
| aarch64 | challenging/wsq.c | 5 | 28.6 ± 2.7 s | 28.0 ± 1.8 s | +1.6% [-38.1%, +41.2%] | PASS |
| **aarch64** | **total** | | **181.3 ± 3.4 s** | **183.9 ± 5.9 s** | -1.4% [-17.3%, +14.5%] | |
| | **All 18** | | **653.9 ± 5.3 s** | **693.2 ± 16.3 s** | -6.0% [-24.4%, +12.3%] | |

Bold values are significant (the interval excludes zero).

- All 18 configurations give the same result with and without the change.
- vmm: 13.7% slower in total (not significant). Only `locks/cna.c` (13.4%, under 5 s) is significantly faster,
  `lfds/treiber.c` is significantly slower (7.8%). `lfds/dglm.c` (21 s vs 28 s), `lfds/ms.c` and
  `lfds/safe_stack.c` are slower in every pair, `challenging/cna.c` (the largest instance, 2.5 minutes) is
  4.6% slower. `locks/mutex_musl.c` is faster in every pair (13% on average).
- power: 6.6% faster in total (not significant). `lfds/dglm.c` is 44.6% faster (49 s vs 27 s), while
  `locks/linuxrwlock.c` is 30.8% slower (31 s vs 41 s).
- aarch64: unchanged, as expected (only `__iddTrans` is lazy).
- Larger instances therefore do not change the conclusion: on the current `development`, lazy closures win on
  some configurations and lose on others, with no overall gain.

<details>
<summary>Individual runs (seconds, development / this branch)</summary>

| Model | Benchmark | Bound | development | this branch |
|---|---|---:|---|---|
| vmm | locks/cna.c | 2 | 3.2, 3.2, 3.1 | 2.7, 2.7, 2.7 |
| aarch64 | locks/linuxrwlock.c | 4 | 51.8, 53.1, 53.6 | 51.3, 53.2, 52.4 |
| power | locks/linuxrwlock.c | 3 | 30.7, 31.0, 32.1 | 39.9, 41.8, 41.0 |
| aarch64 | locks/mutex_musl.c | 6 | 7.8, 7.2, 7.3 | 7.4, 7.3, 7.3 |
| power | locks/mutex_musl.c | 6 | 12.6, 15.1, 14.8 | 13.0, 11.3, 13.6 |
| vmm | locks/mutex_musl.c | 6 | 34.4, 32.7, 37.8 | 28.3, 27.6, 35.7 |
| aarch64 | lfds/dglm.c | 3 | 8.8, 8.7, 8.2 | 9.0, 8.4, 9.0 |
| power | lfds/dglm.c | 3 | 50.8, 48.7, 48.2 | 26.0, 27.8, 27.8 |
| vmm | lfds/dglm.c | 3 | 21.2, 21.3, 20.8 | 29.7, 26.4, 28.7 |
| aarch64 | lfds/ms.c | 3 | 26.0, 25.9, 25.6 | 25.7, 25.7, 27.7 |
| power | lfds/ms.c | 3 | 31.6, 31.7, 31.2 | 37.5, 37.8, 31.5 |
| vmm | lfds/ms.c | 3 | 44.6, 44.5, 45.4 | 47.5, 60.0, 48.3 |
| power | lfds/treiber.c | 5 | 11.9, 12.1, 12.1 | 12.3, 12.9, 12.8 |
| vmm | lfds/treiber.c | 5 | 18.0, 17.3, 18.0 | 19.2, 18.7, 19.6 |
| vmm | lfds/safe_stack.c | 2 | 57.9, 61.0, 60.0 | 117.0, 74.0, 72.0 |
| aarch64 | challenging/cna.c | 3 | 57.8, 58.5, 57.9 | 59.1, 60.0, 64.0 |
| vmm | challenging/cna.c | 3 | 155.0, 150.0, 154.0 | 160.0, 160.0, 160.0 |
| aarch64 | challenging/wsq.c | 5 | 25.5, 30.6, 29.7 | 26.4, 27.7, 30.0 |

</details>

<details>
<summary>Benchmark file with the larger bounds</summary>

Put it under `.github/` of a checkout (the script resolves program paths relative to the parent of the file's
directory) and pass it to `--benchmarks`.

```yaml
# CI performance configurations with bounds raised until development returns PASS/FAIL
# (or, for power linuxrwlock, until the next bound exceeds 200 s).
benchmarks:
  - program: benchmarks/locks/cna.c
    runs: 3
    configurations:
      - {cat: cat/vmm.cat, target: c11, options: ["--bound=2"]}
  - program: benchmarks/locks/linuxrwlock.c
    runs: 3
    configurations:
      - {cat: cat/aarch64.cat, target: arm8, options: ["--bound=4"]}
      - {cat: cat/power.cat, target: power, options: ["--bound=3"]}
  - program: benchmarks/locks/mutex_musl.c
    runs: 3
    configurations:
      - {cat: cat/aarch64.cat, target: arm8, options: ["--bound=6"]}
      - {cat: cat/power.cat, target: power, options: ["--bound=6"]}
      - {cat: cat/vmm.cat, target: c11, options: ["--bound=6"]}
  - program: benchmarks/lfds/dglm.c
    runs: 3
    options: ["--bound=3"]
    configurations:
      - {cat: cat/aarch64.cat, target: arm8}
      - {cat: cat/power.cat, target: power}
      - {cat: cat/vmm.cat, target: c11}
  - program: benchmarks/lfds/ms.c
    runs: 3
    options: ["--bound=3"]
    configurations:
      - {cat: cat/aarch64.cat, target: arm8}
      - {cat: cat/power.cat, target: power}
      - {cat: cat/vmm.cat, target: c11}
  - program: benchmarks/lfds/treiber.c
    runs: 3
    options: ["--bound=5"]
    configurations:
      - {cat: cat/power.cat, target: power}
      - {cat: cat/vmm.cat, target: c11}
  - program: benchmarks/lfds/safe_stack.c
    runs: 3
    configurations:
      - {cat: cat/vmm.cat, target: c11, options: ["--bound=2"]}
  - program: benchmarks/challenging/cna.c
    runs: 3
    options: ["--bound=3"]
    configurations:
      - {cat: cat/aarch64.cat, target: arm8}
      - {cat: cat/vmm.cat, target: c11}
  - program: benchmarks/challenging/wsq.c
    runs: 3
    configurations:
      - {cat: cat/aarch64.cat, target: arm8, options: ["--bound=5"]}
```

</details>

### How to reproduce

```sh
# In a checkout of this branch. Inside a git worktree, add -Dmaven.gitcommitid.skip=true to the mvn commands.
git worktree add --detach ../dat3m-base development
(cd ../dat3m-base && mvn -DskipTests package)
mvn -DskipTests package

# compare_performance.py runs dartagnan/target/dartagnan (the native executable); a launcher runs the jar instead
for d in . ../dat3m-base; do
  printf '#!/bin/sh\nhere=$(cd "$(dirname "$0")" && pwd)\nexec java -Djava.library.path="$here/libs" -jar "$here/dartagnan.jar" "$@"\n' \
    > "$d/dartagnan/target/dartagnan"
  chmod +x "$d/dartagnan/target/dartagnan"
done

python3 -m venv /tmp/perf-venv && /tmp/perf-venv/bin/pip install PyYAML
/tmp/perf-venv/bin/python scripts/compare_performance.py \
  --benchmarks .github/performance-benchmarks.yml \
  --base-checkout "$(cd ../dat3m-base && pwd)" --head-checkout "$PWD" \
  --timeout 180 --jobs 1 --min-average-seconds 5 \
  --markdown /tmp/perf/report.md --json /tmp/perf/results.json
```

## TODOs and possible improvements

1. **Decide whether lazy closures stay (and on by default).** After the rebase, they are 4.9% slower on the
   CI benchmarks overall (10.8% slower on vmm), and 6.0% slower with larger bounds. Options: turn
   `encoding.wmm.lazyClosures` off by default and keep the code for further experiments, or drop the branch.
   Before deciding, comparing Z3's statistics (conflicts, propagations, time spent in callbacks) would show
   whether the propagator's overhead or a different search is responsible. Good candidates are the clear
   cases in both directions: power `lfds/dglm.c` (45% faster at bound 3) against power `locks/linuxrwlock.c`
   (31% slower) and vmm `lfds/dglm.c` (34% slower at bound 3).
2. **Measure the other affected models.** The CI performance set only covers vmm, power and aarch64. Closures
   also become lazy for rc11, imm, arm, riscv, linux-kernel, ptx, vulkan (19 closures) and svcomp (`hb-race`,
   which matters for SV-COMP data race tasks). Correctness is covered by the regression run above (before the
   rebase), performance is not. Adding some of these configurations to `.github/performance-benchmarks.yml` would cover them.
3. **Native image.** The JNI configuration for the propagator callbacks was written by hand and has not been
   built locally. The CI native job will check it on all platforms. The numbers above are for the JVM; the
   CI job will report native numbers.
4. **Reported flags can be incomplete.** For a FAIL, the violated properties and flags are read from the
   solver's model (`IREvaluator.propertyViolated` and `isFlaggedAxiomViolated`). With lazy closures, a closure
   edge can be true in that model without a path. When the execution found raises several CAT flags, some of
   them may therefore be missing from the report. Every reported flag is raised for real, and the verdict is
   unaffected. Evaluating the flags on the `ExecutionModel`, which rebuilds closures from their operands, would
   make the report exact. Since #1154, `development` has the same limitation for every relation encoded in one
   direction only, so this is no longer specific to lazy closures.
5. **Positively used closures stay eager.** Closures that are also used positively (e.g. under `~empty`, or in
   an assumption) keep the eager encoding. The propagator could also enforce "edge implies path" lazily (e.g.
   in the final check), which would make every closure lazy.
6. **Closures with more than 2048 events stay eager.** A sparse reachability representation would lift this
   limit.
7. **One-sided encoding without a propagator.** Done in `development` by #1154 (polarity-aware encoding),
   which is why this branch no longer pays off.
8. **Small closures.** Before the rebase, aarch64 `challenging/cna.c` was 8% slower because a propagator was
   registered for a tiny closure (`__iddTrans`, 12 events and 8 steps). This regression is no longer
   measurable, but a minimum size for lazy closures would still avoid the fixed cost of a propagator where
   there is nothing to gain.
