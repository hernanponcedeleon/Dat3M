# Branch result: `agentic/wmm-invariants`

This branch makes the relation analysis more precise using *invariants* of the memory model.
It is based on `development` (`f5c2eb3cf`).

## Summary

- **The change:** a new memory model pass adds *invariants*, i.e., axioms that hold in every execution independently of the other axioms. For now, it adds `empty R \ T` (that is, `R ⊆ T`) for every relation `R` contained in a transitive relation `T`. The relation analysis uses these invariants to remove pairs from may-sets; invariants are never encoded.
- **Effect on the encoding:** on the 9 programs of the performance benchmark selection, run under 7 memory models (63 configurations), the number of **encoded edges drops from 4,726,360 to 4,477,870 (−5.3%)**:
  - 27 configurations shrink, by up to −29.7%;
  - 34 are unchanged;
  - 2 grow slightly, by at most +0.2%.
- **Correctness:** all litmus tests pass (85,378 tests, 0 failures).

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
| `wmm/axiom/Axiom.java` (and subclasses) | New `invariant` attribute. |
| `wmm/Wmm.java` | `getAxioms()` excludes invariants; new `getInvariants()` and `getRelationsRelevantForSemantics()`. |
| `wmm/processing/InferInvariants.java` (new) | Pass that adds the invariants. Runs after the passes that remove or merge relations. |
| `wmm/processing/TransitiveBounds.java` (new) | Infers the containments `R ⊆ T` with `T` transitive. |
| `wmm/analysis/InvariantBounds.java` (new) | Reads the containments `R ⊆ T` back from the invariants. |
| `wmm/analysis/NativeRelationAnalysis.java`, `LazyRelationAnalysis.java` | Use the invariants to prune may-sets. |
| `encoding/ActiveSetAnalysis.java`, `task/verification/RefinementSolver.java`, `encoding/WmmEncoder.java` | Never encode invariants or relations that only contribute to them. |
| `wmm/analysis/RelationEventDomains.java` | Fix: a difference inherits the event domains of its minuend. |
| `InvariantBoundsTest`, `InferInvariantsTest` (new), `loc-composition.ll`, `benchmarks/miscellaneous/loc-composition.c` (new) | Tests and the test program from the example above. |

### 1. Invariants

An invariant is an axiom annotated with the `invariant` attribute. It must hold in every model of the encoding *without the axioms of the model*, i.e., in every execution of the anarchic semantics, not only in consistent executions. Hence:

- it is never encoded (`Wmm.getAxioms()` does not return it, so the encoders, CAAT, the property encoder and symmetry breaking ignore it);
- the relation analysis may use it freely.

Invariants cannot be written in `.cat` files: the grammar is unchanged. Only memory model transformation passes create them, and they are responsible for their correctness. A wrong invariant makes the verification unsound.

Relations that only contribute to invariants (e.g. the helper relation `R \ T` of `empty R \ T`) are not part of the semantics of the model. `Wmm.getRelationsRelevantForSemantics()` excludes them; they are left out of the active-set computation and of the refinement solver's cut, so they are never encoded.

### 2. Inferring invariants (`InferInvariants`, `TransitiveBounds`)

The pass adds `empty R \ T` for every relation `R` and every transitive relation `T ≠ R` with `R ⊆ T`. It only considers relations relevant for the semantics, so running it twice adds nothing.

**Transitive relations** (least fixed point):

- `loc`, `int`, the same-instruction relation and the same-scope relations of a fixed scope level (`scta`, `ssg`, `swg`, `sqf`, `sdv`): equivalence relations, transitive and symmetric by construction;
- every closure `X+`;
- intersections of transitive relations;
- inverses of transitive relations;
- `A;T` and `T;B` with `T` transitive and `A`, `B` contained in the identity (e.g. `[W];loc;[W]`): `x A;T y A;T z` implies `x A x T y T z`, hence `x A;T z`.

Relations contained in the identity (sets) are trivially transitive, but they are not used as bounds.

Excluded on purpose:

