package com.dat3m.dartagnan.wmm.processing;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.definition.*;

import java.util.*;

/*
    Syntactically infers, for every relation R of a memory model, a set of transitive relations T
    (called the "transitive bounds" of R) such that R is contained in T in every model of the encoding,
    independently of the axioms of the model. InferInvariants turns them into invariants.

    Soundness requirement:
        "Transitive" means transitive in every model of the encoding *without* the axioms, i.e., in every
        execution of the anarchic semantics, and not only in consistent executions. Invariants are not encoded,
        and the pairs they remove from may-sets are not encoded either. If T were only transitive in consistent
        executions, a pruned pair could be exactly the one an axiom needs to reject an inconsistent execution,
        and the reasoning would be circular.
        Each rule below therefore relies on how the relation is encoded, not on the axioms of the model.

    Motivation:
        The relation analysis over-approximates a composition r1;r2 by may(r1);may(r2).
        If r1 and r2 are both contained in a transitive relation T, then so is r1;r2 (as T;T is contained in T).
        However, the may-set of T computed by the analysis need not be transitive (e.g. may-alias for loc is not),
        so may(r1);may(r2) may contain pairs that are not in may(T). Those pairs can safely be removed.

    Transitive relations (least fixed point of the following rules):
        - loc, int, the same-instruction relation, and the same-scope relations of a fixed scope level
          (e.g. scta, swg). Their edges are encoded as "both events execute" plus an equivalence on
          addresses / threads / instructions / scope ids, so they are transitive in every model of the encoding.
        - every transitive closure X+,
        - every intersection of transitive relations,
        - the inverse of a transitive relation,
        - A;T and T;B where T is transitive and A, B ⊆ ID (e.g. [W];loc;[W]):
          x A;T y A;T z implies x A x T y T z, hence x A;T z.
    Relations contained in ID (sets) are trivially transitive, but they are not used as bounds.
    NOTE: co is deliberately excluded. It is transitive in consistent executions, but not in every model of
          the encoding: its encoding does not enforce transitivity for architectures with non-total coherence,
          and the SAT encoding only enforces it partially.
    NOTE: The same-scope relation without a fixed scope level (sr) is not transitive.

    Containment rules (with ID denoting "contained in the identity relation", e.g. [W],
    which is computed separately as a greatest fixed point):
        Base facts:   rf, co ⊆ loc     po ⊆ int     sets ⊆ ID     empty ⊆ everything
        Syntax:       X ⊆ X+           every operand of a union is contained in the union
        A | B:        bounds(A) ∩ bounds(B)
        A & B:        bounds(A) ∪ bounds(B)
        A \ B:        bounds(A)
        A+:           bounds(A)                                (A ⊆ T and T transitive => A+ ⊆ T)
        A^-1:         symmetric bounds of A
        A ; B:        T if (A ⊆ T or A ⊆ ID) and (B ⊆ T or B ⊆ ID) and (A ⊆ T or B ⊆ T)

    For recursively defined relations we compute the greatest fixed point, starting from the assumption that
    every relation is contained in every bound. This is sound: the semantics of a recursive relation is the
    least fixed point of a monotone function, i.e., the limit of a chain starting at the empty relation,
    and each rule preserves containment in (the final value of) every transitive relation.
 */
final class TransitiveBounds {

    // Relations contained in the identity relation (e.g. sets).
    private final Set<Relation> idBounded;
    private final Set<Relation> transitive = new HashSet<>();
    private final Set<Relation> symmetric = new HashSet<>();
    private final Map<Relation, Set<Relation>> bounds = new HashMap<>();

    private TransitiveBounds(Set<Relation> idBounded) {
        this.idBounded = idBounded;
    }

    static TransitiveBounds compute(Collection<Relation> relations) {
        final TransitiveBounds result = new TransitiveBounds(computeIdBounded(relations));
        result.computeTransitiveRelations(relations);
        result.computeBounds(relations);
        return result;
    }

