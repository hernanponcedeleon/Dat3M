package com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.axiom;

import com.dat3m.dartagnan.wmm.graphRefinement.ModelContext;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.timeable.Timeable;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.DNF;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.SortedClauseSet;

import java.util.*;

public class EmptinessAxiom extends GraphAxiom {

    private final List<Edge> violatingEdges = new ArrayList<>();

    public EmptinessAxiom(EventGraph inner) {
        super(inner);
    }

    @Override
    public void onGraphChanged(EventGraph changedGraph, Collection<Edge> addedEdges) {
        // The check is superfluous but we keep it for now
        if (changedGraph == inner) {
            violatingEdges.addAll(addedEdges);
        }
    }

    @Override
    public void initialize(ModelContext context) {
        super.initialize(context);
        violatingEdges.clear();
        onGraphChanged(inner, inner);
    }

    @Override
    public void backtrack() {
        violatingEdges.removeIf(Timeable::isInvalid);
    }

    @Override
    public void clearViolations() {
        violatingEdges.clear();
    }

    @Override
    public boolean checkForViolations() {
        return !violatingEdges.isEmpty();
    }

    @Override
    public DNF<CoreLiteral> computeReasons() {
        SortedClauseSet<CoreLiteral> clauseSet = new SortedClauseSet<>();
        for (Edge e : violatingEdges) {
            clauseSet.add(inner.computeReason(e));
        }
        clauseSet.simplify();
        return new DNF<>(clauseSet.getClauses());
    }

    @Override
    public Conjunction<CoreLiteral> computeSomeReason() {
        return checkForViolations() ? inner.computeReason(violatingEdges.get(0)) : Conjunction.FALSE;
    }
}