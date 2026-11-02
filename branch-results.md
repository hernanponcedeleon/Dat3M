# `agentic/wmm-rewrite`: memory-model rewriting passes

This branch adds two passes to the memory-model preprocessing pipeline. They rewrite a `.cat` model into an
equivalent model that is cheaper to encode:

1. **`EliminateRecursion`** replaces `let rec` definitions with non-recursive definitions built from union,
   composition and transitive closure, when it can.
2. **`SimplifyClosures`** removes transitive closures that are semantically redundant. This covers closures of
   relations that are already transitive, and closures inside `acyclic` and `irreflexive` axioms.

Both passes are *exact*: the rewritten model allows exactly the same executions as the original one.

## Changes

| File | Change |
|---|---|
| `wmm/processing/EliminateRecursion.java` | New pass that solves recursive relation definitions (see below). |
| `wmm/processing/SimplifyClosures.java` | New pass that removes redundant closures (see below). |
| `wmm/processing/WmmProcessingManager.java` | Runs the new passes first: `EliminateRecursion`, `SimplifyClosures`, then the existing `RemoveDeadRelations`, `MergeEquivalentRelations`, `FlattenAssociatives` and `MarkFreeRelations`. Each new pass can be switched off. |
| `configuration/OptionNames.java` | New options `wmm.processing.eliminateRecursion` and `wmm.processing.simplifyClosures`. Both default to `true`. |
| `task/SMTModelChecker.java` | Builds the `WmmProcessingManager` from the task configuration, so the new options take effect. |
| `wmm/Relation.java` | New method `clearRecursive()`, used once a relation's recursion has been eliminated. |
| `wmm/processing/MergeEquivalentRelations.java` | **Bug fix:** two relations are compared only if they have the same number of dependencies. Without this check, `Union(a)` and `Union(a, b)` were treated as equivalent. The bug existed before this branch, but only shows up once single-operand unions exist, and the new passes create them. It caused 114 PPC litmus failures before it was fixed. |
| `cat/aarch64.cat` | Restores the upstream (recursive) definition `let rec ob = obs;si \| lob \| haz-ob \| ob;ob` with `irreflexive ob`. This reverts the hand optimisation from f8db7e023 and ecab7411. The new passes now produce the optimised form automatically. |
| `test/.../WmmRewritingTest.java` | 10 new tests (see [Testing](#testing)). |

## `EliminateRecursion`

### What it does

A group of mutually recursive relations that only uses `|` and `;` is a context-free grammar:

- the recursive relations are the nonterminals;
- the non-recursive relations they use are the terminals.

The least fixpoint assigns each recursive relation the union over every word of its language, where a word is read
as the composition of its letters. If that language is regular, the recursion can be replaced by a regular
expression over `|`, `;` and `+`/`*`.

Whether a context-free language is regular is undecidable in general. The pass therefore detects three sufficient
syntactic shapes and leaves any other recursion untouched:

| Shape | System | Least solution |
|---|---|---|
| Right-linear | `X_i = c_i \| ⋃_j a_ij;X_j` | `X = A*;c` |
| Left-linear | `X_i = c_i \| ⋃_j X_j;b_ji` | `X = c;B*` |
| Matrix | the `n = k²` variables, arranged as a `k×k` matrix `M`, satisfy `M = C \| A;M \| M;B \| M;K;M` | `M = A*;C;(B \| K;A*;C)*` |

- The matrix case covers the `ppo` definition of Power, with `M = [[ii, ic], [ci, cc]]`. In that model, `ii;ii`,
  `cc;cc`, `ic;cc`, … are the `M;K;M` terms with `K = id`.
- Matrix stars are computed with Kleene's algorithm. When the pivot is involved, special cases produce `R+`
  directly instead of `R ∪ R;R*;R`, so later passes can recognise closures.
- An algebraic simplifier keeps the resulting expressions small. Examples: `x | x+ = x+`, `x;x* = x+`,
  `(id | x)+ = id | x+`.
- The result is materialised as new relations, and each recursive relation is redefined as a non-recursive union
  that points to them. Names, axioms and outside references are unaffected.

Bounds prevent blow-ups: at most 1000 words per definition, and `k ≤ 3` for the matrix case. When a bound is hit,
the pass skips that group and logs `Could not eliminate recursion in …`.

### Why it is sound

- **Grammar extraction is exact.** Each recursive relation's definition is unfolded through union and
  composition. Non-variable relations inside the SCC are inlined, and relations defined as empty contribute no
  words. Any other operator inside the SCC (intersection, difference, closure, …) makes the pass give up on that
  SCC.
  - The pass also drops trivial self-productions `X = … | X`, which never change a least fixpoint.
- **The shape check is exact, not approximate.** For the matrix case, the pass tries every placement of the
  variables into the matrix cells (at most 9!). Each word is classified into `C`, `A`, `B` or `K`. The pass then
  rebuilds the complete word set of `C | A;M | M;B | M;K;M` and checks that it *equals* the extracted grammar. A
  rewrite happens only if this check succeeds, so a solution is never applied to a system it does not describe.
- **The closed forms are standard.**
  - The linear cases are Arden's lemma, lifted to matrices: the least solution of `X = A;X | c` is `A*;c` in any
    Kleene algebra, and binary relations under `∪`, `;`, `*` form one.
  - For the matrix case, a derivation tree of `M = C | A;M | M;B | M;K;M` is read left to right:
    1. a block `A*;C`;
    2. followed by any number of steps, each either `B` or `K;A*;C`.

    This is exactly the language `A*;C;(B | K;A*;C)*`. The other direction holds because every word of that
    expression can be derived from the system.
- **The semantics are checked, not just the syntax.** The tests evaluate the original recursive model (by
  least-fixpoint iteration) and the rewritten model on 200 random finite relation interpretations. They check that
  both give identical results.

## `SimplifyClosures`

### Rule 1: closures of transitive relations

If `R` is transitive, then `R+ = R` and `R* = R?`. The closure is replaced by `R`.

Transitivity is detected syntactically. The check is sound but incomplete. `R` counts as transitive if it is:

- a transitive closure, or `po`;
- an intersection of transitive relations;
- a composition `A;B*` or `A;B+` (or the mirrored `B*;A`, `B+;A`) where `A ⊆ B+` can be shown syntactically.
  - Proof: `(A;B*);(A;B*) ⊆ A;B*;B+;B* ⊆ A;B*`.
  - `A ⊆ B+` is shown structurally. `A` is a union operand of `B`; or `A` is a union, composition or closure of
    parts that are each `⊆ B+`; or `A` is an intersection with at least one such operand; or `A` is a difference
    whose minuend is such a part.

**Power example:** `propbase = (fence | rfe;fence);hb*` with `hb = ppo | fence | rfe`.

- `fence` is an operand of `hb`, and `rfe;fence ⊆ hb;hb ⊆ hb+`, so `propbase` is transitive.
- Therefore `propbase*` in `prop = … | (com*;propbase*;sync;hb*)` becomes `propbase?`.
- This removes the most expensive closure in the Power model.

### Rule 2: closures inside acyclicity and irreflexivity axioms

| Original | Rewritten | Why it is equivalent |
|---|---|---|
| `acyclic R+` | `acyclic R` | A cycle in `R+` unfolds into a cycle in `R`, and every cycle in `R` is also a cycle in `R+`. |
| `acyclic A \| R+` | `acyclic A \| R` | Same argument: each `R+` edge on a cycle unfolds into `R` edges. Applied recursively over unions. |
| `irreflexive R+` | `acyclic R` | `(e,e) ∈ R+` holds exactly when there is an `R`-cycle through `e`. |

The rewritten axiom keeps its name, its flagged/negated status and its metadata, so violation reports and
`flag` axioms behave as before.

### Combined effect

The two passes together turn the pattern

```
let rec X = F | X;X
irreflexive X
```

into `acyclic F`:

1. `EliminateRecursion` solves `X = F+`.
2. `SimplifyClosures` turns `irreflexive F+` into `acyclic F`.

This is exactly what commits f8db7e023 and ecab7411 did by hand for `aarch64.cat`. That is why the upstream
version of `aarch64.cat` can now be restored without cost: `WmmRewritingTest.aarch64ObBecomesAcyclicity` checks
that it is rewritten to `acyclic (obs;si | lob | haz-ob)`.

## Testing

`WmmRewritingTest` contains 10 tests, all passing:

| Test | Checks |
|---|---|
| `rightLinear`, `leftLinear` | Linear systems are solved, and the result is semantically equivalent. |
| `ppoMatrixSystem` | The Power-style `2×2` matrix system is solved, and the result is semantically equivalent. |
| `transitiveClosureLike` | A `1×1` system with `X;b;X`, `b;X` and `X;a` terms is solved, and the result is semantically equivalent. |
| `nonRegularIsKept` | The non-regular grammar `X = a \| b;X;c` (language `bⁿ;a;cⁿ`) is left recursive. |
| `powerModelHasNoRecursion` | `power.cat` has no recursive relations after processing. |
| `closureOfTransitiveRelation`, `powerPropbaseClosureIsRemoved` | Rule 1. |
| `irreflexiveRecursiveClosureBecomesAcyclic` | The combined rewrite produces `acyclic F`. |
| `aarch64ObBecomesAcyclicity` | The restored `aarch64.cat` is rewritten to the hand-optimised form. |

The litmus test suites exposed the `MergeEquivalentRelations` bug described above, and the fix included in this
branch resolves it.

## Performance impact

### Setup

- **Benchmarks:** the CI performance-comparison benchmarks, run with the repository's comparison script (eager
  solver, verification time only).
- **Branches:** `development` (f6af468b6) against this branch (37576f384).
- **Build:** JVM jars instead of CI's native binaries.
- **Machine:** shared with other jobs, so treat the absolute times as indicative.
- **How to read the table:** improvement = time saved relative to `development`. ✅ means the 99% confidence
  interval excludes 0; ➖ means the change is within noise.

All verdicts (PASS/UNKNOWN) are identical on both branches.

### Power

| Benchmark | `development` | this branch | Improvement (99% CI) |
|---|---:|---:|---:|
| `lfds/dglm.c` | 8.455 ± 0.037 s | 2.981 ± 0.106 s | ✅ **+64.8%** [+58.5%, +71.0%] |
| `locks/mutex_musl.c` | 23.360 ± 0.369 s | 18.140 ± 0.102 s | ✅ **+22.3%** [+15.6%, +29.1%] |
| `locks/linuxrwlock.c` | 22.248 ± 0.905 s | 20.188 ± 4.011 s | ➖ +9.6% [−75.8%, +94.9%] |
| `lfds/ms.c` | 44.243 ± 3.070 s | 42.365 ± 1.620 s | ➖ +4.1% [−21.7%, +29.8%] |
| `lfds/treiber.c` | 16.669 ± 0.333 s | 16.002 ± 0.509 s | ➖ +4.0% [−9.6%, +17.6%] |

### AArch64

| Benchmark | `development` | this branch | Improvement (99% CI) |
|---|---:|---:|---:|
| `locks/linuxrwlock.c` | 8.437 ± 0.193 s | 8.856 ± 0.453 s | ➖ −5.0% [−38.3%, +28.3%] |
| `locks/mutex_musl.c` | 9.620 ± 0.220 s | 9.640 ± 0.133 s | ➖ −0.3% [−19.3%, +18.8%] |
| `lfds/dglm.c` | 9.268 ± 0.224 s | 9.219 ± 0.219 s | ➖ +0.5% [−10.4%, +11.4%] |
| `lfds/ms.c` | 10.819 ± 0.446 s | 10.225 ± 0.138 s | ➖ +5.3% [−24.2%, +34.9%] |
| `challenging/cna.c` | 19.663 ± 1.068 s | 18.319 ± 1.250 s | ➖ +6.6% [−47.1%, +60.2%] |
| `challenging/wsq.c` | 14.194 ± 0.173 s | 14.274 ± 0.095 s | ➖ −0.6% [−11.4%, +10.2%] |

### vmm

| Benchmark | `development` | this branch | Improvement (99% CI) |
|---|---:|---:|---:|
| `locks/cna.c` | 8.426 ± 0.223 s | 8.057 ± 0.536 s | ➖ +4.3% [−35.5%, +44.2%] |
| `locks/mutex_musl.c` | 22.286 ± 0.290 s | 21.924 ± 0.105 s | ➖ +1.6% [−6.9%, +10.1%] |
| `lfds/dglm.c` | 32.691 ± 0.722 s | 32.585 ± 0.783 s | ➖ +0.3% [−9.1%, +9.7%] |
| `lfds/ms.c` | 51.718 ± 1.338 s | 51.759 ± 1.651 s | ➖ −0.1% [−4.5%, +4.3%] |
| `lfds/treiber.c` | 11.414 ± 1.365 s | 11.534 ± 0.812 s | ➖ −1.6% [−46.6%, +43.5%] |
| `lfds/safe_stack.c` | 7.687 ± 0.098 s | 7.838 ± 0.077 s | ➖ −2.0% [−7.7%, +3.7%] |
| `challenging/cna.c` | 30.272 ± 1.035 s | 31.030 ± 0.236 s | ➖ −2.6% [−20.9%, +15.8%] |

### Total

| | `development` | this branch | Improvement (99% CI) |
|---|---:|---:|---:|
| All 18 configurations | 351.469 ± 6.039 s | 334.936 ± 6.722 s | ➖ +4.7% [−0.3%, +9.7%] |

### Interpretation

- **Power.** Both statistically significant improvements are on Power, and the other three Power benchmarks also
  trend faster.
  - The speedup comes from Rule 1 (`propbase*` → `propbase?`), not from removing the `ppo` recursion.
  - Dat3M's eager encoding of a transitive closure adds an auxiliary variable for each pair it may relate, plus
    the constraints that link them. `propbase*` was the largest closure in the Power encoding.
  - A separate experiment compared the recursive `ppo`, the pass's output, and a hand-written non-recursive
    `ppo`. It found no measurable difference between them. Recursion as such is not an encoding cost in Dat3M.
- **AArch64.** No change, as intended. The restored upstream `aarch64.cat` is rewritten to the same form as the
  previous hand-optimised model.
- **vmm.** No change. The passes find little to rewrite in it.
- **Regressions:** none significant.

## Possible follow-ups (not implemented)

A survey of the `.cat` files in `cat/` found further candidate rewrites. Each has caveats:

- **Coherence closure.** `(rf | co | fr)+` can be expanded to a closed form.
  - This requires `co` to be total and transitive, which does not hold for PTX or Vulkan.
  - It also requires the standard definition of `fr`.
  - It needs care with RMW events that carry both the `R` and `W` tags.
- **Vacuous axioms**, such as `irreflexive (X \ id)` in `opencl.cat`.
- **Splitting `irreflexive A;B?`** into `irreflexive A;B` ∧ `irreflexive A`.
- **Transitivity implied by axioms**, for example Vulkan's `asmo`.
