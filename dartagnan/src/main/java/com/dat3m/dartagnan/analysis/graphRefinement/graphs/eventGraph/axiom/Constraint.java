package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.axiom;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.GraphListener;
import com.dat3m.dartagnan.utils.dependable.Dependent;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Collections;
import java.util.List;

public abstract class Constraint implements GraphListener, Dependent<EventGraph> {
    protected ExecutionModel context;
    protected final EventGraph constrainedGraph;

    public EventGraph getConstrainedGraph() { return constrainedGraph; }

    public List<EventGraph> getDependencies() {
        return Collections.singletonList(constrainedGraph);
    }

    public Constraint(EventGraph constrainedGraph) {
        this.constrainedGraph = constrainedGraph;
    }

    public void initialize(ExecutionModel context) {
        this.context = context;
    }

    public abstract boolean checkForViolations();

    public abstract List<List<Edge>> getViolations();

}
