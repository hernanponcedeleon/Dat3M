# Polarity-aware encoding of derived relations

Branch: `agentic/polarity-encoding` (commit `d60a02a32`, based on `development` at `f6af468b6`).

## What the branch implements

The eager (SMT) encoding in `WmmEncoder` used to encode every derived relation of the memory model as a full
equivalence between its edge variable and its definition, e.g. for `r = r1 | r2`:

```
r(x,y) <=> r1(x,y) \/ r2(x,y)
```

This branch encodes each derived relation only in the direction(s) actually needed by the axioms that
(transitively) use it, in the style of the Plaisted–Greenbaum transformation:

| polarity | encoded constraint | edge variable then … | needed when the relation is used … |
|---|---|---|---|
| `LOWER` | `definition => edge` | over-approximates the relation | negatively, e.g. in `acyclic`/`irreflexive`/`empty` consistency axioms |
| `UPPER` | `edge => definition` | under-approximates the relation | positively, e.g. in negated axioms (`~empty`, …) |
| `EXACT` | `edge <=> definition` | is exact | both ways, or polarity unknown |

How the polarities are computed (`WmmEncoder.computePolarities`):

- **Seeds:** every encoded axiom seeds its relation with `LOWER` (consistency axiom) or `UPPER` (negated axiom).
  Flagged axioms are treated like non-flagged ones (see the soundness section).
- **Propagation:** a worklist propagates polarities to operands until a fixpoint.
  - All derived operators are monotone and pass the polarity on unchanged: union, intersection, composition,
    transitive closure, domain/range projection, set identity, inverse and Cartesian product.
  - The subtrahend of a difference gets the flipped polarity (`LOWER` <-> `UPPER`).
  - Any other definition (base relations, which the encoder always encodes exactly) requires its operands to
    be `EXACT`.
- **Unreached relations:** a relation not reached from any axiom is encoded `EXACT`, to be safe.

In the `LOWER` case, a disjunctive definition (union, composition, closure, projection) is emitted as one small
implication per disjunct (`d_i => edge`) instead of one large clause. Must-edges (from the relation analysis)
are encoded exactly as before.

**Option:** `--encoding.wmm.polarityAware=<bool>` (default `true`). With `false`, the encoding is identical to
`development`.

**Exact encodings where needed:** the refinement (lazy/CAAT) and enumeration solvers read the values of derived
relations from the SMT model, so they use the new factory `WmmEncoder.withExactRelations(...)`, which always
encodes exactly.

## Why it is sound

**Claim.** For a fixed program encoding and property, the polarity-aware encoding is satisfiable iff the exact
encoding is. So `PASS`/`FAIL` verdicts are unchanged.

**(Exact SAT ⇒ polarity SAT).** Every polarity constraint (`def => edge` or `edge => def`) is implied by the
corresponding equivalence. So any model of the exact encoding is also a model of the polarity encoding.

**(Polarity SAT ⇒ exact SAT).** Take a model `M` of the polarity encoding.

1. Keep the program, control-flow and base-relation values of `M`. Base relations are always encoded exactly.
2. Recompute every derived relation `R*` exactly from its definition.
3. By induction over the definition order:
   - every `LOWER` relation satisfies `R* ⊆ edge_R`;
   - every `UPPER` relation satisfies `edge_R ⊆ R*`;
   - every `EXACT` relation satisfies `edge_R = R*`.

The induction works for three reasons:

- Monotone operators preserve inclusions in the same direction.
- A difference `A \ B` is antitone in `B`, which is exactly why the subtrahend's polarity is flipped.
- Non-derived definitions only take `EXACT` operands.

The axioms then transfer from `M` to the recomputed assignment:

- **Consistency axioms** (`acyclic`, `irreflexive`, `empty`) are antitone in their relation and are seeded
  `LOWER`. If they hold for the over-approximation `edge_R`, they hold for `R* ⊆ edge_R`.
- **Negated axioms** (`~empty`, `~acyclic`, …) are monotone and are seeded `UPPER`. If they hold for the
  under-approximation `edge_R`, they hold for `R* ⊇ edge_R`.
- **Flagged axioms** (e.g. data-race flags) are checked through `PropertyEncoder`, which uses *weak tracking*:
  `trackingLit => axiomFormula`. The axiom formula therefore only occurs positively, which is the same
  requirement as for a consistency axiom. A model that claims a flag is raised must really raise it.
  `PropertyEncoder` now has a comment saying that weak tracking must be kept for this reason.

So the recomputed assignment satisfies the exact encoding together with the same program and property
constraints.

