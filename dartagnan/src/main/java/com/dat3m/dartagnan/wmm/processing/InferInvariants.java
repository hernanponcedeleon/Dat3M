package com.dat3m.dartagnan.wmm.processing;

import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Emptiness;
import com.dat3m.dartagnan.wmm.definition.Difference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;

/*
    Adds invariants to the memory model, i.e., axioms that hold in every execution of the anarchic semantics.
    Invariants are not encoded, they are only used by the relation analysis to compute more precise knowledge.

    Inferred invariants:
        - "invariant empty R \ T" (i.e. R ⊆ T) for every relation R and every transitive relation T
          that syntactically contains R (see TransitiveBounds).
          The relation analysis uses them to remove pairs of may(R) that are not in may(T).

    NOTE: This pass should run after all passes that remove or merge relations,
          because the invariants it adds would otherwise keep dead relations alive.
 */
public class InferInvariants implements WmmProcessor {

    private static final Logger logger = LoggerFactory.getLogger(InferInvariants.class);

    private InferInvariants() {}

    public static InferInvariants newInstance() {
        return new InferInvariants();
    }

    @Override
    public void run(Wmm wmm) {
        // Helper relations of existing invariants are ignored, so running the pass again adds nothing.
        // The relevant relations are closed under dependencies, so their definitions are fully known.
        final Set<Relation> relevant = wmm.getRelationsRelevantForSemantics();
        final List<Relation> relations = wmm.getRelations().stream().filter(relevant::contains).toList();
        final Map<Relation, Integer> order = new HashMap<>();
        relations.forEach(r -> order.put(r, order.size()));
        final Set<List<Relation>> existing = new HashSet<>();
        for (Axiom inv : wmm.getInvariants()) {
            if (inv instanceof Emptiness && !inv.isNegated() && inv.getRelation().getDefinition() instanceof Difference d) {
                existing.add(List.of(d.getMinuend(), d.getSubtrahend()));
            }
        }

        final TransitiveBounds bounds = TransitiveBounds.compute(relations);
        int count = 0;
        for (Relation r : relations) {
            final List<Relation> sortedBounds = bounds.getBounds(r).stream()
                    .sorted(Comparator.comparing(order::get))
                    .toList();
            for (Relation t : sortedBounds) {
                if (existing.add(List.of(r, t))) {
                    final Relation diff = wmm.addDefinition(new Difference(wmm.newRelation(), r, t));
                    wmm.addConstraint(new Emptiness(diff, false, false, true));
                    count++;
                }
            }
        }
        logger.debug("Inferred {} invariants", count);
    }
}
