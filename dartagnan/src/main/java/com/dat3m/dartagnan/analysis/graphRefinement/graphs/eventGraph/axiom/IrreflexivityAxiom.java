package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.axiom;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.utils.timeable.Timeable;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

public class IrreflexivityAxiom extends GraphAxiom {

    private final List<Edge> violatingEdges = new ArrayList<>();

    public IrreflexivityAxiom(EventGraph inner) {
        super(inner);
    }

    @Override
    public boolean checkForViolations() {
        return !violatingEdges.isEmpty();
    }

    @Override
    public List<List<Edge>> getViolations() {
        return violatingEdges.stream().map(Collections::singletonList).collect(Collectors.toList());
    }

    @Override
    public void initialize(ExecutionModel context) {
        super.initialize(context);
        violatingEdges.clear();
        inner.edgeStream().filter(Edge::isLoop).forEach(violatingEdges::add);
    }

    @Override
    public void onGraphChanged(EventGraph changedGraph, Collection<Edge> addedEdges) {
        addedEdges.stream().filter(Edge::isLoop).forEach(violatingEdges::add);
    }

    @Override
    public void backtrack() {
        violatingEdges.removeIf(Timeable::isInvalid);
    }

}