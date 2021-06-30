package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.axiom;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.GraphListener;
import com.dat3m.dartagnan.utils.dependable.Dependent;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Collections;
import java.util.List;

public abstract class GraphAxiom implements GraphListener, Dependent<EventGraph> {
    protected ExecutionModel context;
    protected final EventGraph inner;

    public EventGraph getConstrainedGraph() { return inner; }

    public List<EventGraph> getDependencies() {
        return Collections.singletonList(inner);
    }

    public GraphAxiom(EventGraph inner) {
        this.inner = inner;
    }

    public void initialize(ExecutionModel context) {
        this.context = context;
    }

    public abstract boolean checkForViolations();
    public abstract List<List<Edge>> getViolations();

}