    /*
        Returns all transitive relations (other than r itself) that contain r.
     */
    Set<Relation> getBounds(Relation r) {
        final Set<Relation> result = new HashSet<>(bounds.getOrDefault(r, Set.of()));
        result.remove(r);
        return result;
    }

    boolean isTransitive(Relation r) {
        return transitive.contains(r);
    }

    // ==============================================================================================================

    private void computeTransitiveRelations(Collection<Relation> relations) {
        for (Relation r : relations) {
            final Definition def = r.getDefinition();
            if (def instanceof SameLocation || def instanceof Internal || def instanceof SameInstruction
                    || def instanceof SameScope scope && scope.getSpecificScope() != null) {
                transitive.add(r);
                symmetric.add(r);
            } else if (def instanceof TransitiveClosure && !idBounded.contains(r)) {
                transitive.add(r);
            }
        }
        // Least fixed point
        boolean changed = true;
        while (changed) {
            changed = false;
            for (Relation r : relations) {
                if (idBounded.contains(r)) {
                    continue;
                }
                final Definition def = r.getDefinition();
                if (!transitive.contains(r) && isTransitive(def)) {
                    transitive.add(r);
                    changed = true;
                }
                if (!symmetric.contains(r) && transitive.contains(r) && isSymmetric(def)) {
                    symmetric.add(r);
                    changed = true;
                }
            }
        }
    }

    private boolean isTransitive(Definition def) {
        if (def instanceof Intersection inter) {
            return inter.getOperands().stream().allMatch(transitive::contains);
        } else if (def instanceof Inverse inv) {
            return transitive.contains(inv.getOperand());
        } else if (def instanceof Composition comp) {
            final Relation left = comp.getLeftOperand();
            final Relation right = comp.getRightOperand();
            return (idBounded.contains(left) && transitive.contains(right))
                    || (transitive.contains(left) && idBounded.contains(right));
        }
        return false;
    }

    private boolean isSymmetric(Definition def) {
        if (def instanceof Intersection inter) {
            return inter.getOperands().stream().allMatch(symmetric::contains);
        } else if (def instanceof Inverse inv) {
            return symmetric.contains(inv.getOperand());
        }
        return false;
    }

    /*
        Relations contained in the identity relation (greatest fixed point).
     */
    private static Set<Relation> computeIdBounded(Collection<Relation> relations) {
        final Set<Relation> result = new HashSet<>(relations);
        boolean changed = true;
        while (changed) {
            changed = false;
            for (Relation r : relations) {
                if (result.contains(r) && !isIdBounded(r, result)) {
                    result.remove(r);
                    changed = true;
                }
            }
        }
        return result;
    }

    private static boolean isIdBounded(Relation r, Set<Relation> idBounded) {
        if (r.isSet()) {
            return true;
        }
        final Definition def = r.getDefinition();
        if (def instanceof Empty || def instanceof SetIdentity) {
            return true;
        } else if (def instanceof Union union) {
            return idBounded.containsAll(union.getOperands());
        } else if (def instanceof Intersection inter) {
            return inter.getOperands().stream().anyMatch(idBounded::contains);
        } else if (def instanceof Difference diff) {
            return idBounded.contains(diff.getMinuend());
        } else if (def instanceof TransitiveClosure trans) {
            return idBounded.contains(trans.getOperand());
        } else if (def instanceof Inverse inv) {
            return idBounded.contains(inv.getOperand());
        } else if (def instanceof Composition comp) {
            return idBounded.contains(comp.getLeftOperand()) && idBounded.contains(comp.getRightOperand());
        }
        return false;
    }

