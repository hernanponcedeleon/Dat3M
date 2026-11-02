# Acyclicity axioms as a Z3 user propagator

Branch `agentic/axiom-propagator`. This file documents what the branch does, how it was tested, the performance
results, and what is still open.

## Summary

`--method=propagator` (`PropagatorSolver`) uses the eager encoding, except for the (unflagged, non-negated)
`acyclic` axioms of the memory model. Those are not encoded; a Z3 user propagator (`AcyclicityPropagator`) checks
them during the search instead. It detects cycles as soon as the current assignment contains one (conflict) and
propagates edges that would close a cycle to false (theory propagation).

- **After rebasing on `development` (Nov 2026), the propagator no longer pays off.** On 16 hard configurations
  (rc11, vmm, aarch64, seed 1), total CPU time is 602 s with `eager` and 665 s with `propagator`: **9% slower**.
  Only vmm still gains (6% faster); rc11 is 22% slower and aarch64 11% slower. On the 18 CI performance
  configurations it is at parity (3% faster). See [Results](#results).
- The main reason is that `eager` got much faster: 1.3–3× on vmm and rc11, most likely due to the polarity-based wmm
  encoding (#1154) and the optimized transitive closure encoding (#1159). Both reduce the cost of encoding the axioms
  that the propagator replaces.
- The experimental path shape propagator (which also handles `irreflexive` axioms) is the slowest of the three:
  **33% slower** than `eager` on the hard configurations (2.2× slower on rc11) and 13% slower on the CI ones.
- The two propagators lose for different reasons ([Where the time goes](#where-the-time-goes)): the plain propagator
  needs **22% more conflicts** than `eager` but each is slightly cheaper (a search problem: its reasons are weaker),
  while the path shape propagator needs about as many conflicts but each costs **1.6×** more (an overhead problem).
- Before the rebase, the propagator was 5% faster than `eager` on the hard configurations (19% on vmm), averaged over
  3 seeds. Those results are kept [below](#results-before-the-rebase).
- Every configuration gives the same verdict with all methods.
- All litmus suites pass with the propagator (AArch64, Linux, PPC, RISC-V, RC11, C11). They were last run before the
  rebase.

## What the branch changes

### Soundness for general memory models

The original propagator treated must-edges of the axiom's relation as always present. That is only sound if
`must(r) ; must(r)` is contained in `must(r^+)`, e.g. for `po` under SC. In general, a must-edge `(x, y)` only
exists if both `x` and `y` execute, so a cycle through a must-edge could go through an event that does not execute.
Must-edges are now enabled only once the execution literals of their endpoints are true, and those literals are part
of every conflict and propagation reason that uses the edge. A must-edge can be "propagated to false" by propagating
the negation of its single unassigned execution literal.

### Registering the propagator after the encoding

Registering a user propagator makes Z3 configure its SMT core immediately, based on the formulas asserted so far.
With no formulas, it falls back to a generic configuration (e.g. with relevancy propagation enabled), which made
every search step 2–3× slower. The propagator is now registered after the encoding has been added.

### Lower propagator overhead

The propagator runs a forward search from the target of each new edge (cycle detection) and a backward search from
its source (theory propagation). Both now avoid per-check costs that do not depend on the size of the search:

- Visited nodes are marked with a fresh stamp instead of clearing two arrays of the size of the event graph per check.
- The searches use an `int[]` queue instead of an `ArrayDeque<Integer>`.
- `VarGraph` keeps the true in- and out-edges of each event as stacks (undone in reverse order on backtracking), so
  the forward search no longer filters all out-edges by their value.
- Propagated edges are tracked with a flag array per axiom instead of an identity hash set.

On rc11, where the search is identical before and after this change (same number of conflicts), it saves up to 19%
of the total time (`locks/linuxrwlock` 3), and 8% over all 16 hard configurations (seed 1).

### Path shape propagator (experimental, off by default)

`PathShapePropagator` generalizes the propagator to `acyclic(r)` and `irreflexive(r)` axioms whose relation `r` is a
regular combination (union, composition, closure) of simpler relations. It works on the product of the graph of the
atomic relations with an automaton for `r` (`PathAutomaton`), so composite relations do not need to be encoded.
For `acyclic` axioms whose automaton allows it, it uses plain cycle detection on the product graph, with an
incrementally maintained topological order (Pearce–Kelly).

It is enabled with `--solver.propagator.legacyAcyclicity=false` (options `solver.propagator.maxAutomatonStates`,
default 4, and `solver.propagator.irreflexivity`, default true). It passes all litmus suites, but it is slower than
`eager`: 15% on the hard configurations before the rebase, and 33% after it (see [Results](#results)). It needs
about as many conflicts as `eager`, but each one costs 1.6× more on average (see
[Where the time goes](#where-the-time-goes)). Its main
motivation, not having to encode composite relations such as rc11's `hb ; eco`, has likely largely gone since #1154
and #1159 made the eager encoding much cheaper. It is kept on the branch for further experiments.

## Results

Measured on 2026-11-09, after rebasing the branch on `development` (`c279ca9b0`).

Setup:

- `--method=eager`, `--method=propagator`, and `--method=propagator --solver.propagator.legacyAcyclicity=false`
  (*path shape*), Z3 4.14.0 (JavaSMT 5.0.1), timeout 300 s.
- A single seed (`--solver.randomSeed=1`). Per-configuration speedups vary by up to ±0.3 between seeds (see
  [Observations before the rebase](#observations-before-the-rebase)), so single rows are noisy; totals and
  per-model trends are more reliable.
- Time is the CPU time of the whole `dartagnan` process (user + system). Four runs were executed in parallel, which
  inflates CPU times by about 20% compared to sequential runs (see [Where the time goes](#where-the-time-goes)); the
  ratios between methods are comparable, absolute times are not.
- *Speedup* is `eager` time / time of the method (> 1: faster than `eager`).

### Hard configurations

| Model | Program | Bound | Result | Eager (s) | Propagator (s) | Path shape (s) | Propagator speedup | Path shape speedup |
|---|---|---:|---|---:|---:|---:|---:|---:|
| vmm | `lfds/ms` | 3 | PASS | 75.6 | 62.1 | 82.7 | **1.22** | 0.91 |
| rc11 | `lfds/ms` | 3 | PASS | 45.1 | 44.8 | 85.7 | 1.01 | 0.53 |
| vmm | `lfds/dglm` | 4 | PASS | 56.8 | 60.5 | 64.4 | 0.94 | 0.88 |
| vmm | `lfds/treiber` | 4 | UNKNOWN | 23.2 | 21.7 | 23.5 | 1.07 | 0.99 |
| rc11 | `locks/linuxrwlock` | 2 | UNKNOWN | 20.7 | 23.4 | 41.6 | 0.89 | 0.50 |
| rc11 | `lfds/dglm` | 3 | PASS | 21.1 | 26.4 | 31.9 | 0.80 | 0.66 |
| rc11 | `lfds/dglm` | 4 | PASS | 27.4 | 42.0 | 39.2 | 0.65 | 0.70 |
| vmm | `lfds/dglm` | 3 | PASS | 41.0 | 39.5 | 46.7 | 1.04 | 0.88 |
| rc11 | `lfds/treiber` | 4 | UNKNOWN | 14.8 | 16.0 | 21.2 | 0.93 | 0.70 |
| rc11 | `locks/linuxrwlock` | 3 | UNKNOWN | 58.6 | 89.1 | 199.5 | 0.66 | 0.29 |
| vmm | `locks/linuxrwlock` | 3 | FAIL | 19.2 | 18.2 | 19.4 | 1.05 | 0.99 |
| vmm | `locks/mutex_musl` | 3 | UNKNOWN | 16.5 | 16.7 | 18.3 | 0.99 | 0.90 |
| aarch64 | `lfds/ms` | 3 | PASS | 48.3 | 48.2 | 42.7 | 1.00 | **1.13** |
| aarch64 | `locks/linuxrwlock` | 3 | UNKNOWN | 55.3 | 65.2 | 78.1 | 0.85 | 0.71 |
| aarch64 | `lfds/dglm` | 4 | PASS | 22.4 | 25.1 | 29.7 | 0.89 | 0.76 |
| aarch64 | `lfds/ms` | 4 | PASS | 55.6 | 65.9 | 71.4 | 0.84 | 0.78 |
| **Total** | | | | **601.8** | **664.8** | **896.0** | **0.91** | **0.67** |

Per model:

| Model | Configurations | Eager (s) | Propagator (s) | Path shape (s) | Propagator speedup | Path shape speedup |
|---|---:|---:|---:|---:|---:|---:|
| vmm | 6 | 232.4 | 218.8 | 255.1 | 1.06 | 0.91 |
| rc11 | 6 | 187.8 | 241.6 | 419.1 | 0.78 | 0.45 |
| aarch64 | 4 | 181.6 | 204.4 | 221.9 | 0.89 | 0.82 |

### CI performance configurations

| Model | Program | Bound | Eager (s) | Propagator (s) | Path shape (s) | Propagator speedup | Path shape speedup |
|---|---|---:|---:|---:|---:|---:|---:|
| vmm | `locks/cna` | 1 | 12.0 | 11.9 | 12.4 | 1.01 | 0.97 |
| vmm | `locks/mutex_musl` | 3 | 16.2 | 16.9 | 16.2 | 0.96 | 1.00 |
| vmm | `lfds/dglm` | 2 | 26.2 | 25.7 | 28.7 | 1.02 | 0.91 |
| vmm | `lfds/ms` | 2 | 32.8 | 28.3 | 34.9 | **1.16** | 0.94 |
| vmm | `lfds/treiber` | 3 | 13.4 | 15.0 | 15.7 | 0.90 | 0.86 |
| vmm | `lfds/safe_stack` | 1 | 13.5 | 16.4 | 15.0 | 0.82 | 0.90 |
| vmm | `challenging/cna` | 1 | 20.9 | 19.4 | 19.0 | 1.08 | 1.10 |
| power | `locks/linuxrwlock` | 2 | 23.9 | 26.4 | 31.0 | 0.90 | 0.77 |
| power | `locks/mutex_musl` | 4 | 16.6 | 16.0 | 19.1 | 1.03 | 0.87 |
| power | `lfds/dglm` | 1 | 13.4 | 14.7 | 14.4 | 0.91 | 0.93 |
| power | `lfds/ms` | 2 | 27.0 | 28.4 | 32.9 | 0.95 | 0.82 |
| power | `lfds/treiber` | 4 | 19.4 | 19.2 | 21.9 | 1.01 | 0.89 |
| aarch64 | `locks/linuxrwlock` | 2 | 25.8 | 24.8 | 26.6 | 1.04 | 0.97 |
| aarch64 | `locks/mutex_musl` | 5 | 18.8 | 15.3 | 19.2 | **1.23** | 0.98 |
| aarch64 | `lfds/dglm` | 3 | 20.4 | 20.5 | 21.7 | 0.99 | 0.94 |
| aarch64 | `lfds/ms` | 2 | 19.8 | 20.8 | 22.9 | 0.95 | 0.86 |
| aarch64 | `challenging/cna` | 2 | 30.1 | 25.4 | 39.0 | **1.19** | 0.77 |
| aarch64 | `challenging/wsq` | 1 | 28.6 | 24.2 | 43.8 | **1.19** | 0.65 |
| **Total** | | | **378.7** | **369.4** | **434.6** | **1.03** | **0.87** |

Per model:

| Model | Configurations | Eager (s) | Propagator (s) | Path shape (s) | Propagator speedup | Path shape speedup |
|---|---:|---:|---:|---:|---:|---:|
| vmm | 7 | 135.0 | 133.6 | 142.0 | 1.01 | 0.95 |
| power | 5 | 100.3 | 104.7 | 119.3 | 0.96 | 0.84 |
| aarch64 | 6 | 143.5 | 131.1 | 173.3 | 1.09 | 0.83 |

### Observations

- Compared to the [results before the rebase](#results-before-the-rebase), `eager` is 1.3–3× faster on vmm and rc11
  (e.g. rc11 `lfds/ms` 3: 144 s → 45 s, vmm `lfds/ms` 3: 188 s → 76 s). The propagator also got faster, but less.
  The likely causes are the polarity-based wmm encoding (#1154) and the optimized transitive closure encoding (#1159).
- vmm is the only model where the propagator still helps (1.06×; `lfds/ms` 3: 1.22×).
- rc11 flipped from 1.06× to 0.78×; it is slower on all 6 configurations, so this is unlikely to be seed noise.
- On aarch64, `eager` looks *slower* than before the rebase (hard configurations: 124.5 s → 181.6 s), but this is
  mostly contention from the parallel runs: run sequentially, aarch64 `lfds/ms` 4 takes 46.4 s (44.3 s before the
  rebase) and `locks/linuxrwlock` 3 42.7 s (36.3 s), within single-seed noise (see
  [Where the time goes](#where-the-time-goes)).
- The path shape propagator is the slowest method on 14 of the 16 hard configurations; rc11 `locks/linuxrwlock` 3
  takes 199.5 s vs. 58.6 s with `eager`.

### Where the time goes

To separate a worse search from propagator overhead, 7 hard configurations were rerun **sequentially** (one process
at a time, seed 1), collecting Z3's statistics (`conflicts` and `decisions`, printed by `logProverStatistics` when the
logger of `com.dat3m.dartagnan.task.verification` is at `DEBUG`). *Time vs. `eager`* and *Conflicts vs. `eager`* are
ratios to `eager` (> 1: more time or conflicts than `eager`).

| Model | Program | Bound | Method | CPU (s) | Conflicts | ms/conflict | Time vs. `eager` | Conflicts vs. `eager` |
|---|---|---:|---|---:|---:|---:|---:|---:|
| vmm | `lfds/ms` | 3 | eager | 59.2 | 41,661 | 1.42 | 1.00 | 1.00 |
| | | | propagator | 55.4 | 32,555 | 1.70 | 0.94 | 0.78 |
| | | | path shape | 75.5 | 36,918 | 2.05 | 1.27 | 0.89 |
| vmm | `lfds/dglm` | 4 | eager | 43.1 | 23,976 | 1.80 | 1.00 | 1.00 |
| | | | propagator | 43.2 | 25,964 | 1.66 | 1.00 | 1.08 |
| | | | path shape | 47.4 | 22,889 | 2.07 | 1.10 | 0.95 |
| rc11 | `lfds/ms` | 3 | eager | 36.6 | 39,538 | 0.93 | 1.00 | 1.00 |
| | | | propagator | 35.6 | 38,091 | 0.94 | 0.97 | 0.96 |
| | | | path shape | 62.8 | 41,444 | 1.52 | 1.72 | 1.05 |
| rc11 | `lfds/dglm` | 4 | eager | 22.8 | 17,676 | 1.29 | 1.00 | 1.00 |
| | | | propagator | 34.5 | 31,475 | 1.09 | 1.51 | 1.78 |
| | | | path shape | 35.6 | 17,590 | 2.02 | 1.56 | 1.00 |
| rc11 | `locks/linuxrwlock` | 3 | eager | 46.4 | 160,548 | 0.29 | 1.00 | 1.00 |
| | | | propagator | 65.1 | 271,038 | 0.24 | 1.40 | 1.69 |
| | | | path shape | 161.1 | 217,249 | 0.74 | 3.47 | 1.35 |
| aarch64 | `lfds/ms` | 4 | eager | 46.4 | 38,789 | 1.20 | 1.00 | 1.00 |
| | | | propagator | 53.2 | 46,334 | 1.15 | 1.15 | 1.19 |
| | | | path shape | 55.8 | 36,451 | 1.53 | 1.20 | 0.94 |
| aarch64 | `locks/linuxrwlock` | 3 | eager | 42.7 | 147,726 | 0.29 | 1.00 | 1.00 |
| | | | propagator | 47.9 | 130,136 | 0.37 | 1.12 | 0.88 |
| | | | path shape | 63.4 | 112,354 | 0.56 | 1.49 | 0.76 |
| **Total** | | | eager | **297.3** | **469,914** | **0.63** | **1.00** | **1.00** |
| **Total** | | | propagator | **334.8** | **575,593** | **0.58** | **1.13** | **1.22** |
| **Total** | | | path shape | **501.7** | **484,895** | **1.03** | **1.69** | **1.03** |

- **The plain propagator loses on the search.** Overall it needs 22% more conflicts than `eager`, while each conflict
  is slightly cheaper (0.58 vs. 0.63 ms). Its time follows its conflict count: it wins where it needs fewer conflicts
  (vmm `lfds/ms` 3: 0.78× conflicts, 0.94× time) and loses where it needs more (rc11 `lfds/dglm` 4: 1.78×,
  `locks/linuxrwlock` 3: 1.69×). The exception is aarch64 `locks/linuxrwlock` 3 (0.88× conflicts but 1.12× time),
  where its overhead matters too.
- **The path shape propagator loses on overhead.** It needs about as many conflicts as `eager` (1.03×), but each one
  costs 1.6× more on average, and 2.6× on rc11 `locks/linuxrwlock` 3.
- Sequential runs are about 20% faster than the parallel runs above (e.g. vmm `lfds/ms` 3 `eager`: 59.2 s vs.
  75.6 s).

## Results before the rebase

Measured on top of `development` at `f5c2eb3cf`, before #1154 and #1159.

Setup:

- `--method=eager` vs. `--method=propagator`, Z3 4.14.0 (JavaSMT 5.0.1), timeout 300 s.
- Each configuration was run with `--solver.randomSeed=1`, `2` and `3`.
- Time is the CPU time of the whole `dartagnan` process (user + system), because the machine was shared with other
  load. Runs that were interrupted by the machine going to sleep were repeated.
- *Speedup* is `eager` time / `propagator` time (> 1: the propagator is faster). The per-seed columns are the speedup
  of that run; the last three columns are means over the 3 seeds.

### Hard configurations

| Model | Program | Bound | Result | Seed 1 | Seed 2 | Seed 3 | Eager (s) | Propagator (s) | Speedup |
|---|---|---:|---|---:|---:|---:|---:|---:|---:|
| vmm | `lfds/ms` | 3 | PASS | 1.28 | 1.54 | 1.39 | 188.1 | 134.6 | **1.40** |
| rc11 | `lfds/ms` | 3 | PASS | 1.34 | 0.91 | 1.34 | 144.1 | 121.7 | **1.18** |
| vmm | `lfds/dglm` | 4 | PASS | 1.44 | 0.89 | 1.11 | 117.5 | 104.5 | **1.12** |
| vmm | `lfds/treiber` | 4 | UNKNOWN | 1.18 | 1.15 | 1.01 | 24.5 | 21.9 | **1.12** |
| rc11 | `locks/linuxrwlock` | 2 | UNKNOWN | 1.15 | 0.91 | 1.40 | 32.2 | 29.4 | 1.10 |
| rc11 | `lfds/dglm` | 3 | PASS | 1.13 | 1.07 | 0.96 | 36.3 | 34.4 | 1.06 |
| rc11 | `lfds/dglm` | 4 | PASS | 1.11 | 1.00 | 0.92 | 64.9 | 64.8 | 1.00 |
| vmm | `lfds/dglm` | 3 | PASS | 1.07 | 0.90 | 1.08 | 61.6 | 61.4 | 1.00 |
| rc11 | `lfds/treiber` | 4 | UNKNOWN | 1.04 | 1.01 | 0.94 | 18.3 | 18.4 | 1.00 |
| rc11 | `locks/linuxrwlock` | 3 | UNKNOWN | 1.00 | 0.99 | 0.95 | 123.5 | 125.8 | 0.98 |
| vmm | `locks/linuxrwlock` | 3 | FAIL | 1.10 | 0.84 | 0.92 | 13.3 | 14.0 | 0.95 |
| vmm | `locks/mutex_musl` | 3 | UNKNOWN | 0.97 | 0.91 | 0.93 | 20.3 | 21.7 | 0.94 |
| aarch64 | `lfds/ms` | 3 | PASS | 0.81 | 1.03 | 0.72 | 27.6 | 32.3 | 0.85 |
| aarch64 | `locks/linuxrwlock` | 3 | UNKNOWN | 0.67 | 0.73 | 0.92 | 36.3 | 47.2 | 0.77 |
| aarch64 | `lfds/dglm` | 4 | PASS | 0.84 | 0.72 | 0.71 | 16.3 | 21.6 | 0.75 |
| aarch64 | `lfds/ms` | 4 | PASS | 0.70 | 0.60 | 0.72 | 44.3 | 66.8 | 0.66 |
| **Total** | | | | | | | **969.2** | **920.6** | **1.05** |

Per model:

| Model | Configurations | Eager (s) | Propagator (s) | Speedup |
|---|---:|---:|---:|---:|
| vmm | 6 | 425.3 | 358.2 | 1.19 |
| rc11 | 6 | 419.4 | 394.4 | 1.06 |
| aarch64 | 4 | 124.5 | 167.9 | 0.74 |

### CI performance configurations

The configurations of `.github/performance-benchmarks.yml`. Most of them take 10–40 s, a few seconds of which are
parsing, compilation and encoding, which are the same for both methods.

| Model | Program | Bound | Eager (s) | Propagator (s) | Speedup |
|---|---|---:|---:|---:|---:|
| vmm | `locks/cna` | 1 | 15.0 | 15.2 | 0.98 |
| vmm | `locks/mutex_musl` | 3 | 21.2 | 22.3 | 0.95 |
| vmm | `lfds/dglm` | 2 | 28.4 | 27.7 | 1.03 |
| vmm | `lfds/ms` | 2 | 37.4 | 39.0 | 0.96 |
| vmm | `lfds/treiber` | 3 | 14.4 | 12.9 | 1.11 |
| vmm | `lfds/safe_stack` | 1 | 12.0 | 12.0 | 0.99 |
| vmm | `challenging/cna` | 1 | 30.1 | 28.4 | 1.06 |
| power | `locks/linuxrwlock` | 2 | 25.0 | 22.8 | 1.10 |
| power | `locks/mutex_musl` | 4 | 22.2 | 22.5 | 0.99 |
| power | `lfds/dglm` | 1 | 11.1 | 11.3 | 0.98 |
| power | `lfds/ms` | 2 | 29.2 | 29.7 | 0.98 |
| power | `lfds/treiber` | 4 | 17.6 | 17.6 | 1.00 |
| aarch64 | `locks/linuxrwlock` | 2 | 13.6 | 17.4 | 0.78 |
| aarch64 | `locks/mutex_musl` | 5 | 13.0 | 14.5 | 0.90 |
| aarch64 | `lfds/dglm` | 3 | 12.7 | 15.3 | 0.83 |
| aarch64 | `lfds/ms` | 2 | 13.8 | 15.5 | 0.89 |
| aarch64 | `challenging/cna` | 2 | 21.7 | 29.5 | 0.74 |
| aarch64 | `challenging/wsq` | 1 | 21.0 | 25.4 | 0.83 |
| **Total** | | | **359.4** | **379.2** | **0.95** |

Per model: vmm 158.4 s vs. 157.6 s (1.00), power 105.0 s vs. 104.0 s (1.01), aarch64 96.0 s vs. 117.6 s (0.82).

### Observations before the rebase

- The speedup of a single configuration varies by up to ±0.3 between seeds, following the number of conflicts Z3
  needs in that run. A single seed (as in an earlier version of this file: 1.11 overall) overstates the gain.
- The propagator pays off on long searches with vmm (`lfds/ms` 3, `lfds/dglm` 4, `lfds/treiber` 4). On short runs,
  and on rc11 and power, it is at parity with `eager`.
- aarch64 is slower in 11 of the 12 hard runs and in all 5 CI configurations.

## Testing

- All litmus test classes pass with `--method=propagator`: AArch64 (23,559 tests), RISC-V (20,400), Linux (15,315,
  5,105 skipped), PPC (7,089), RC11 (405), C11 (405). The path shape propagator passes the same suites.
- `PathAutomatonTest` covers the construction of the automata used by the path shape propagator.

## TODOs and possible improvements

- **Stronger reasons for the plain propagator.** It loses because it needs more conflicts than `eager` (see
  [Where the time goes](#where-the-time-goes)), especially on rc11. Shorter conflict and propagation reasons (e.g. the
  shortest cycle, or preferring literals assigned at lower decision levels) are the most promising direction.
- **Lower per-check cost for the path shape propagator.** Its search is as good as `eager`'s, but each conflict costs
  1.6× more, so it only becomes competitive if its checks on the product graph get much cheaper.
- **Choose per axiom.** The propagator only pays off on vmm. Decide per axiom whether to encode it eagerly or
  propagate it, e.g. based on the number of may-edges of its relation and the share of must-edges.
- **Native implementation.** Avoid the JNI cost, e.g. by prototyping Z3's built-in `special_relations` theory
  (partial orders and transitive closure) for acyclicity. This would be Z3-only.
- **aarch64 (before the rebase).** The propagator needed 25–40% more conflicts than `eager` on aarch64, so the gap was
  in the search, not in the propagator's overhead. A first experiment (seed 1, hard configurations only, not on the
  branch) encoded one of aarch64's acyclicity axioms eagerly and propagated the other: encoding `internal` eagerly
  brought the propagator from 151 s to 124 s (`eager`: 112 s), encoding `external` eagerly to 126 s. Neither beats
  `eager`. Deriving stronger (shorter) reasons is the other direction.
- **Incremental cycle detection.** Port the incremental topological order of the path shape propagator to
  `AcyclicityPropagator`, to bound cycle detection and the backward search used for propagation. This mostly helps
  configurations with many conflicts (e.g. rc11 `locks/linuxrwlock` 3). Low priority: the path shape propagator
  already has it and is the slowest method.
- **More configurations.** Benchmark other models (power, RISC-V, LKMM, TSO) on hard configurations, and larger
  bounds where `eager` times out (e.g. vmm `lfds/ms` 4), where the propagator is most likely to pay off.
- **Must-edges enabled by execution literals.** Assigning an execution literal can enable must-edges, but does not
  trigger a re-check of propagation candidates that only became propagatable through that literal, so some
  propagations are missed.
