package com.dat3m.dartagnan.wmm.utils;

import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.google.common.base.Preconditions;
import com.google.common.collect.Sets;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

/*
    A cut C of a memory model is a partition (L, U) of the relations and constraints such that:
        (1) For every relation r:     r in L   =>   defConstraint(r) in L
        (2) For every constraint c:   c in L   =>   constrainedRels(c) \subset L.

    NOTE 1: For recursively defined relations, if one of them is in L then all are in L.
    NOTE 2: A cut can be represented by just a partition of the constraints since the relation partition can be
            computed from the defining constraints.

    PROPOSITION 1: For every set of relations and constraints RC of a memory model, there is a unique cut C
                   such that RC \subset L(C) and L(C) is minimal.
    PROOF: We saturate the set RC to RC' using the left-to-right implications from conditions (1) and (2).
           Claim: The partition (RC', MM \ RC) is a cut C.
           By construction, it must satisfy properties (1)/(2) and L(C) contains RC.
           Furthermore, L(C) it is also minimal by construction via saturation (least-fixed point).

    PROPOSITION 2: For every cut C = (L, U) and every non-defining constraint c with constrainedRels(c) \subset L,
                   C' = (L + c, U - c) and C'' = (L - c, U + c) are also cuts.
    PROOF: Trivial.

    COROLLARY: For every cut C with lower relations R, there are constraint-minimal/maximal cuts C'/C'' with the
               same lower relations R.

    DEF: The boundary B(C) of a cut C consists of the relations in L(C) that are constrained by some constraint
    in U(C).
 */
// WARNING: A cut stays only valid as long as the memory model is not modified!
public class Cut {
    private final Wmm memoryModel;
    private final Set<Constraint> lower;
    private final Set<Constraint> upper;

    private Cut(Wmm memoryModel, Set<Constraint> lower, Set<Constraint> upper) {
        this.memoryModel = memoryModel;
        this.lower = lower;
        this.upper = upper;
    }

    public Wmm getMemoryModel() { return memoryModel; }
    public Set<Constraint> getLower() { return lower; }
    public Set<Constraint> getUpper() { return upper; }

    public Set<Relation> getLowerRelations() {
        return lower.stream().flatMap(c -> c.getConstrainedRelations().stream()).collect(Collectors.toSet());
    }

    public Set<Relation> getUpperRelations() {
        return upper.stream()
                .filter(Definition.class::isInstance)
                .map(c -> ((Definition) c).getDefinedRelation())
                .collect(Collectors.toSet());
    }

    public Set<Relation> getBoundaryRelations() {
        final Set<Relation> lowerRels = getLowerRelations();
        return upper.stream()
                .flatMap(c -> c.getConstrainedRelations().stream())
                .filter(lowerRels::contains)
                .collect(Collectors.toSet());
    }

    // =========================================================================================================

    public static Cut computeInducedCut(Wmm memoryModel, Collection<? extends Constraint> rootConstraints) {
        final Set<Constraint> constraints = new HashSet<>(memoryModel.getConstraints());
        Preconditions.checkArgument(constraints.containsAll(rootConstraints));
        // Precondition: All constraints are from the same memory model.
        final Set<Constraint> lower = new HashSet<>();
        rootConstraints.forEach(c -> collectLowerConstraints(c, lower));
        final Set<Constraint> upper = new HashSet<>(Sets.difference(constraints, lower));

        return new Cut(memoryModel, lower, upper);
    }

    private static void collectLowerConstraints(Constraint c, Set<Constraint> collector) {
        if (collector.add(c)) {
            for (Relation r : c.getConstrainedRelations()) {
                collectLowerConstraints(r.getDefinition(), collector);
            }
        }
    }
}
