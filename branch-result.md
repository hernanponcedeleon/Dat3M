# Branch result: `agentic/transitive-bounds`

This branch makes the relation analysis more precise using *transitive bounds*.
It is based on `development` (`f5c2eb3cf`).

## Summary

- **The change:** the relation analysis now prunes more pairs from the may-sets of derived relations, and the pruning is sound. If a relation `R` is contained in a transitive relation `T` (e.g. `fr ⊆ loc`, `fr ⊆ eco`), then any pair of `may(R)` that is not in `may(T)` is removed.
- **Effect on the encoding:** across 21 benchmarks (`benchmarks/{challenging,lfds,locks}`) and 7 memory models, 144 configurations completed. In those, the number of **encoded edges drops from 8,982,501 to 8,660,105 (−3.6%)**:
  - 50 configurations shrink, by up to −29%;
  - 91 are unchanged;
  - 3 grow slightly, by at most +0.2%.
- **Where the increases come from:** only the part of the change that runs in the extended (axiom-based) relation analysis. See [Cases where the encoding grows](#cases-where-the-encoding-grows).

## The problem

The relation analysis over-approximates a composition by composing the may-sets of its operands:
`may(r1;r2) = may(r1) ∘ may(r2)`. This loses information when the composition lies inside some relation whose may-set is not transitive.

The main example is `loc`. Its may-set comes from the alias analysis, and *may-alias is not transitive*:

```c
int *p = nondet ? &x : &y;
*p = 1;      // w'  may alias x and y
r = x;       // r
y = 2;       // w
```

Both `may-rf(w', r)` and `may-co(w', w)` hold, so `(r, w)` ends up in `may(fr)` for `fr = rf^-1;co`. Yet `r` and `w` can never access the same address. Every such pair becomes SMT variables and constraints.

## The changes

| File | Change |
|---|---|
| `wmm/analysis/TransitiveBounds.java` (new) | Infers, for every relation `R`, the transitive relations `T` with `R ⊆ T`. |
| `wmm/analysis/NativeRelationAnalysis.java` | Uses the bounds to prune may-sets, in both the main pass and the extended pass. |
| `wmm/analysis/LazyRelationAnalysis.java` | Applies the same main-pass pruning, because Native and Lazy must agree. |
| `wmm/analysis/TransitiveBoundsTest.java` (new) | Tests the inference and both pruning steps. |
| `relation-analysis/loc-composition.ll`, `benchmarks/miscellaneous/loc-composition.c` (new) | Test program from the example above. |

### 1. Inferring transitive bounds (`TransitiveBounds`)

The relations treated as transitive are:

- `loc`, `int` and same-instruction (all equivalence relations);
- every closure `X+`;
- intersections of transitive relations.

`co` is deliberately **not** treated as transitive. Its encoding does not enforce transitivity on architectures where coherence is not total.

Containment is computed as a greatest fixed point over the `.cat` definitions. The computation also tracks containment in the identity relation (`ID`), which is how sets such as `[W]` are represented.

| Definition of `R` | Bounds of `R` |
|---|---|
| base facts | `rf, co ⊆ loc`, `po ⊆ int`, sets ⊆ `ID`, empty ⊆ everything |
| syntax | `X ⊆ X+`, every operand of a union is contained in the union |
| `A ∪ B` | bounds(A) ∩ bounds(B) |
| `A ∩ B` | bounds(A) ∪ bounds(B) |
| `A \ B` | bounds(A) |
| `A+` | bounds(A) |
| `A^-1` | symmetric bounds of A |
| `A ; B` | `T` if (A ⊆ T or A ⊆ ID) and (B ⊆ T or B ⊆ ID) and (A ⊆ T or B ⊆ T); `ID` if both are ⊆ ID |

For RC11 this gives, for example, `fr ⊆ {loc, eco}`, `po ⊆ {int, hb}` and `hbl ⊆ {loc, hb}`.

### 2. Main-pass pruning (`NativeRelationAnalysis.run`, `LazyRelationAnalysis`)

While knowledge is propagated, a new may-pair of a derived relation `R` is dropped if it is not in `may(T)` for some bound `T` whose may-set is already final. That means `T` is a base relation such as `loc`, or a relation that `R` strictly depends on.

Dropped pairs are recorded and excluded in `collectDiscrepancies`, so the encoder doesn't have to encode them.

### 3. Extended-pass pruning (`NativeRelationAnalysis.runExtended`)

The extended analysis can remove pairs from a transitive relation `T` because of an axiom; for example, `acyclic(hb)` removes pairs from `hb`. The same pairs are then also removed from every relation bounded by `T`, such as `pol;hb;pol`.

As with every removal in the extended analysis, these pairs are reported as discrepancies, and the encoder adds constraints that rule them out.

## Why it is sound

1. **The bounds are correct.**
   - `loc`, `int` and same-instruction are equivalence relations, and closures are transitive by construction.
   - Transitivity justifies the rules for `;` and `+`, symmetry justifies `^-1`, and the remaining operators follow from set algebra.
   - The base facts hold in the encoding: `rf` and `co` edges imply `sameAddress`.
   - For recursive relations, the meaning of the definition is the limit of a chain that starts at the empty relation. Each rule preserves containment in the final value of the bound, so the greatest fixed point is sound by induction.
2. **Main pass.**
   - The main pass over-approximates every SMT model: in each model, a relation's value lies within its main-pass may-set.
   - So if `R ⊆ T` and a pair is not in `may(T)`, no model's `R` contains that pair.
   - These removals hold regardless of the memory model's axioms and need not be encoded.
   - Only bounds whose may-sets are final are used, because may-sets only grow during the main pass.
3. **Extended pass.**
   - A pair removed from `T` by the extended analysis cannot occur in any consistent execution, and since `R ⊆ T` it cannot occur in `R` either.
   - As for every removal in the extended analysis, the pair is reported as a discrepancy, and the encoding enforces its absence.
4. **Must-sets are untouched.** Only may-sets are pruned.

## Validation

- **`TransitiveBoundsTest`**, with three tests:
  - `inferredBounds` checks the bounds inferred for RC11 (`fr ⊆ {loc, eco}`, `co` not transitive, …).
  - `composedRelationsRespectAliasing` checks that Native and Lazy never relate non-aliasing events in `fr`, `rf` or `co`. It fails if the main-pass pruning is switched off.
  - `mayRespectsBoundsAfterExtendedAnalysis` checks that `may(R) ⊆ may(T)` holds for all bounds after the extended analysis, on RC11 and VMM. It fails if the extended-pass pruning is switched off; one failing case is `pol;hb;pol` against `hb` on `treiber`.
- **`RelationAnalysisTest`** (Native and Lazy produce identical knowledge): 40 of 40 pass.
- **Full test suite:** it was not rerun after rebasing on `development`. An earlier version of the change, before the rebase, passed the full suite on `master`: 102,635 tests, 0 failures. Its only errors came from the Yices2 solver being missing on the test machine.

## Encoded edges

**Setup:**

- **Programs:** every `.c` file in `benchmarks/challenging`, `benchmarks/lfds` and `benchmarks/locks`, run with `--bound=2` and otherwise default options.
- **Metric:** the `#Encoded edges` count that `WmmEncoder` reports.
- **Models and targets:** `rc11.cat`/`c11`, `c11.cat`/`c11`, `vmm.cat`/`c11`, `aarch64.cat`/`arm8`, `riscv.cat`/`riscv`, `power.cat`/`power`, `tso.cat`/`tso`.
- **Runs:** each run stopped right after encoding, without solving, with a 10-minute limit. `timeout` means neither `development` nor the branch finished the analysis within that limit.

Each cell shows `development → this branch`. Increases are in **bold**.

| Benchmark | RC11 | C11 | VMM | ARMv8 | RISC-V | Power | TSO |
|---|---:|---:|---:|---:|---:|---:|---:|
| `challenging/cna.c` | 173,870 → 168,098 (-3.3%) | 272,492 → 270,224 (-0.8%) | 133,807 → 129,643 (-3.1%) | 57,373 → 53,653 (-6.5%) | 31,973 → 30,149 (-5.7%) | timeout | 46,621 → 43,429 (-6.8%) |
| `challenging/harris-3.c` | 837,368 → 803,414 (-4.1%) | timeout | 653,940 → 649,638 (-0.7%) | 325,820 → 321,524 (-1.3%) | 180,517 → 178,291 (-1.2%) | timeout | 223,126 → 219,712 (-1.5%) |
| `challenging/wsq.c` | 252,419 → 208,794 (-17.3%) | 297,242 → 279,909 (-5.8%) | 174,601 → 148,095 (-15.2%) | 104,975 → 76,627 (-27.0%) | 90,488 → 69,482 (-23.2%) | 1,145,955 → 1,075,849 (-6.1%) | 76,798 → 54,500 (-29.0%) |
| `lfds/chase-lev.c` | 4,610 → 4,047 (-12.2%) | 4,771 → 4,422 (-7.3%) | 7,394 → 6,616 (-10.5%) | 6,296 → 5,428 (-13.8%) | 3,601 → 3,151 (-12.5%) | 9,542 → 8,366 (-12.3%) | 4,353 → 3,699 (-15.0%) |
| `lfds/dglm.c` | 33,992 → 33,496 (-1.5%) | 70,968 (=) | 44,989 (=) | 14,643 (=) | 8,653 (=) | **73,589 → 73,591 (+2 edges)** | 11,627 (=) |
| `lfds/hash_table.c` | 1,498 → 1,496 (-0.1%) | 1,001 (=) | 4,560 (=) | 1,010 (=) | 726 (=) | 1,769 (=) | 922 (=) |
| `lfds/ms.c` | 39,488 → 38,774 (-1.8%) | 78,682 (=) | 51,507 (=) | 18,711 (=) | 10,733 (=) | 47,553 (=) | 14,828 (=) |
| `lfds/safe_stack.c` | 231,984 → 230,934 (-0.5%) | 333,140 (=) | 145,148 (=) | 76,098 (=) | 47,731 (=) | **1,337,285 → 1,339,522 (+0.2%)** | 63,690 (=) |
| `lfds/treiber.c` | 14,731 → 14,352 (-2.6%) | 25,514 (=) | 17,363 (=) | 8,177 (=) | 4,697 (=) | 17,189 (=) | 6,547 (=) |
| `locks/clh_mutex.c` | 4,521 (=) | 7,685 (=) | 6,114 (=) | 2,156 (=) | 1,397 (=) | 7,092 → 7,011 (-1.1%) | 1,862 (=) |
| `locks/cna.c` | 36,030 → 33,102 (-8.1%) | 76,619 → 75,767 (-1.1%) | 54,552 → 52,824 (-3.2%) | 19,760 → 17,570 (-11.1%) | 12,857 → 12,083 (-6.0%) | 219,876 → 212,724 (-3.3%) | 15,737 → 14,393 (-8.5%) |
| `locks/deadlock.c` | 80 (=) | 68 (=) | 145 (=) | 80 (=) | 64 (=) | 68 (=) | 74 (=) |
| `locks/linuxrwlock.c` | **14,208 → 14,214 (+6 edges)** | 19,364 (=) | 22,781 (=) | 12,648 (=) | 7,571 (=) | 18,610 (=) | 10,394 (=) |
| `locks/mutex.c` | 16,224 → 15,876 (-2.1%) | 27,788 (=) | 21,705 (=) | 10,550 (=) | 5,909 (=) | 18,837 (=) | 8,402 (=) |
| `locks/mutex_musl.c` | 17,292 → 17,145 (-0.9%) | 30,881 (=) | 29,631 (=) | 11,993 (=) | 7,616 (=) | 28,860 (=) | 9,803 (=) |
| `locks/pthread_mutex.c` | 750 → 734 (-2.1%) | 1,020 (=) | 1,020 (=) | 441 (=) | 295 (=) | 803 (=) | 389 (=) |
| `locks/seqlock.c` | 3,828 (=) | 3,712 (=) | 5,889 (=) | 2,829 (=) | 1,716 (=) | 2,737 (=) | 2,239 (=) |
| `locks/spinlock.c` | 3,660 → 3,630 (-0.8%) | 5,666 (=) | 5,277 (=) | 2,417 (=) | 1,478 (=) | 4,680 (=) | 2,009 (=) |
| `locks/ticket_awnsb_mutex.c` | 12,691 → 12,364 (-2.6%) | 27,401 → 27,293 (-0.4%) | 19,629 → 19,425 (-1.0%) | 5,240 → 5,048 (-3.7%) | 4,040 → 3,944 (-2.4%) | 20,598 → 20,478 (-0.6%) | 4,343 → 4,175 (-3.9%) |
| `locks/ticketlock.c` | 1,755 → 1,752 (-0.2%) | 2,846 (=) | 2,832 (=) | 998 (=) | 638 (=) | 2,121 (=) | 896 (=) |
| `locks/ttas.c` | 3,600 (=) | 5,636 (=) | 5,247 (=) | 2,405 (=) | 1,466 (=) | 4,668 (=) | 1,997 (=) |

**Totals** over the 144 configurations that both builds completed: 8,982,501 → 8,660,105 encoded edges (**−3.6%**). 50 configurations shrink, 91 are unchanged and 3 grow.

**Observations:**

- **Where the largest reductions are:** programs with ambiguous pointers, where may-alias is imprecise.

  | Benchmark | Reduction |
  |---|---|
  | `challenging/wsq` | −6% to −29%, on all models |
  | `lfds/chase-lev` | −7% to −15%, on all models |
  | `locks/cna` | up to −11% |
  | `challenging/cna` | up to −7% |
- **Which model benefits most:** RC11, where 16 of 21 configurations shrink. Its `eco = (rf | co | fr)+` and `hb = (po | sw)+` are transitive bounds of many relations, and the extended analysis prunes them through the coherence axioms.
- **Why running times aren't reported:** in our measurements, runs with *identical* encodings varied more between runs than the change itself moved the times. Encoding size is the more reliable indicator here.

## Cases where the encoding grows

Three configurations grow:

| Configuration | Change |
|---|---|
| `lfds/safe_stack` on Power | +2,237 edges (+0.2%) |
| `locks/linuxrwlock` on RC11 | +6 edges |
| `lfds/dglm` on Power | +2 edges |

**Cause.** The encoder does not encode every pair of a may-set. It encodes two kinds of pairs:

- the pairs the axioms need (the active sets);
- every *discrepancy*: a pair the analysis removed from a relation although the relation's operands could still produce it. A discrepancy must be encoded together with the operand edges that could produce it, so that the encoding can rule it out.

The two pruning steps differ here:

- **Main-pass pruning can never increase the encoding.** The pairs it removes are not discrepancies, because the encoding of the operands already implies their absence.
- **Extended-pass pruning can.** The pairs it removes are discrepancies. If no axiom ever needed such a pair, it would not have been encoded at all without the change. Now it is encoded, together with the operand edges that could produce it. When that cost exceeds what the pruning saves elsewhere, the encoding grows.

**Evidence.** We measured a variant with only the extended-pass pruning switched off, labelled "main-pass filter only" below:

- Its encoding is never larger than on `development`: 0 of 144 configurations grow. Its total is 8,677,801 edges (−3.4%).
- The three configurations that grow return exactly to their `development` size (`safe_stack`/Power 1,337,285, `linuxrwlock`/RC11 14,208) or go below it (`dglm`/Power 73,583).

The table lists every configuration where the extended-pass pruning makes a difference. A negative effect means fewer encoded edges with the extended-pass pruning.

| Benchmark | Model | development | main-pass filter only | full branch | effect of extended-pass pruning |
|---|---|---:|---:|---:|---:|
| `challenging/harris-3.c` | RC11 | 837,368 | 830,768 | 803,414 | -27,354 |
| `lfds/safe_stack.c` | RC11 | 231,984 | 231,984 | 230,934 | -1,050 |
| `lfds/ms.c` | RC11 | 39,488 | 39,476 | 38,774 | -702 |
| `lfds/dglm.c` | RC11 | 33,992 | 33,974 | 33,496 | -478 |
| `locks/mutex.c` | RC11 | 16,224 | 16,224 | 15,876 | -348 |
| `lfds/treiber.c` | RC11 | 14,731 | 14,677 | 14,352 | -325 |
| `challenging/cna.c` | RC11 | 173,870 | 168,418 | 168,098 | -320 |
| `locks/cna.c` | RC11 | 36,030 | 33,348 | 33,102 | -246 |
| `locks/mutex_musl.c` | RC11 | 17,292 | 17,292 | 17,145 | -147 |
| `locks/ticket_awnsb_mutex.c` | RC11 | 12,691 | 12,451 | 12,364 | -87 |
| `locks/spinlock.c` | RC11 | 3,660 | 3,660 | 3,630 | -30 |
| `locks/pthread_mutex.c` | RC11 | 750 | 750 | 734 | -16 |
| `locks/ticketlock.c` | RC11 | 1,755 | 1,755 | 1,752 | -3 |
| `locks/clh_mutex.c` | RC11 | 4,521 | 4,515 | 4,521 | +6 |
| `locks/linuxrwlock.c` | RC11 | 14,208 | 14,208 | 14,214 | +6 |
| `lfds/dglm.c` | Power | 73,589 | 73,583 | 73,591 | +8 |
| `lfds/chase-lev.c` | Power | 9,542 | 8,354 | 8,366 | +12 |
| `locks/clh_mutex.c` | Power | 7,092 | 6,996 | 7,011 | +15 |
| `locks/cna.c` | Power | 219,876 | 212,463 | 212,724 | +261 |
| `challenging/wsq.c` | RC11 | 252,419 | 206,573 | 208,794 | +2,221 |
| `lfds/safe_stack.c` | Power | 1,337,285 | 1,337,285 | 1,339,522 | +2,237 |
| `challenging/wsq.c` | Power | 1,145,955 | 1,067,205 | 1,075,849 | +8,644 |

The extended-pass pruning saves edges in 13 configurations, all RC11, by up to −27,354 on `challenging/harris-3`. It costs edges in 9, mostly Power, by up to +8,644 on `challenging/wsq`. In total it contributes −17,696 edges (−0.2%).

**Possible follow-ups:**

- Restrict the extended-pass pruning to pairs that some axiom needs, so that the pruning never introduces new discrepancies.
- Or drop the extended-pass pruning and keep only the main-pass pruning, which never increases the encoding.