- `co`: for architectures with non-total coherence (PTX, Vulkan), its encoding does not enforce transitivity; and the default SAT encoding only enforces it for some triples (see [Follow-ups](#follow-ups)).
- `sr` (same scope at the scope level of each event): not transitive. If `x` is CTA-scoped, `y` is GPU-scoped and in the CTA of `x`, and `z` is GPU-scoped and in a different CTA of the same GPU, then `x sr y` and `y sr z`, but not `x sr z`.
- `vloc` and `ssw` (sync-with): not transitive in general.

**Containment** `R ⊆ T` is computed as a greatest fixed point over the `.cat` definitions. Containment in the identity (`ID`) is computed separately, also as a greatest fixed point.

| Definition of `R` | Bounds of `R` |
|---|---|
| base facts | `rf, co ⊆ loc`, `po ⊆ int`, sets ⊆ `ID`, empty ⊆ everything |
| syntax | `X ⊆ X+`, every operand of a union is contained in the union |
| `A ∪ B` | bounds(A) ∩ bounds(B) |
| `A ∩ B` | bounds(A) ∪ bounds(B) |
| `A \ B` | bounds(A) |
| `A+` | bounds(A) |
| `A^-1` | symmetric bounds of A |
| `A ; B` | `T` if (A ⊆ T or A ⊆ ID) and (B ⊆ T or B ⊆ ID) and (A ⊆ T or B ⊆ T) |

For RC11 this gives, for example, `fr ⊆ {loc, eco}` and `hbl ⊆ {loc, hb}`.

### 3. Using invariants in the relation analysis

**Main pass** (`NativeRelationAnalysis.run`, `LazyRelationAnalysis`). While knowledge is propagated, a new may-pair of a derived relation `R` is dropped if it is not in `may(T)` for some invariant `R ⊆ T` whose `T` is already final, i.e., a base relation such as `loc`, or a relation that `R` strictly depends on.

Dropped pairs are recorded and excluded in `collectDiscrepancies`: their absence is implied by an invariant, not by an axiom, so the encoder does not have to encode them.

**Extended pass** (`NativeRelationAnalysis.runExtended`). Invariants are treated like any other axiom. For example, if `acyclic(hb)` removes a pair from `hb`, the invariant `empty (pol;hb;pol) \ hb` removes it from `pol;hb;pol` as well. As with every removal in the extended analysis, these pairs are reported as discrepancies, and the encoder adds constraints that rule them out.

### 4. Fix in `RelationEventDomains`

`RelationEventDomains` had no case for `Difference`, so every difference got visible-only event domains. No model used a difference whose minuend relates invisible events, so this went unnoticed. The inferred invariant `idd ⊆ idd+` creates `idd \ idd+`, where `idd` relates register events, and the analysis crashed with `NoSuchElementException`. A difference now inherits the domains of its minuend. `InvariantBoundsTest.differenceWithInvisibleEvents` fails without the fix.

## Why it is sound

1. **The inferred invariants hold in every model of the encoding, without the axioms.**
   - This is stronger than holding in every consistent execution, and it has to be: invariants and the pairs they remove are not encoded. If an invariant relied on the axioms, a pruned pair could be exactly the one an axiom needs to reject an inconsistent execution, and the reasoning would be circular.
   - In particular, each transitive relation `T` must be transitive in every model of the encoding. This is why `co` is excluded: it is transitive in consistent executions, but its encoding does not always enforce transitivity.
   - `loc`, `int`, same-instruction and the fixed-level scope relations are encoded as "both events execute" plus a condition that is an equivalence (same address, same thread, same instruction, same scope ids). Closures are transitive by construction. The remaining transitivity rules follow from transitivity of their operands.
   - Transitivity justifies the containment rules for `;` and `+`, symmetry justifies `^-1`, and the remaining operators follow from set algebra.
   - The base facts hold in the encoding: `rf` and `co` edges imply `sameAddress`.
   - For recursive relations, the meaning of the definition is the limit of a chain that starts at the empty relation. Each rule preserves containment in the final value of the bound, so the greatest fixed point is sound by induction.
   - None of this uses the axioms of the model, so pruning with these invariants cannot hide a violation of an axiom.
2. **Main pass.**
   - The main pass over-approximates every SMT model: in each model, a relation's value lies within its main-pass may-set.
   - So if `R ⊆ T` and a pair is not in `may(T)`, no model's `R` contains that pair.
   - Only bounds whose may-sets are final are used, because may-sets only grow during the main pass.
3. **Extended pass.** A pair removed from `T` cannot occur in any consistent execution, and since `R ⊆ T` it cannot occur in `R` either. As for every removal in the extended analysis, the pair is reported as a discrepancy, and the encoding enforces its absence.
4. **Must-sets are untouched** by the main-pass pruning.

## Validation

- **`InferInvariantsTest`** (4 tests): inferred bounds for RC11; the inferred transitive relations (including `[W];loc;[W]`, inverses, `scta & swg`, and that `sr`, `co`, `po` and `[W];po;[R]` are not transitive); bounds become invariants that are not axioms and whose helper relations are not relevant for the semantics; the pass is idempotent.
- **`InvariantBoundsTest`** (5 tests):
  - bounds are read back from the invariants (`fr ⊆ {loc, eco}`, with only `loc` usable in the main pass);
  - Native and Lazy never relate non-aliasing events in `fr`, `rf` or `co` on the example program;
  - `may(R) ⊆ may(T)` holds for all invariants after the extended analysis, on RC11 and VMM;
  - an invariant added by hand (`rf;rf^-1 ⊆ id`, standing in for a future pass) prunes `rf;rf^-1` in the extended analysis;
  - the `RelationEventDomains` regression.
- **`RelationAnalysisTest`** (Native and Lazy produce identical knowledge): 40 of 40 pass.
- **Litmus tests** (`Litmus*Test`, SMT and CAAT solvers): 85,378 tests, 0 failures, 0 errors, 7,935 skipped.

## Encoded edges

**Setup:**

- **Programs:** the 9 programs of `.github/performance-benchmarks.yml`.
- **Models and targets:** `rc11.cat`/`c11`, `c11.cat`/`c11`, `vmm.cat`/`c11`, `aarch64.cat`/`arm8`, `power.cat`/`power`, `tso.cat`/`tso`, `riscv.cat`/`riscv`.
- **Bounds:** the bound given in the benchmark selection for that configuration; for configurations not in the selection, the bound of the program's `vmm.cat` configuration (or the default if it has none).
- **Metric:** the `#Encoded edges` count that `WmmEncoder` reports. Each run stopped right after encoding, without solving. All 126 runs finished.

Each cell shows `development → this branch`. Increases are in **bold**.

| Benchmark | RC11 | C11 | VMM | ARMv8 | Power | TSO | RISC-V |
|---|---:|---:|---:|---:|---:|---:|---:|
| `locks/cna.c` | 33,525 → 30,519 (−9.0%) | 70,700 → 69,848 (−1.2%) | 50,133 → 48,405 (−3.4%) | 18,248 → 16,058 (−12.0%) | 202,044 → 194,901 (−3.5%) | 14,609 → 13,265 (−9.2%) | 11,717 → 10,943 (−6.6%) |
| `locks/linuxrwlock.c` | **14,208 → 14,232 (+0.2%)** | 19,364 (=) | 22,781 (=) | 12,648 (=) | 18,610 (=) | 10,394 (=) | 7,571 (=) |
| `locks/mutex_musl.c` | 32,079 → 31,737 (−1.1%) | 58,805 (=) | 53,637 (=) | 52,502 (=) | 78,894 (=) | 17,864 (=) | 14,243 (=) |
| `lfds/dglm.c` | 33,992 → 33,496 (−1.5%) | 70,968 (=) | 44,989 (=) | 27,106 (=) | 29,309 → 29,307 (−2 edges) | 11,627 (=) | 8,653 (=) |
| `lfds/ms.c` | 39,488 → 38,774 (−1.8%) | 78,682 (=) | 51,507 (=) | 18,711 (=) | 47,553 (=) | 14,828 (=) | 10,733 (=) |
| `lfds/treiber.c` | 30,682 → 29,840 (−2.7%) | 51,643 (=) | 35,841 (=) | 18,042 (=) | 58,559 (=) | 14,214 (=) | 10,155 (=) |
| `lfds/safe_stack.c` | 25,165 → 25,144 (−0.1%) | 40,309 (=) | 17,752 (=) | 8,087 (=) | **135,984 → 136,229 (+0.2%)** | 6,894 (=) | 5,146 (=) |
| `challenging/cna.c` | 83,942 → 80,942 (−3.6%) | 134,400 → 133,044 (−1.0%) | 67,823 → 65,411 (−3.6%) | 57,373 → 53,653 (−6.5%) | 573,657 → 566,489 (−1.2%) | 22,545 → 20,697 (−8.2%) | 15,181 → 14,125 (−7.0%) |
| `challenging/wsq.c` | 236,990 → 197,413 (−16.7%) | 280,837 → 264,853 (−5.7%) | 160,178 → 135,754 (−15.2%) | 93,129 → 67,537 (−27.5%) | 1,091,063 → 1,027,298 (−5.8%) | 68,962 → 48,462 (−29.7%) | 79,085 → 60,182 (−23.9%) |

**Totals** over the 63 configurations: 4,726,360 → 4,477,870 encoded edges (**−5.3%**). 27 configurations shrink, 34 are unchanged and 2 grow.

**Observations:**

- **Where the largest reductions are:** programs with ambiguous pointers, where may-alias is imprecise. `challenging/wsq`, `challenging/cna` and `locks/cna` shrink on every model, by up to −29.7%.
- **Which model benefits most:** RC11, where 8 of 9 programs shrink. Its `eco = (rf | co | fr)+` and `hb = (po | sw)+` are transitive bounds of many relations, and the extended analysis prunes them through the coherence axioms.
- **Scope relations:** none of these models uses them, so the fixed-level scope relations do not affect these numbers. They matter for PTX and Vulkan.
- **Why running times aren't reported:** encoding size is a more reliable indicator than running time, which varies between runs even for identical encodings.

## Cases where the encoding grows

| Configuration | Change |
|---|---|
| `locks/linuxrwlock` on RC11 | +24 edges (+0.2%) |
| `lfds/safe_stack` on Power | +245 edges (+0.2%) |

**Cause.** The encoder encodes two kinds of pairs: the pairs the axioms need (the active sets), and every *discrepancy*, i.e., a pair the analysis removed from a relation although the relation's operands could still produce it. A discrepancy is encoded together with the operand edges that could produce it, so that the encoding can rule it out.

- **Main-pass pruning can never increase the encoding.** The pairs it removes are not discrepancies.
- **Extended-pass pruning can.** The pairs it removes are discrepancies. If no axiom ever needed such a pair, it would not have been encoded at all without the change.

An earlier measurement with the extended-pass pruning switched off showed no configuration growing, which supports this explanation. It was not repeated for these two cases.

## Follow-ups

- **`co` as a transitive bound.** For architectures with total coherence, `co` is transitive in the integer-clock encoding. The default SAT encoding (`useSATEncoding = true`) only adds `co(x,y) ∧ co(y,z) ⇒ co(x,z)` when `(x,z)` is a may-pair that is not a must-pair, and so admits a `co` cycle in which `co(x,z)` is false: for example, `must(z,x)`, `may(x,y)` and `may(y,z)` hold, but `may(z,y)` and `may(y,x)` do not. Closing this gap would allow `co` as a bound for architectures with total coherence; the pass would also need to know the target architecture.
- **Increases from the extended pass.** Restrict the extended-pass pruning to pairs that some axiom needs, so that it never introduces new discrepancies.
- **More invariants.** The mechanism supports any kind of invariant; the analysis currently interprets `empty R \ T` in the main pass and every invariant in the extended pass.
