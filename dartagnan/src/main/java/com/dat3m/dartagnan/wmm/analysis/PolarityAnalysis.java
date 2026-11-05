package com.dat3m.dartagnan.wmm.analysis;

import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.definition.Difference;

import java.util.*;

/*
    The constraints/relations of the Wmm can be categorised into positive and negative,
    depending on whether the number of negations applied to the constraint/relation is even (=positive)
    or odd (=negative).
    Negations come from negated axioms (~empty(r)), RHS of differences (c = a \ b), or
    complementation (Y = ~X). Complementation is just a difference: ~X = _ \ X, so there is no special
    treatment required.
    A relation can be both negative and positive if it is used multiple times,
    once with odd negations and once with even negations.
    It can also be neither, if the relation is dead (i.e., irrelevant for all axioms).

NOTE: Technically, regular axioms should be treated "negatively" since they are forbidding.
      We swap the notion of positive and negative to align with the syntax (no negation = positive)
      rather than the semantics.
*/
public class PolarityAnalysis {

    public enum Polarity {
        UNKNOWN,
        POSITIVE,
        NEGATIVE,
        ALL;
    }

    private final Map<Constraint, Polarity> polarities = new HashMap<>();

    private PolarityAnalysis(Wmm wmm) {
        computePolarities(wmm);
    }

    public static PolarityAnalysis of(Wmm wmm) {
        return new PolarityAnalysis(wmm);
    }

    public Polarity get(Constraint c) {
        return polarities.get(c);
    }

    public Polarity get(Relation r) {
        return polarities.get(r.getDefinition());
    }

    private void computePolarities(Wmm wmm) {
        final Set<Constraint> positives = new HashSet<>();
        final Set<Constraint> negatives = new HashSet<>();

        final Constraint.Visitor<Void> collector = new Constraint.Visitor<>() {
            private boolean polarity = true;

            @Override
            public Void visitAxiom(Axiom axiom) {
                polarity = !axiom.isNegated();
                process(axiom);
                return axiom.getRelation().getDefinition().accept(this);
            }

            @Override
            public Void visitDefinition(Definition def) {
                if (process(def)) {
                    def.getConstrainedRelations().subList(1, def.getConstrainedRelations().size())
                            .forEach(r -> r.getDefinition().accept(this));
                }
                return null;
            }

            @Override
            public Void visitDifference(Difference def) {
                if (process(def)) {
                    def.getMinuend().getDefinition().accept(this);
                    polarity = !polarity;
                    def.getSubtrahend().getDefinition().accept(this);
                    polarity = !polarity;
                }
                return null;
            }

            private boolean process(Constraint c) {
                return (polarity ? positives : negatives).add(c);
            }
        };

        wmm.getAxioms().forEach(ax -> ax.accept(collector));

        for (Constraint c : wmm.getConstraints()) {
            final boolean isNeg = negatives.contains(c);
            final boolean isPos = positives.contains(c);

            // NOTE: Unreachable constraints get UNKNOWN
            final Polarity p = (!isPos && !isNeg) ? Polarity.UNKNOWN
                    : (isPos && isNeg) ? Polarity.ALL
                    : isPos ? Polarity.POSITIVE
                    : Polarity.NEGATIVE;
            polarities.put(c, p);
        }
    }
}
