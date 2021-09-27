package com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.constraints;

import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.utils.timeable.Timeable;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

public class EmptinessConstraint extends Constraint {

    private final List<Edge> violatingEdges = new ArrayList<>();

    public EmptinessConstraint(RelationGraph constrainedGraph) {
        super(constrainedGraph);
    }

    @Override
    public void onGraphChanged(RelationGraph changedGraph, Collection<Edge> addedEdges) {
        violatingEdges.addAll(addedEdges);
    }

    @Override
    public void initialize(ExecutionModel context) {
        super.initialize(context);
        violatingEdges.clear();
        onGraphChanged(constrainedGraph, constrainedGraph.setView());
    }

    @Override
    public void backtrack() {
        violatingEdges.removeIf(Timeable::isInvalid);
    }


    @Override
    public boolean checkForViolations() {
        return !violatingEdges.isEmpty();
    }

    @Override
    public List<List<Edge>>  getViolations() {
        return violatingEdges.stream().map(Collections::singletonList).collect(Collectors.toList());
    }
}