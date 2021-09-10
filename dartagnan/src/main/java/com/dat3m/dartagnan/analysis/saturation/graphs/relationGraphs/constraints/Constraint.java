package com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.constraints;

import com.dat3m.dartagnan.analysis.saturation.graphs.Edge;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.GraphListener;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.utils.dependable.Dependent;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Collections;
import java.util.List;

public abstract class Constraint implements GraphListener, Dependent<RelationGraph> {
    protected ExecutionModel context;
    protected final RelationGraph constrainedGraph;

    public RelationGraph getConstrainedGraph() { return constrainedGraph; }

    public List<RelationGraph> getDependencies() {
        return Collections.singletonList(constrainedGraph);
    }

    public Constraint(RelationGraph constrainedGraph) {
        this.constrainedGraph = constrainedGraph;
    }

    public void initialize(ExecutionModel context) {
        this.context = context;
    }

    public abstract boolean checkForViolations();

    public abstract List<List<Edge>> getViolations();

}