    private void computeBounds(Collection<Relation> relations) {
        final Set<Relation> top = Set.copyOf(transitive);
        final Map<Relation, Set<Relation>> facts = computeSyntacticFacts(relations);
        for (Relation r : relations) {
            bounds.put(r, new HashSet<>(top));
        }
        // Greatest fixed point
        boolean changed = true;
        while (changed) {
            changed = false;
            for (Relation r : relations) {
                final Set<Relation> current = bounds.get(r);
                final Set<Relation> next = applyRule(r, top);
                next.addAll(facts.getOrDefault(r, Set.of()));
                next.retainAll(current);
                if (next.size() != current.size()) {
                    bounds.put(r, next);
                    changed = true;
                }
            }
        }
    }

    private Set<Relation> applyRule(Relation r, Set<Relation> top) {
        final Set<Relation> result = new HashSet<>();
        final Definition def = r.getDefinition();
        if (def instanceof Empty) {
            result.addAll(top);
        } else if (def instanceof Union union) {
            final List<Relation> ops = union.getOperands();
            final Set<Relation> inter = new HashSet<>(bounds.get(ops.getFirst()));
            ops.forEach(op -> inter.retainAll(bounds.get(op)));
            result.addAll(inter);
        } else if (def instanceof Intersection inter) {
            inter.getOperands().forEach(op -> result.addAll(bounds.get(op)));
        } else if (def instanceof Difference diff) {
            result.addAll(bounds.get(diff.getMinuend()));
        } else if (def instanceof TransitiveClosure trans) {
            result.addAll(bounds.get(trans.getOperand()));
        } else if (def instanceof Inverse inv) {
            for (Relation b : bounds.get(inv.getOperand())) {
                if (symmetric.contains(b)) {
                    result.add(b);
                }
            }
        } else if (def instanceof Composition comp) {
            final Set<Relation> left = bounds.get(comp.getLeftOperand());
            final Set<Relation> right = bounds.get(comp.getRightOperand());
            final boolean leftId = idBounded.contains(comp.getLeftOperand());
            final boolean rightId = idBounded.contains(comp.getRightOperand());
            for (Relation t : transitive) {
                final boolean inLeft = left.contains(t);
                final boolean inRight = right.contains(t);
                if ((inLeft || leftId) && (inRight || rightId) && (inLeft || inRight)) {
                    result.add(t);
                }
            }
        }
        return result;
    }

    /*
        Facts that hold independently of the fixed-point computation:
            - base relations contained in transitive base relations (rf, co ⊆ loc and po ⊆ int),
            - each transitive relation T contains every relation that is syntactically below it,
              i.e., reachable from T by descending into union operands and closure operands.
     */
    private Map<Relation, Set<Relation>> computeSyntacticFacts(Collection<Relation> relations) {
        final Map<Relation, Set<Relation>> facts = new HashMap<>();
        final List<Relation> locs = relations.stream().filter(r -> r.getDefinition() instanceof SameLocation).toList();
        final List<Relation> ints = relations.stream().filter(r -> r.getDefinition() instanceof Internal).toList();
        for (Relation r : relations) {
            final Definition def = r.getDefinition();
            if (def instanceof ReadFrom || def instanceof Coherence) {
                facts.computeIfAbsent(r, k -> new HashSet<>()).addAll(locs);
            } else if (def instanceof ProgramOrder) {
                facts.computeIfAbsent(r, k -> new HashSet<>()).addAll(ints);
            }
        }
        for (Relation t : transitive) {
            for (Relation below : getSyntacticallyBelow(t)) {
                facts.computeIfAbsent(below, k -> new HashSet<>()).add(t);
            }
        }
        return facts;
    }

    private static Set<Relation> getSyntacticallyBelow(Relation r) {
        final Set<Relation> result = new HashSet<>();
        final Deque<Relation> workList = new ArrayDeque<>(List.of(r));
        while (!workList.isEmpty()) {
            final Relation next = workList.pop();
            if (!result.add(next)) {
                continue;
            }
            if (next.getDefinition() instanceof Union union) {
                workList.addAll(union.getOperands());
            } else if (next.getDefinition() instanceof TransitiveClosure trans) {
                workList.add(trans.getOperand());
            }
        }
        return result;
    }
}
