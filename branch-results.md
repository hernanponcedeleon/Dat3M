# Lazy transitive closures for the eager encoding

Branch `agentic/lazy-closures`, based on `development` (`f5c2eb3cf`). This file documents what the branch
does, how it was tested, the performance results, and what is still open.

## Summary

In the eager method (`AssumeSolver`), transitive closures that the memory model only uses negatively are no
longer encoded with the cubic eager definition. Instead, a Z3 user propagator (`ClosurePropagator`) enforces
them during the search: as soon as the current assignment contains a path, the corresponding closure edge is
propagated, with the literals of the path as the reason.

- Which closures qualify is computed from the `.cat` model (`RelationPolarity`). Nothing has to be configured.
- On the 18 configurations of the CI performance job (3 runs each, CI script), total time goes from 391.0 s to
  254.2 s: **35% faster (99% confidence interval 27–43%)**. vmm is 48% faster and power 47%. aarch64 is unchanged
  overall, but one configuration is 8% slower (see [TODOs](#todos-and-possible-improvements)).
- The option `encoding.wmm.lazyClosures` is on by default (`--encoding.wmm.lazyClosures=false` disables it).
  It only has an effect with the eager method and Z3.

## Motivation

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
disjunction over all intermediate events, which is cubic. These closures are only used negatively (under
`acyclic`, `irreflexive` and `empty` axioms, or as what the race flags subtract), so the solver never needs
"closure edge implies path", only "path implies closure edge". That direction can be enforced on demand by a
propagator instead of being encoded upfront.

## What the branch changes

### Which closures become lazy: `RelationPolarity`

A fixpoint over the constraints of the memory model computes in which direction each relation is used:

- Axioms (`acyclic`, `irreflexive`, `empty`) use their relation negatively, negated axioms (`~empty`, ...)
  positively. Flagged axioms are treated the same way, because a flag is raised when its axiom holds.
- Other constraints (e.g. assumptions) use their relations in both directions.
- Monotone operators (union, intersection, composition, inverse, closure, projection, set identity, Cartesian
  product) pass the polarity on to their operands. A difference passes it on to the minuend and flips it for
  the subtrahend. Any other definition makes its operands used in both directions.

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

- Must-edges of the closure keep their definition in the formula: such an edge holds iff both events execute.
- The remaining edges of the closure's active set (the *lazy edges*) get no definition in the formula. The
  propagator forces them to true when a path exists.
- The propagator builds paths from the same steps as the eager encoding (`WmmEncoder.visitTransitiveClosure`):
  edges of the operand in its active set, must-edges of the operand or of the closure (which hold iff both
  events execute), and closure must-edges that end in the target of a lazy edge. It therefore forces at least
  every closure edge that the eager encoding would force. The comments in `ClosurePropagator` give the details.

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
- Lazy closures are also off when symmetry breaking is enabled: its constraints are not seen by the polarity
  analysis.
- Execution models and witness graphs are not affected: `ExecutionModelManager` rebuilds closures from their
  operands instead of reading the closure literals. The list of violated flags is (see TODO 4).

### Files

| File | Change |
|---|---|
| `encoding/RelationPolarity.java` | new: polarity analysis |
| `encoding/ClosurePropagator.java` | new: the user propagator |
| `encoding/WmmEncoder.java` | option, lazy path in `visitTransitiveClosure`, `getLazyClosures()` |
| `task/verification/AssumeSolver.java` | registers the propagator, logs its statistics |
| `task/SMTModelChecker.java` | `canUseUserPropagators()` |
| `encoding/SymmetryEncoder.java` | `isEnabled()` |
| `configuration/OptionNames.java` | `LAZY_CLOSURES` |
| `META-INF/native-image/.../jni-config.json` | the 8 callbacks of the Z3 propagator, for the native image |
| `.github/scripts/check-native-and-solvers.py` | native check that runs a configuration with lazy closures |
| `.github/workflows/maven.yml` | new "Encoding tests" step (no CI step ran `com/dat3m/dartagnan/encoding/**` before) |
| `RelationPolarityTest`, `LazyClosuresTest` | new tests |
| `benchmarks/miscellaneous/dataRaceWrites.c`, `dataRaceFreeChain.c` (+ `.ll`) | new programs for the vmm race flags |

## Testing

- `RelationPolarityTest` (5 tests): the polarity rules and the closures of the shipped vmm and power models.
- `LazyClosuresTest` (9 configurations, eager method): power, rc11 and imm consistency (PASS, FAIL and UNKNOWN),
  and the vmm data race flags: a racy program (FAIL), a race-free one (PASS) and `lfds/ms` (UNKNOWN).
- Regression run with the option forced on (before it became the default), with the same propagator on the
  previous `development` commit (`f6af468b6`): all litmus suites (including the exploration tests) and all LLVM
  suites, with both methods. 86,440 tests, 0 failures, 7,935 skipped, 28 errors, all of them
  "The SMT solver YICES2 is not available on this machine". The only change since then: closures without lazy
  edges keep their eager encoding.
- On this branch's code: the CI code-style check (`mvn -Pstyle-check clean test-compile`) passes, and
  `RelationPolarityTest`, `LazyClosuresTest`, `LitmusPPCTest` and `CLocksTest` pass (4,973 tests).
- Not run locally: the native image. The CI native job builds it on all platforms and runs the new lazy
  closures check.

## Performance

### Setup

- The CI's own `scripts/compare_performance.py` with `.github/performance-benchmarks.yml`: 18 configurations,
  3 runs each, `--jobs 1`, `--timeout 180`. The script alternates which version runs first in each pair.
- Base: `development` (`f5c2eb3cf`). PR: this branch.
- Differences from the CI: the jar ran on the JVM (Oracle GraalVM 25.0.4, Z3 4.14.0) instead of a native
  image, using a small launcher at `dartagnan/target/dartagnan`. The machine (macOS, 18 CPUs) was shared with
  other jobs (load average 7–13), which explains the outlier runs below.
- Times are Dartagnan's `Time:` values, mean ± standard deviation over the 3 runs. "Faster by" is the mean of
  the paired relative improvements with its 99% confidence interval, as computed by the CI script.

### Results

| Model | Benchmark | Bound | development | this branch | Faster by (99% CI) | Result |
|---|---|---:|---:|---:|---:|---|
| vmm | locks/cna.c | 1 | 12.4 ± 1.8 s | 7.1 ± 4.4 s | 44.7% [−106.0%, +195.5%] | UNKNOWN |
| vmm | locks/mutex_musl.c | 3 | 24.7 ± 1.6 s | 10.8 ± 0.5 s | **56.1% [+33.6%, +78.6%]** | UNKNOWN |
| vmm | lfds/dglm.c | 2 | 36.6 ± 1.7 s | 22.2 ± 1.5 s | **39.3% [+15.6%, +63.1%]** | UNKNOWN |
| vmm | lfds/ms.c | 2 | 40.8 ± 3.1 s | 22.1 ± 2.2 s | **45.9% [+34.3%, +57.5%]** | UNKNOWN |
| vmm | lfds/treiber.c | 3 | 15.9 ± 3.2 s | 8.7 ± 1.6 s | 44.0% [−27.2%, +115.1%] | UNKNOWN |
| vmm | lfds/safe_stack.c | 1 | 12.0 ± 0.4 s | 10.6 ± 0.2 s | **11.9% [+2.4%, +21.3%]** | UNKNOWN |
| vmm | challenging/cna.c | 1 | 37.8 ± 0.4 s | 12.1 ± 0.3 s | **67.9% [+61.5%, +74.4%]** | UNKNOWN |
| **vmm** | **total** | | **180.2 ± 5.6 s** | **93.6 ± 4.5 s** | **48.0% [+31.8%, +64.3%]** | |
| power | locks/linuxrwlock.c | 2 | 32.2 ± 1.4 s | 20.1 ± 1.6 s | **37.5% [+3.5%, +71.4%]** | UNKNOWN |
| power | locks/mutex_musl.c | 4 | 25.9 ± 1.2 s | 10.4 ± 0.5 s | **59.8% [+53.8%, +65.7%]** | UNKNOWN |
| power | lfds/dglm.c | 1 | 8.6 ± 0.4 s | 4.2 ± 0.5 s | **51.2% [+31.7%, +70.7%]** | UNKNOWN |
| power | lfds/ms.c | 2 | 34.9 ± 2.8 s | 17.9 ± 1.5 s | **48.5% [+31.3%, +65.6%]** | UNKNOWN |
| power | lfds/treiber.c | 4 | 17.2 ± 1.4 s | 10.3 ± 0.5 s | **39.9% [+16.0%, +63.8%]** | UNKNOWN |
| **power** | **total** | | **118.8 ± 2.4 s** | **63.0 ± 2.6 s** | **47.0% [+36.8%, +57.2%]** | |
| aarch64 | locks/linuxrwlock.c | 2 | 12.0 ± 1.2 s | 10.8 ± 1.5 s | 9.2% [−85.4%, +103.9%] | UNKNOWN |
| aarch64 | locks/mutex_musl.c | 5 | 11.5 ± 0.7 s | 11.3 ± 0.8 s | 1.4% [−70.8%, +73.6%] | UNKNOWN |
| aarch64 | lfds/dglm.c | 3 | 12.6 ± 4.1 s | 16.6 ± 8.7 s | −26.4% [−167.9%, +115.0%] | PASS |
| aarch64 | lfds/ms.c | 2 | 10.2 ± 1.5 s | 10.7 ± 1.5 s | −5.4% [−12.1%, +1.4%] | UNKNOWN |
| aarch64 | challenging/cna.c | 2 | 27.4 ± 1.0 s | 29.6 ± 1.1 s | **−8.2% [−9.9%, −6.5%]** | UNKNOWN |
| aarch64 | challenging/wsq.c | 1 | 18.3 ± 0.4 s | 18.5 ± 0.5 s | −1.3% [−9.8%, +7.2%] | UNKNOWN |
| **aarch64** | **total** | | **92.0 ± 7.2 s** | **97.6 ± 9.7 s** | **−6.0% [−27.3%, +15.4%]** | |
| | **All 18** | | **391.0 ± 3.2 s** | **254.2 ± 7.0 s** | **35.0% [+27.2%, +42.7%]** | |

Bold improvements are significant (the interval excludes zero).

- All 18 configurations give the same result with and without the change.
- power: all 5 configurations are significantly faster (37.5–59.8%).
- vmm: 5 of 7 are significantly faster (11.9–67.9%). `locks/cna.c` and `lfds/treiber.c` have similar averages, but
  one outlier run each widens the interval (e.g. `cna.c` on this branch: 4.6 s, 4.6 s and 12.1 s).
- aarch64: no change overall. Its only lazy closure is the internal `__iddTrans`, which is tiny (12 events and
  8 steps for `challenging/cna.c`, 15 events and 12 steps for `lfds/dglm.c`; `challenging/wsq.c` has none, so
  no propagator is registered). `challenging/cna.c` is 2.1–2.4 s slower in all three pairs; the `dglm.c` value
  comes from one 26.5 s run.
- An earlier single-run screening of the same implementation on the same configurations gave 354.4 s vs
  242.0 s (32% faster), with the same pattern per model.

<details>
<summary>Individual runs (seconds, development / this branch)</summary>

| Model | Benchmark | development | this branch |
|---|---|---|---|
| vmm | locks/cna.c | 10.6, 12.3, 14.2 | 4.6, 4.6, 12.1 |
| aarch64 | locks/linuxrwlock.c | 13.0, 10.8, 12.3 | 9.3, 10.8, 12.3 |
| power | locks/linuxrwlock.c | 33.8, 31.2, 31.6 | 19.6, 18.8, 21.9 |
| aarch64 | locks/mutex_musl.c | 11.5, 10.9, 12.3 | 10.9, 12.3, 10.8 |
| power | locks/mutex_musl.c | 26.9, 26.3, 24.6 | 10.6, 10.9, 9.9 |
| vmm | locks/mutex_musl.c | 23.1, 24.8, 26.3 | 10.7, 11.4, 10.4 |
| aarch64 | lfds/dglm.c | 17.4, 10.7, 9.8 | 26.5, 13.2, 10.2 |
| power | lfds/dglm.c | 9.1, 8.4, 8.3 | 4.7, 4.2, 3.8 |
| vmm | lfds/dglm.c | 34.8, 38.2, 36.8 | 21.1, 21.6, 23.8 |
| aarch64 | lfds/ms.c | 11.9, 9.2, 9.4 | 12.4, 9.9, 9.9 |
| power | lfds/ms.c | 34.6, 32.2, 37.8 | 16.7, 17.5, 19.6 |
| vmm | lfds/ms.c | 43.7, 41.2, 37.6 | 23.6, 23.2, 19.6 |
| power | lfds/treiber.c | 15.6, 17.9, 18.1 | 10.0, 10.0, 10.9 |
| vmm | lfds/treiber.c | 12.3, 18.5, 16.8 | 7.8, 7.7, 10.6 |
| vmm | lfds/safe_stack.c | 12.4, 12.1, 11.5 | 10.8, 10.6, 10.4 |
| aarch64 | challenging/cna.c | 27.8, 28.1, 26.2 | 30.2, 30.3, 28.3 |
| vmm | challenging/cna.c | 37.4, 38.2, 37.6 | 12.5, 11.9, 12.0 |
| aarch64 | challenging/wsq.c | 18.8, 18.0, 18.1 | 19.0, 18.5, 18.1 |

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

1. **Keep tiny closures eager (fixes the aarch64 regression).** aarch64 `challenging/cna.c` is 8.2% slower
   (99% CI −9.9% to −6.5%). Its only lazy closure, `__iddTrans`, has 12 events and 8 steps (2,411
   propagations), so there is nothing to gain, but a registered propagator has a fixed cost: most likely Z3
   calling back into Java on every decision and backtrack. A minimum size (e.g. on the number of lazy edges or
   steps) would keep such closures eager, so that no propagator is registered on aarch64 and those runs are
   identical to `development`. The vmm and power closures are much larger (88–139 events and 675–13,764 steps
   in the runs we inspected). The cutoff should be chosen with mid-sized closures in mind, e.g. rc11 on
   `lfds/chase-lev`: `(rf ; myrmw)^+` with 5 events and 20 steps, `hb` with 42 and 141, `eco` with 27 and 254.
2. **Measure the other affected models.** The CI performance set only covers vmm, power and aarch64. Closures
   also become lazy for rc11, imm, arm, riscv, linux-kernel, ptx, vulkan (19 closures) and svcomp (`hb-race`,
   which matters for SV-COMP data race tasks). Correctness is covered by the regression run above, performance
   is not. Adding some of these configurations to `.github/performance-benchmarks.yml` would cover them.
3. **Native image.** The JNI configuration for the propagator callbacks was written by hand and has not been
   built locally. The CI native job will check it on all platforms. The numbers above are for the JVM; the
   CI job will report native numbers.
4. **Reported flags can be incomplete.** For a FAIL, the violated properties and flags are read from the
   solver's model (`IREvaluator.propertyViolated` and `isFlaggedAxiomViolated`). With lazy closures, a closure
   edge can be true in that model without a path. When the execution found raises several CAT flags, some of
   them may therefore be missing from the report. Every reported flag is raised for real, and the verdict is
   unaffected. Evaluating the flags on the `ExecutionModel`, which rebuilds closures from their operands, would
   make the report exact.
5. **Positively used closures stay eager.** Closures that are also used positively (e.g. under `~empty`, or in
   an assumption) keep the eager encoding. The propagator could also enforce "edge implies path" lazily (e.g.
   in the final check), which would make every closure lazy.
6. **Closures with more than 2048 events stay eager.** A sparse reachability representation would lift this
   limit.
7. **One-sided encoding without a propagator (idea, not measured).** The polarity analysis also allows encoding
   every negatively used relation with implications only ("definition implies edge"), not just closures. That
   would shrink the eager encoding with every solver, not only Z3.
8. **Default.** The option is on by default. Revisit after items 1 and 2.
