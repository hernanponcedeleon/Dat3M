# Edge aliasing (branch `edge-aliasing`)

## Motivation

The WMM encoding introduces a fresh Boolean variable for every non-trivial edge (may but not must) of every
derived relation, together with a clause that relates it to the relation's definition. This creates long
implication chains from base relations to the relations used in axioms, e.g.

    rf(x, y)          =>  rf^-1(y, x)
    rf^-1(y, x) /\ co(y, z)  =>  fr(x, z)
    ...               =>  hb(...)

Many intermediate variables are equivalent to a single other literal (`rf^-1(y, x) <=> rf(x, y)`).
We know that these variables are never needed by later queries, but the incremental SMT solver cannot
eliminate them by itself, since it must assume that they could be referenced later.

## The change

**Edge aliasing**: if the definition of a derived relation `r` at edge `(e1, e2)` is equivalent to a constant
or a single literal `l`, then `EncodingContext.edge(r)` returns `l` instead of a fresh variable `r(e1, e2)`,
and `WmmEncoder` does not encode the definition clause of that edge. Since all consumers obtain edges via
`EncodingContext.edge()`, the substitution applies everywhere, and chains collapse transitively:

    rf(x, y) /\ co(y, z)  =>  fr(x, z)

This is a pure renaming of variables: no formula is duplicated, and the encoding only gets smaller.

### Files

| File | Change |
|---|---|
| `encoding/EdgeAliasing.java` (new) | Mechanism: computes, per derived relation, the formula an edge can soundly be substituted by. |
| `encoding/EdgeAliasPolicy.java` (new) | Notion of aliasing: decides whether a candidate substitution is applied. Presets `NONE` and `LITERALS`. |
| `encoding/EncodingContext.java` | Option `encoding.wmm.edgeAliasing` (default `LITERALS`); `edge()` returns the alias if there is one; `isAliased()`. |
| `encoding/WmmEncoder.java` | Definition clauses are encoded for `getEncodedSet()` (active set minus aliased edges) instead of `getActiveSet()`; logs `#Aliased edges`. |
| `configuration/OptionNames.java` | `EDGE_ALIASING = "encoding.wmm.edgeAliasing"`. |

### Option

`--encoding.wmm.edgeAliasing=<NONE|LITERALS>`

- `NONE`: no aliasing. Identical to the encoding on `development`.
- `LITERALS` (default): edges whose definition is equivalent to a constant or a literal are substituted.

New notions can be added as further `EdgeAliasPolicy.Preset` values. A policy sees the relation, the edge,
the candidate formula and its shape (constant, literal or other).

### Mechanism (`EdgeAliasing`)

An edge can only be aliased if
- the definition of `r` is encoded (definitions cut by the refinement must stay free variables),
- `r` is not (mutually) recursive and not a transitive closure (termination of the substitution),
- the edge is non-trivial (in the may-set, not in the must-set).

Candidate formulas per definition kind:

| Definition | Candidate for `r(e1, e2)` |
|---|---|
| `r1^-1` | `r1(e2, e1)` |
| `[s]` (set identity) | `s(e1)` if `e1 == e2`, else `false` |
| `s1 * s2` (product) | `s1(e1) /\ s2(e2)` |
| `r1 \| ... \| rn` | the only operand that may contain the edge (`false` if none) |
| `r1 & ... & rn` | the only operand that does not must-contain the edge (`false` if some operand cannot contain it) |
| `r1 \ r2` | `r1(e1, e2)` if `r2` cannot contain the edge |
| `r1 ; r2` | `r1(e1, e) /\ r2(e, e2)` if there is exactly one possible intermediate event `e` (`false` if none) |
| `domain(r1)` / `range(r1)` | the only possible `r1`-edge (`false` if none) |

For compositions and products, a conjunct that is a must-edge (encoded as the execution of its events) is
dropped if the execution of its events is implied by the events of the other conjunct (`ExecutionAnalysis`).
This is what turns e.g. `obs;si` into a single literal. It is exact if the other edge literal implies the
execution of its events (relations encoded as `edge => def`). For over-approximated relations
(`def => edge`) the dropped form is an over-approximation, which is sound because the polarity of the operands
follows the one of the defined relation (cf. the composition optimization in `da545df6c`).

Candidates are evaluated lazily and cached per edge, after `EncodingContext` has stored them. This way
operand edges obtained via `EncodingContext.edge()` are already aliased, and the decision for an edge is
the same in `edge()` and `isAliased()`.

### Why `getEncodedSet()` instead of `getActiveSet()`

For an aliased edge, `EncodingContext.edge()` already returns its definition, so its definition clause would
only relate that formula to itself (e.g. `l <=> l`). `getEncodedSet()` skips these clauses. Aliased edges are
**not** removed from the active set itself: the alias refers to the operand edges, so those must stay active
and keep their definitions encoded.

## What else was tried