**Caveat (models, not verdicts).** In a `FAIL` model, the edge variables of derived relations may over- or
under-approximate the real relation. Anything reading derived relations from the model must therefore use
`withExactRelations` (as refinement and enumeration now do). The verdict and the reported violation are real.
For a violated flag, the pairs reported as witnesses (`IREvaluator.eventGraph`) are guaranteed to be real
(for negated flags), but may not be all of them.

**Empirical check.** Every run in the evaluation below was executed with both encodings at the same bound.
There were **no result mismatches** in any of the 287 runs.

## Performance evaluation

### Setup

- **Binary:** the native Dartagnan binary (`mvn -Pnative package`) built from this branch, on macOS ARM64
  (18 cores), with Z3 and `--method=eager`.
- **Baseline ("dev"):** `--encoding.wmm.polarityAware=false`, which is exactly the `development` eager
  encoding. Comparing SMT dumps confirmed that the flag changes the encoding: `ttas.c` on aarch64 has 14,261 vs.
  7,270 implications.
- **Benchmarks:** all `.c` files in `benchmarks/locks`, `benchmarks/lfds` and `benchmarks/challenging`
  (21 programs). Each ran on aarch64 (`cat/aarch64.cat`, `--target=arm8`), power (`cat/power.cat`,
  `--target=power`) and vmm (`cat/vmm.cat`, `--target=c11`), giving 63 benchmark/model pairs.
- **Stopping rule:** the bound starts at 1 and increases until the result is final (`PASS`/`FAIL`) or a single
  run exceeds the **180 s timeout**. At every bound both encodings run, alternating which goes first.
- **Load:** 6 pairs run in parallel. Each configuration ran once per bound, so differences below roughly
  10–15 % are within noise.

### Summary

| model | solved, dev → polarity | cumulative time, dev → polarity | geomean speedup, final run¹ | geomean speedup, all common bounds¹ |
|---|---:|---:|---:|---:|
| aarch64 | 20 → 20 / 21 | 778 s → 591 s | 1.38× (n=9) | **1.25×** (n=29) |
| power | 15 → 17 / 21 | 2149 s → 1629 s | 1.45× (n=7) | **1.73×** (n=23) |
| vmm | 15 → 19 / 21 | 2354 s → 1276 s | 1.93× (n=6) | **2.10×** (n=28) |
| **total** | **50 → 56 / 63** | **5281 s → 3496 s** | | |

¹ Speedup = dev time / polarity time. Only runs where both encodings finished and at least one took ≥ 1 s are
included. Cumulative time counts timeouts as 180 s, so it understates the gain.

- **Never worse on solved count:** polarity never solves fewer instances than dev.
- **Newly solved (6):**
  - power: `lfds/dglm` and `locks/linuxrwlock`;
  - vmm: `lfds/ms`, `lfds/safe_stack`, `locks/mutex_musl` and `challenging/wsq`.
- **Only significant regression:** `locks/cna.c` on power at bound 2 (117 s → 171 s, 0.69×). It still passes.
  The other slowdowns are on sub-second runs and within noise or encoding overhead.
- **Unsolved by both:** `challenging/harris-3` on all models; on power, `challenging/cna`, `challenging/wsq`
  and `lfds/safe_stack`; on vmm, `challenging/cna`. On vmm `challenging/cna`, polarity gets one bound further
  before timing out.

### Per-benchmark results

Columns:
- **dev / polarity:** the final result and the bound it was reached at.
- **last run:** the time of the run at that bound.
- **cumul:** the time summed over all bounds.

#### aarch64

