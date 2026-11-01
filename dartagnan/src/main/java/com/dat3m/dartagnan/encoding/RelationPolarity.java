package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.definition.*;

import java.util.*;

/*
    Computes in which direction the encoding of a memory model depends on its relations.
    A relation is used negatively if adding edges to it can never help to satisfy the encoding:
    it occurs (transitively) only under non-negated acyclicity/irreflexivity/emptiness axioms,
    or as the subtrahend of a difference that is used positively.
    Flagged axioms are treated like the others: their violation is encoded as the axiom holding.
 */
final class RelationPolarity {

    private static final int POSITIVE = 1;
    private static final int NEGATIVE = 2;

    private RelationPolarity() { }

    // Returns the transitive closures whose edges are used negatively only.
    static Set<Relation> getNegativelyUsedClosures(Wmm memoryModel) {
        final Map<Relation, Integer> polarity = new HashMap<>();
        final Deque<Relation> workList = new ArrayDeque<>();
        for (Constraint c : memoryModel.getConstraints()) {
            if (c instanceof Axiom axiom) {
                add(polarity, workList, axiom.getRelation(), axiom.isNegated() ? POSITIVE : NEGATIVE);
            } else if (!(c instanceof Definition)) {
                // E.g. assumptions: be conservative
                c.getConstrainedRelations().forEach(r -> add(polarity, workList, r, POSITIVE | NEGATIVE));
            }
        }
        while (!workList.isEmpty()) {
            final Relation rel = workList.pop();
            final int pol = polarity.get(rel);
            final Definition def = rel.getDefinition();
            final List<Relation> operands = def.getConstrainedRelations().subList(1, def.getConstrainedRelations().size());
            for (int i = 0; i < operands.size(); i++) {
                final int operandPolarity;
                if (isMonotone(def)) {
                    operandPolarity = pol;
                } else if (def instanceof Difference) {
                    operandPolarity = i == 0 ? pol : flip(pol);
                } else {
                    operandPolarity = POSITIVE | NEGATIVE;
                }
                add(polarity, workList, operands.get(i), operandPolarity);
            }
        }

        final Set<Relation> closures = new HashSet<>();
        polarity.forEach((rel, pol) -> {
            if (pol == NEGATIVE && rel.getDefinition() instanceof TransitiveClosure) {
                closures.add(rel);
            }
        });
        return closures;
    }

    private static boolean isMonotone(Definition def) {
        return def instanceof Union || def instanceof Intersection || def instanceof Composition
                || def instanceof Inverse || def instanceof TransitiveClosure || def instanceof Projection
                || def instanceof SetIdentity || def instanceof CartesianProduct;
    }

    private static int flip(int pol) {
        return ((pol & POSITIVE) != 0 ? NEGATIVE : 0) | ((pol & NEGATIVE) != 0 ? POSITIVE : 0);
    }

    private static void add(Map<Relation, Integer> polarity, Deque<Relation> workList, Relation rel, int pol) {
        final int old = polarity.getOrDefault(rel, 0);
        if ((old | pol) != old) {
            polarity.put(rel, old | pol);
            workList.push(rel);
        }
    }
}