1. **Aliasing to small conjunctions** (first prototype). Besides literals, edges whose definition is a
   conjunction (e.g. a composition with a single intermediate event: `r1(e1, e) /\ r2(e, e2)`) were
   substituted by that conjunction.
   - Regression on `locks/linuxrwlock` (aarch64, Z3, bound 4): conflicts went from 201k (no aliasing) to
     379k. The cause was `obs;si` aliased to `obs /\ exec`, which flowed into `ob`, the relation of
     `acyclic ob`. The edge literals of the SAT-based acyclicity encoding became conjunctions, which
     weakens propagation.
   - Fix at the time: never alias relations constrained by an axiom (`linuxrwlock`: 249k conflicts,
     64 s vs 63 s without aliasing).
   - Overall (1 rep, 21 programs, 7 configurations): 0.97x (Z3) and 0.86x (Yices2) on instances solved by
     both settings; 0.94x / 0.95x without `lfds/safe_stack`.
2. **Literal-only aliasing inside the encoder** (independent implementation in a parallel session):
   every `WmmEncoder` visitor checks whether the definition it builds is a single literal, and replaces the
   definition clause by an alias if the edge variable has not been handed out yet (relying on the encoding
   order for soundness). Results were comparable (about 0.90x on both solvers on a 9-program subset), but
   the change is more invasive and depends on the encoding order. It was superseded by this branch.
3. **Comparison of aliasing notions** on this branch (results below):
   - `non_axiom_nodrop`: variant 1 (literals and conjunctions, no axiom relations, no conjunct dropping),
   - `non_axiom`: the same with implied-conjunct dropping,
   - `axiom_literals`: like `non_axiom`, but relations constrained by axioms are aliased to literals,
   - `literals`: only constants and literals, for all relations (the final choice).

   The four variants are within noise of each other. `literals` was chosen because it is the simplest
   (no special case for axiom relations, no formula duplication, cannot interfere with the axiom encodings)
   while being as fast as the best variant on both solvers.

## Performance

### Setup

- Programs: the 21 programs in `benchmarks/locks` (12), `benchmarks/lfds` (6), `benchmarks/challenging` (3),
  compiled to LLVM IR.
- Configurations: `aarch64.cat` (arm8), `riscv.cat` (riscv), `power.cat` (power), `vmm.cat` (c11),
  `rc11.cat` (c11) with the default properties (`program_spec`, `termination`, `cat_spec`), and
  `svcomp.cat` (c11) split into `--property=program_spec` (svcomp-ps) and `--property=cat_spec` (svcomp-cs).
- Bounds: per configuration and program, the smallest bound for which Z3 without aliasing gives PASS/FAIL,
  or a timeout (max. bound 10). The same bounds are used for both solvers.
- Z3: native macOS/arm64, timeout 120 s, 4 runs in parallel.
- Yices2: linux/amd64 Docker container (emulated), timeout 180 s, 3 runs in parallel.
- 2 repetitions per run; times are the faster of the 2 repetitions (the host can only slow runs down).
- Numbers are total times over the instances solved by all variants, ratio vs `none`.
  `lfds/safe_stack` is excluded from the headline numbers: it is a satisfiable instance whose time varies
  5-7x with the solver's random seed (`--solver.randomSeed`).
- No verdict contradictions between any variants or repetitions.

### Comparison of aliasing notions (147 instances x 5 variants x 2 reps per solver)

All ratios vs `none`, without `lfds/safe_stack`:

| | `non_axiom_nodrop` | `non_axiom` | `axiom_literals` | **`literals`** |
|---|---:|---:|---:|---:|
| Z3 | 0.92 | 0.92 | 0.89 | **0.90** |
| Yices2 | 0.92 | 0.96 | 0.95 | **0.91** |

Z3, per configuration:

| config | `none` (s) | `non_axiom_nodrop` | `non_axiom` | `axiom_literals` | `literals` |
|---|---:|---:|---:|---:|---:|
| aarch64 | 213 | 0.88 | 0.86 | 0.88 | 0.92 |
| riscv | 215 | 0.91 | 0.85 | 0.91 | 0.82 |
| power | 146 | 1.04 | 0.93 | 0.96 | 0.92 |
| vmm | 214 | 0.91 | 0.98 | 0.95 | 0.94 |
| rc11 | 300 | 0.93 | 0.95 | 0.91 | 0.96 |
| svcomp-ps | 121 | 0.92 | 0.91 | 0.87 | 0.90 |
| svcomp-cs | 194 | 0.87 | 0.93 | 0.78 | 0.83 |
| **all** (129 instances) | 1404 | 0.92 | 0.92 | 0.89 | **0.90** |

Yices2, per configuration:

| config | `none` (s) | `non_axiom_nodrop` | `non_axiom` | `axiom_literals` | `literals` |
|---|---:|---:|---:|---:|---:|
| aarch64 | 260 | 0.91 | 0.99 | 0.92 | 0.92 |
| riscv | 289 | 0.79 | 0.88 | 0.87 | 0.81 |
| power | 248 | 0.97 | 0.98 | 0.95 | 0.87 |
| vmm | 328 | 0.95 | 1.02 | 1.02 | 0.99 |
| rc11 | 328 | 0.90 | 0.98 | 0.99 | 0.97 |
| svcomp-ps | 172 | 0.97 | 0.95 | 0.99 | 0.96 |
| svcomp-cs | 235 | 0.97 | 0.90 | 0.88 | 0.85 |
| **all** (131 instances) | 1859 | 0.92 | 0.96 | 0.95 | **0.91** |

