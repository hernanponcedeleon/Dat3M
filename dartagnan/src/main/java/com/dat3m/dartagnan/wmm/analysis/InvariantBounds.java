package com.dat3m.dartagnan.wmm.analysis;

import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Emptiness;
import com.dat3m.dartagnan.wmm.definition.Difference;

import java.util.*;

/*
    Collects the containments R ⊆ T stated by invariants of the form "invariant empty R \ T".

    Since invariants hold in every execution, the relation analysis can remove from may(R) all pairs that
    are not in may(T), without reporting them as discrepancies. This is most useful if T is transitive,
    but its may-set is not (e.g. loc, whose may-set comes from the non-transitive may-alias relation).
 */
final class InvariantBounds {

    private final Map<Relation, Set<Relation>> bounds = new HashMap<>();
    private final Map<Relation, Set<Relation>> transitiveDependencies = new HashMap<>();

    private InvariantBounds() {}

    static InvariantBounds fromInvariants(Wmm wmm) {
        final InvariantBounds result = new InvariantBounds();
        for (Axiom inv : wmm.getInvariants()) {
            if (inv instanceof Emptiness && !inv.isNegated()
                    && inv.getRelation().getDefinition() instanceof Difference diff) {
                // Use a LinkedHashSet to keep the order in which the invariants were declared.
                result.bounds.computeIfAbsent(diff.getMinuend(), _ -> new LinkedHashSet<>()).add(diff.getSubtrahend());
            }
        }
        return result;
    }

    /*
        Returns all relations T (other than r itself) such that r ⊆ T.
     */
    Set<Relation> getBounds(Relation r) {
        final Set<Relation> result = new LinkedHashSet<>(bounds.getOrDefault(r, Set.of()));
        result.remove(r);
        return result;
    }

    /*
        Returns the bounds of r whose analysis results are complete before those of r get computed,
        i.e., bounds without dependencies (base relations) and bounds that r strictly depends on.
        Only those can be used to restrict r while r is being computed.
     */
    Set<Relation> getComputedBeforeBounds(Relation r) {
        final Set<Relation> result = new LinkedHashSet<>();
        final Set<Relation> rDeps = getTransitiveDependencies(r);
        for (Relation t : getBounds(r)) {
            if (t.getDependencies().isEmpty() || (rDeps.contains(t) && !getTransitiveDependencies(t).contains(r))) {
                result.add(t);
            }
        }
        return result;
    }

    private Set<Relation> getTransitiveDependencies(Relation r) {
        final Set<Relation> cached = transitiveDependencies.get(r);
        if (cached != null) {
            return cached;
        }
        final Set<Relation> result = new HashSet<>();
        final Deque<Relation> workList = new ArrayDeque<>(r.getDependencies());
        while (!workList.isEmpty()) {
            final Relation next = workList.pop();
            if (result.add(next)) {
                workList.addAll(next.getDependencies());
            }
        }
        transitiveDependencies.put(r, result);
        return result;
    }
}
