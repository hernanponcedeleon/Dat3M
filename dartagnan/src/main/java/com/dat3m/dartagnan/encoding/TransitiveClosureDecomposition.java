package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.definition.TransitiveClosure;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Maps;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

/*
    Describes the definition of an edge (e1, e2) of a transitive closure r+:

        r+(e1, e2) = r(e1, e2) \/ OR_{e in steps} (left(e1, e) /\ right(e, e2))

    (The WmmEncoder emits one or both implications depending on the polarity of r+.)
    For each edge, the steps are either all left-linear or all right-linear:
        left-linear:  left = r(e1, e),  right = r+(e, e2)
        right-linear: left = r+(e1, e), right = r(e, e2)
    We use left-linear steps unless right-linear ones are strictly fewer.
    An r-edge that is a must-edge of r+ is encoded via r+ instead (its execution literal).

    The one-sided choice matters for the ActiveSetAnalysis: following an r+ path from one side
    activates only its prefixes or suffixes in r+, rather than all of its infixes.
    Because the propagation must cover every edge the clauses refer to, the WmmEncoder and the
    ActiveSetAnalysis share this class, so that their per-edge choices cannot diverge.

    Must-reduction: Let implied = must(r+);must(r+). Must-edges of r+ in <implied> need no definition,
    and steps through r-edges in <implied> are skipped (as in the acyclicity relevant-set reduction).
    This is only correct if must(r+) is acyclic, and is disabled otherwise.
 */
final class TransitiveClosureDecomposition {

    // A single step e1 -left-> mid -right-> e2.
    // The flags tell whether the respective edge is encoded via r+ (true) or r (false).
    record Step(Event mid, boolean leftIsClosure, boolean rightIsClosure) {}

    // <direct> tells whether r(e1, e2) is a possible (may) edge.
    record Decomposition(boolean direct, List<Step> steps) {}

    private final Relation closure;
    private final Relation inner;
    private final EventGraph relMustSet;
    private final EventGraph relMaySet;
    private final EventGraph innerMaySet;
    private final EventGraph implied;
    private final Map<Event, List<Event>> relevantSuccessors;
    private final Map<Event, List<Event>> relevantPredecessors;

    TransitiveClosureDecomposition(TransitiveClosure trans, RelationAnalysis ra) {
        this.closure = trans.getDefinedRelation();
        this.inner = trans.getOperand();
        this.relMustSet = ra.getKnowledge(closure).getMustSet();
        this.relMaySet = ra.getKnowledge(closure).getMaySet();
        this.innerMaySet = ra.getKnowledge(inner).getMaySet();

        final boolean acyclicMust = relMustSet.getDomain().stream().noneMatch(e -> relMustSet.contains(e, e));
        this.implied = acyclicMust
                ? ra.computeComposition(relMustSet, relMustSet).getMustSet()
                : EventGraph.empty();

        this.relevantSuccessors = ImmutableMap.copyOf(Maps.transformEntries(innerMaySet.getOutMap(),
                (x, succs) -> succs.stream()
                        .filter(y -> y != x && !implied.contains(x, y))
                        .sorted(Comparator.comparingInt(Event::getGlobalId)).toList()
        ));
        this.relevantPredecessors = ImmutableMap.copyOf(Maps.transformEntries(innerMaySet.getInMap(),
                (x, preds) -> preds.stream()
                        .filter(y -> y != x && !implied.contains(y, x))
                        .sorted(Comparator.comparingInt(Event::getGlobalId)).toList()
        ));
    }

    Relation getClosure() { return closure; }
    Relation getInner() { return inner; }

    // Returns null if (e1, e2) is a must-edge derivable from other must-edges:
    // (e1, e) and (e, e2) imply (e1, e2) via transitivity.
    Decomposition decompose(Event e1, Event e2) {
        if (relMustSet.contains(e1, e2) && implied.contains(e1, e2)) {
            return null;
        }

        // Left-linear: step(e1, e) & trans(e, e2) => trans(e1, e2)
        final List<Event> leftSteps = new ArrayList<>();
        for (Event e : relevantSuccessors.getOrDefault(e1, List.of())) {
            if (e == e2 || !relMaySet.contains(e, e2)) {
                continue;
            }
            leftSteps.add(e);
        }

        // Right-linear: trans(e1, e) & step(e, e2) => trans(e1, e2)
        List<Event> rightSteps = null;
        if (leftSteps.size() > 1) {
            rightSteps = new ArrayList<>();
            for (Event e : relevantPredecessors.getOrDefault(e2, List.of())) {
                if (e == e2 || !relMaySet.contains(e1, e)) {
                    continue;
                }
                rightSteps.add(e);

                if (rightSteps.size() >= leftSteps.size()) {
                    rightSteps = null;
                    break;
                }
            }
        }

        final List<Step> steps = new ArrayList<>(rightSteps != null ? rightSteps.size() : leftSteps.size());
        if (rightSteps != null) {
            for (Event e : rightSteps) {
                steps.add(new Step(e, true, relMustSet.contains(e, e2)));
            }
        } else {
            for (Event e : leftSteps) {
                steps.add(new Step(e, relMustSet.contains(e1, e), true));
            }
        }
        return new Decomposition(innerMaySet.contains(e1, e2), steps);
    }
}
