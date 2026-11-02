# Acyclicity axioms as a Z3 user propagator

Branch `agentic/axiom-propagator`. This file documents what the branch does, how it was tested, the performance
results, and what is still open.

## Summary

`--method=propagator` (`PropagatorSolver`) uses the eager encoding, except for the (unflagged, non-negated)
`acyclic` axioms of the memory model. Those are not encoded; a Z3 user propagator (`AcyclicityPropagator`) checks
them during the search instead. It detects cycles as soon as the current assignment contains one (conflict) and
propagates edges that would close a cycle to false (theory propagation).

- On 16 hard configurations (rc11, vmm, aarch64), averaged over 3 seeds, total CPU time goes from 969 s (`eager`)
  to 921 s (`propagator`): **5% faster**. The gain comes from vmm (**19% faster**), rc11 is 6% faster, and aarch64
  is **26% slower**, because the search needs more conflicts there (see [TODOs](#todos-and-possible-improvements)).
- On the 18 CI performance configurations (vmm, power, aarch64), which are short runs, the propagator is **5% slower**:
  vmm and power are at parity, aarch64 is 18% slower.
- Every configuration gives the same verdict with both methods.
- All litmus suites pass with the propagator (AArch64, Linux, PPC, RISC-V, RC11, C11).

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
default 4, and `solver.propagator.irreflexivity`, default true). It passes all litmus suites, but on the hard
configurations below (seed 1 only) it was 15% slower than `eager`: it needs about as many conflicts as the plain
propagator, but each one is more expensive. It is kept on the branch for further experiments.

## Results

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

### Observations

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

- **aarch64.** The propagator needs 25–40% more conflicts than `eager` on aarch64, so the gap is in the search, not in
  the propagator's overhead. A first experiment (seed 1, hard configurations only, not on the branch) encoded one of
  aarch64's acyclicity axioms eagerly and propagated the other: encoding `internal` eagerly brought the propagator from
  151 s to 124 s (`eager`: 112 s), encoding `external` eagerly to 126 s. Neither beats `eager`. Deriving stronger
  (shorter) reasons is the other direction.
- **Incremental cycle detection.** Port the incremental topological order of the path shape propagator to
  `AcyclicityPropagator`, to bound cycle detection and the backward search used for propagation. This mostly helps
  configurations with many conflicts (e.g. rc11 `locks/linuxrwlock` 3).
- **More configurations.** Benchmark other models (power, RISC-V, LKMM, TSO) on hard configurations, and larger
  bounds where `eager` times out (e.g. vmm `lfds/ms` 4), where the propagator is most likely to pay off.
- **Must-edges enabled by execution literals.** Assigning an execution literal can enable must-edges, but does not
  trigger a re-check of propagation candidates that only became propagatable through that literal, so some
  propagations are missed.