Notes:
- `literals` is at or below 0.99x in every configuration on both solvers.
- Z3: the aliasing variants with implied-conjunct dropping solve one more instance (power) than `none`.
  Yices2: identical solved counts for all variants.
- Including `lfds/safe_stack`, `literals` gives 0.89x (Z3) and 0.81x (Yices2).
- `locks/linuxrwlock`, the regression of the first prototype, is now faster with aliasing
  (e.g. Z3 rc11 95 s -> 76 s, riscv 102 s -> 76 s).
- Yices2 crashes (out of memory in the container) on power for `challenging/wsq`, `lfds/safe_stack`
  and partly `challenging/cna`, with every variant including `none`.

### Final code: `none` vs `literals`

Rerun of the final code (default `LITERALS` vs `NONE`), same setup, 147 instances x 2 variants x 2 reps.

Z3 (total time in s on instances solved by both, ratio vs `none`; solved counts in parentheses):

| config | #common | `none` | `literals` |
|---|---:|---:|---:|
| aarch64 | 19/20 | 218 (19) | 185 **0.85** (19) |
| riscv | 19/20 | 236 (19) | 185 **0.78** (19) |
| power | 16/20 | 149 (16) | 139 **0.93** (17) |
| vmm | 18/20 | 219 (18) | 205 **0.94** (18) |
| rc11 | 19/20 | 314 (19) | 289 **0.92** (19) |
| svcomp-ps | 19/20 | 128 (19) | 122 **0.95** (19) |
| svcomp-cs | 19/20 | 202 (19) | 168 **0.83** (19) |
| **all** | 129/140 | 1466 (129) | 1293 **0.88** (130) |

Including `lfds/safe_stack`: 0.89x (1653 s -> 1470 s on 134 common instances). No verdict contradictions.
Largest gains: `linuxrwlock` (riscv 114 s -> 76 s, power 118 s -> 96 s, rc11 95 s -> 76 s),
`challenging/cna` (aarch64 51 s -> 33 s, svcomp-cs 62 s -> 42 s), `lfds/ms` (aarch64 27 s -> 19 s).
Largest loss: vmm `lfds/ms` 51 s -> 58 s.

Yices2:

| config | #common | `none` | `literals` |
|---|---:|---:|---:|
| aarch64 | 19/20 | 270 (19) | 238 **0.88** (19) |
| riscv | 19/20 | 267 (19) | 225 **0.84** (19) |
| power | 17/20 | 247 (17) | 218 **0.88** (17) |
| vmm | 19/20 | 323 (19) | 329 **1.02** (19) |
| rc11 | 19/20 | 327 (19) | 324 **0.99** (19) |
| svcomp-ps | 19/20 | 176 (19) | 166 **0.94** (19) |
| svcomp-cs | 19/20 | 246 (19) | 207 **0.84** (19) |
| **all** | 131/140 | 1855 (131) | 1706 **0.92** (131) |

Including `lfds/safe_stack`: 0.84x (2272 s -> 1915 s on 136 common instances; `literals` solves
svcomp-cs `safe_stack`, which times out without aliasing). No verdict contradictions.
Largest gains: `linuxrwlock` (power 102 s -> 75 s, riscv 84 s -> 60 s, svcomp-cs 70 s -> 49 s),
`challenging/cna` (riscv 50 s -> 35 s, svcomp-cs 47 s -> 34 s).
Largest losses: `challenging/cna` on rc11 (73 s -> 88 s) and vmm (96 s -> 105 s).
Unsolved with both settings: `challenging/harris-3` (timeout everywhere except power, where Yices2 returns
UNKNOWN), and on power `challenging/wsq`, `challenging/cna`, `lfds/safe_stack` (Yices2 out of memory / UNKNOWN).

Summary of the final code (ratio vs `none`, min over 2 reps):

| | without `safe_stack` | with `safe_stack` |
|---|---:|---:|
| Z3 | **0.88** | 0.89 |
| Yices2 | **0.92** | 0.84 |

## Testing

- Full `dartagnan` test suite on the final code (`LITERALS` as default): 125,852 tests, 0 failures.
  The only errors (170) are Yices2 being unavailable on macOS.
- During development, with the most aggressive variant (`axiom_literals`) as default:
  litmus suites (AArch64, PPC, RISCV, C11, RC11, Linux, X86, Vulkan, PTX, OpenCL; eager and lazy/CAAT):
  46,928 tests, 0 failures. llvm, asm, spirv suites and `ActiveMustEdgeEncodingTest`: 2,438 tests,
  0 failures (the only errors are Yices2 being unavailable on macOS).