| benchmark | dev | polarity | dev last run [s] | polarity last run [s] | speedup | dev cumul [s] | polarity cumul [s] |
|---|---|---|---:|---:|---:|---:|---:|
| challenging/cna.c | PASS@3 | PASS@3 | 117.80 | 59.58 | 1.98× | 141.0 | 74.7 |
| challenging/harris-3.c | TIMEOUT@2 | TIMEOUT@2 | 180.00 | 180.00 | | 182.0 | 181.7 |
| challenging/wsq.c | PASS@5 | PASS@5 | 39.03 | 27.55 | 1.42× | 101.4 | 75.3 |
| lfds/chase-lev.c | PASS@1 | PASS@1 | 0.40 | 0.31 | 1.28× | 0.4 | 0.3 |
| lfds/dglm.c | PASS@3 | PASS@3 | 9.26 | 8.77 | 1.06× | 15.4 | 14.8 |
| lfds/hash_table.c | PASS@1 | PASS@1 | 0.13 | 0.14 | 0.94× | 0.1 | 0.1 |
| lfds/ms.c | PASS@3 | PASS@3 | 26.53 | 29.04 | 0.91× | 37.2 | 40.8 |
| lfds/safe_stack.c | FAIL@2 | FAIL@2 | 22.61 | 9.94 | 2.27× | 24.0 | 11.4 |
| lfds/treiber.c | PASS@5 | PASS@5 | 9.06 | 9.00 | 1.01× | 18.4 | 17.5 |
| locks/clh_mutex.c | PASS@2 | PASS@2 | 0.20 | 0.20 | 1.01× | 0.4 | 0.4 |
| locks/cna.c | PASS@2 | PASS@2 | 1.30 | 1.11 | 1.17× | 2.5 | 2.1 |
| locks/deadlock.c | FAIL@1 | FAIL@1 | 0.11 | 0.11 | 0.94× | 0.1 | 0.1 |
| locks/linuxrwlock.c | PASS@4 | PASS@4 | 159.63 | 94.38 | 1.69× | 215.9 | 144.8 |
| locks/mutex.c | PASS@3 | PASS@3 | 0.89 | 0.77 | 1.16× | 1.7 | 1.6 |
| locks/mutex_musl.c | PASS@6 | PASS@6 | 18.30 | 12.06 | 1.52× | 35.7 | 23.3 |
| locks/pthread_mutex.c | FAIL@1 | FAIL@1 | 0.11 | 0.12 | 0.95× | 0.1 | 0.1 |
| locks/seqlock.c | PASS@1 | PASS@1 | 0.15 | 0.16 | 0.93× | 0.2 | 0.2 |
| locks/spinlock.c | PASS@1 | PASS@1 | 0.13 | 0.14 | 0.91× | 0.1 | 0.1 |
| locks/ticket_awnsb_mutex.c | PASS@1 | PASS@1 | 0.84 | 0.68 | 1.23× | 0.8 | 0.7 |
| locks/ticketlock.c | PASS@1 | PASS@1 | 0.13 | 0.15 | 0.91× | 0.1 | 0.1 |
| locks/ttas.c | PASS@3 | PASS@3 | 0.23 | 0.22 | 1.01× | 0.5 | 0.5 |

#### power

| benchmark | dev | polarity | dev last run [s] | polarity last run [s] | speedup | dev cumul [s] | polarity cumul [s] |
|---|---|---|---:|---:|---:|---:|---:|
| challenging/cna.c | TIMEOUT@1 | TIMEOUT@1 | 180.00 | 180.00 | | 180.0 | 180.0 |
| challenging/harris-3.c | TIMEOUT@1 | TIMEOUT@1 | 180.00 | 180.00 | | 180.0 | 180.0 |
| challenging/wsq.c | TIMEOUT@1 | TIMEOUT@1 | 180.00 | 180.00 | | 180.0 | 180.0 |
| lfds/chase-lev.c | PASS@1 | PASS@1 | 0.86 | 1.27 | 0.68× | 0.9 | 1.3 |
| lfds/dglm.c | **TIMEOUT@3** | **PASS@3** | 180.00 | 132.46 | > 1.36× | 286.4 | 168.2 |
| lfds/hash_table.c | PASS@1 | PASS@1 | 0.15 | 0.16 | 0.94× | 0.1 | 0.2 |
| lfds/ms.c | PASS@3 | PASS@3 | 135.20 | 52.76 | 2.56× | 184.4 | 75.1 |
| lfds/safe_stack.c | TIMEOUT@2 | TIMEOUT@2 | 180.00 | 180.00 | | 273.2 | 252.8 |
| lfds/treiber.c | PASS@5 | PASS@5 | 42.76 | 18.60 | 2.30× | 78.0 | 37.3 |
| locks/clh_mutex.c | PASS@2 | PASS@2 | 0.33 | 0.30 | 1.08× | 0.6 | 0.5 |
| locks/cna.c | PASS@2 | PASS@2 | 117.25 | 170.58 | 0.69× | 205.9 | 237.7 |
| locks/deadlock.c | FAIL@1 | FAIL@1 | 0.10 | 0.30 | 0.35× | 0.1 | 0.3 |
| locks/linuxrwlock.c | **TIMEOUT@4** | **PASS@4** | 180.00 | 145.22 | > 1.24× | 369.5 | 219.6 |
| locks/mutex.c | PASS@3 | PASS@3 | 3.49 | 2.06 | 1.70× | 5.8 | 3.7 |
| locks/mutex_musl.c | PASS@6 | PASS@6 | 114.70 | 53.04 | 2.16× | 200.4 | 88.7 |
| locks/pthread_mutex.c | FAIL@1 | FAIL@1 | 0.11 | 0.12 | 0.95× | 0.1 | 0.1 |
| locks/seqlock.c | PASS@1 | PASS@1 | 0.16 | 0.17 | 0.94× | 0.2 | 0.2 |
| locks/spinlock.c | PASS@1 | PASS@1 | 0.15 | 0.15 | 1.00× | 0.2 | 0.2 |
| locks/ticket_awnsb_mutex.c | PASS@1 | PASS@1 | 2.21 | 1.63 | 1.36× | 2.2 | 1.6 |
| locks/ticketlock.c | PASS@1 | PASS@1 | 0.40 | 0.45 | 0.88× | 0.4 | 0.5 |
| locks/ttas.c | PASS@3 | PASS@3 | 0.38 | 0.34 | 1.13× | 0.8 | 0.8 |

