package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.axiom;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.utils.timeable.Timeable;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

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
    public void initialize(ExecutionModel context) {
        super.initialize(context);
        violatingEdges.clear();
        onGraphChanged(inner, inner.setView());
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
    public List<List<Edge>> getViolations() {
        return Collections.singletonList(Collections.unmodifiableList(violatingEdges));
    }
}