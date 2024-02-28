package com.dat3m.dartagnan.wmm.processing;

import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.utils.ConstraintCopier;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.IdentityHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.Predicate;

public class MergeEquivalentRelations implements WmmProcessor {

    private static final Logger logger = LogManager.getLogger(MergeEquivalentRelations.class);

    private MergeEquivalentRelations() {
    }

    public static MergeEquivalentRelations newInstance() {
        return new MergeEquivalentRelations();
    }

    @Override
    public void run(Wmm wmm) {
        final Map<Relation, Relation> rel2class = computeEquivalenceClasses(wmm);
        mergeEquivalentRelations(wmm, rel2class);
    }

    private Map<Relation, Relation> computeEquivalenceClasses(Wmm wmm) {
        final Map<Relation, Relation> rel2class = new IdentityHashMap<>();
        final Predicate<Relation> hasNontrivialClass = r -> rel2class.get(r) != r;
        final List<Relation> relations = List.copyOf(wmm.getRelations());
        relations.forEach(r -> rel2class.put(r, r));

        // TODO: Could be done more efficiently by computing equivalence bottom-up along a stratification
        //  and reusing previous equivalence queries.
        //  However, even on large memory models like LKMM, this code takes less than 10ms.
        for (int i = 0; i < relations.size(); i++) {
            final Relation r1 = relations.get(i);
            if (hasNontrivialClass.test(r1)) {
                continue;
            }
            for (int j = i + 1; j < relations.size(); j++) {
                final Relation r2 = relations.get(j);
                if (!hasNontrivialClass.test(r2) && areEquivalent(r1, r2)) {
                    rel2class.put(r2, r1);
                }
            }
        }

        return rel2class;
    }

    private boolean areEquivalent(Relation r1, Relation r2) {
        if (r1 == r2)  {
            return true;
        }
        final Definition def1 = r1.getDefinition();
        final Definition def2 = r2.getDefinition();
        if (def1.getClass() != def2.getClass()) {
            return false;
        }

        if (r1.isRecursive() || r2.isRecursive()) {
            // We return false for recursive relations, because they are harder to compare and very unlikely to
            // be equal.
            return false;
        }

        if (def1 instanceof Definition.Undefined || def1 instanceof Free) {
            // Different undefined or free relations are never equal.
            return false;
        }

        // Special case for "semi-derived" relations
        if (def1 instanceof SetIdentity s1 && def2 instanceof SetIdentity s2) {
            return s1.getFilter().equals(s2.getFilter());
        }
        if (def1 instanceof CartesianProduct p1 && def2 instanceof CartesianProduct p2) {
            return p1.getFirstFilter().equals(p2.getFirstFilter()) && p1.getSecondFilter().equals(p2.getSecondFilter());
        }
        if (def1 instanceof Fences f1 && def2 instanceof Fences f2) {
            return f1.getFilter().equals(f2.getFilter());
        }
        if (def1 instanceof SameScope s1 && def2 instanceof SameScope s2) {
            return Objects.equals(s1.getSpecificScope(), s2.getSpecificScope());
        }

        // Standard derived relations are equal if their dependencies are equal.
        // TODO 1: Do we want to merge different versions of the same base relation?
        //  For static relations it makes sense, but for dynamic relations it is not clear
        //  (technically a single execution could have, e.g., different coherences)
        // TODO 2: Could be done more efficiently by using memoization.
        final List<Relation> deps1 = r1.getDependencies();
        final List<Relation> deps2 = r2.getDependencies();
        for (int i = 0; i < deps1.size(); i++) {
            if (!areEquivalent(deps1.get(i), deps2.get(i))) {
                return false;
            }
        }

        return true;
    }

    private void mergeEquivalentRelations(Wmm wmm, Map<Relation, Relation> eqMap) {
        final ConstraintCopier copier = new ConstraintCopier(eqMap);

        final List<Constraint> constraints = List.copyOf(wmm.getConstraints());
        for (Constraint c : constraints) {
            if (c.getConstrainedRelations().stream().noneMatch(r -> r != eqMap.get(r))) {
                continue;
            }

            if (c instanceof Definition def && eqMap.get(def.getDefinedRelation()) != def.getDefinedRelation()) {
                wmm.removeConstraint(c);
            } else if (!(c instanceof Definition.Undefined)) {
                wmm.removeConstraint(c);
                wmm.addConstraint(c.accept(copier));
            }
        }

        eqMap.forEach((r, repr) -> {
            if (r != repr) {
                logger.debug("Merged relation {} into relation {}", r, repr);
                wmm.deleteRelation(r);
                // Transfer names to representative relation.
                r.getNames().forEach(name -> wmm.addAlias(name, repr));
            }
        });
    }
}