#### vmm

| benchmark | dev | polarity | dev last run [s] | polarity last run [s] | speedup | dev cumul [s] | polarity cumul [s] |
|---|---|---|---:|---:|---:|---:|---:|
| challenging/cna.c | TIMEOUT@2 | TIMEOUT@3 | 180.00 | 180.00 | | 213.7 | 273.8 |
| challenging/harris-3.c | TIMEOUT@2 | TIMEOUT@2 | 180.00 | 180.00 | | 191.0 | 187.8 |
| challenging/wsq.c | **TIMEOUT@5** | **PASS@5** | 180.00 | 71.67 | > 2.51× | 819.3 | 363.5 |
| lfds/chase-lev.c | PASS@1 | PASS@1 | 0.63 | 0.76 | 0.83× | 0.6 | 0.8 |
| lfds/dglm.c | PASS@3 | PASS@3 | 86.78 | 33.21 | 2.61× | 126.4 | 52.2 |
| lfds/hash_table.c | PASS@1 | PASS@1 | 0.17 | 0.18 | 0.96× | 0.2 | 0.2 |
| lfds/ms.c | **TIMEOUT@3** | **PASS@3** | 180.00 | 64.06 | > 2.81× | 236.9 | 89.8 |
| lfds/safe_stack.c | **TIMEOUT@2** | **FAIL@2** | 180.00 | 127.91 | > 1.41× | 189.7 | 134.2 |
| lfds/treiber.c | PASS@5 | PASS@5 | 61.43 | 23.58 | 2.61× | 111.2 | 47.3 |
| locks/clh_mutex.c | PASS@2 | PASS@2 | 0.38 | 0.36 | 1.06× | 0.6 | 0.7 |
| locks/cna.c | PASS@2 | PASS@2 | 16.50 | 6.07 | 2.72× | 28.2 | 11.6 |
| locks/deadlock.c | FAIL@1 | FAIL@1 | 0.11 | 0.11 | 0.97× | 0.1 | 0.1 |
| locks/linuxrwlock.c | FAIL@2 | FAIL@2 | 2.27 | 2.53 | 0.90× | 4.2 | 3.7 |
| locks/mutex.c | PASS@3 | PASS@3 | 7.78 | 3.82 | 2.03× | 12.8 | 6.6 |
| locks/mutex_musl.c | **TIMEOUT@6** | **PASS@6** | 180.00 | 45.26 | > 3.98× | 414.8 | 101.1 |
| locks/pthread_mutex.c | FAIL@1 | FAIL@1 | 0.12 | 0.13 | 0.96× | 0.1 | 0.1 |
| locks/seqlock.c | PASS@1 | PASS@1 | 0.22 | 0.22 | 0.96× | 0.2 | 0.2 |
| locks/spinlock.c | PASS@1 | PASS@1 | 0.18 | 0.18 | 1.00× | 0.2 | 0.2 |
| locks/ticket_awnsb_mutex.c | PASS@1 | PASS@1 | 2.67 | 1.72 | 1.55× | 2.7 | 1.7 |
| locks/ticketlock.c | PASS@1 | PASS@1 | 0.17 | 0.18 | 0.98× | 0.2 | 0.2 |
| locks/ttas.c | PASS@3 | PASS@3 | 0.58 | 0.45 | 1.28× | 1.1 | 0.9 |

### Conclusion

The polarity-aware encoding is a clear improvement over `development`'s eager encoding:

- It speeds up non-trivial instances by about **1.25× on aarch64, 1.7× on power and 2.1× on vmm** (geomean).
- It solves **6 more instances** (56 vs. 50 of 63) within the 3-minute budget.
- It does not change any verdict.

The gain grows with the size of the memory model's derived-relation structure: vmm benefits most and aarch64
least. The only notable regression is power `locks/cna.c` at bound 2 (0.69×). A repeated-runs measurement with
confidence intervals (e.g. `scripts/compare_performance.py`) would be the next step to confirm it and the
borderline cases.
