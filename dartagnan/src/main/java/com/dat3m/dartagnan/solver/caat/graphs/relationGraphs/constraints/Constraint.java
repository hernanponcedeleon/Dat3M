package com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.constraints;

import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.GraphListener;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.utils.dependable.Dependent;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Collection;
import java.util.Collections;
import java.util.List;

public abstract class Constraint implements GraphListener, Dependent<RelationGraph> {
    protected ExecutionModel model;
    protected final RelationGraph constrainedGraph;

    public RelationGraph getConstrainedGraph() { return constrainedGraph; }

    public List<RelationGraph> getDependencies() {
        return Collections.singletonList(constrainedGraph);
    }

    public Constraint(RelationGraph constrainedGraph) {
        this.constrainedGraph = constrainedGraph;
    }

    public void initialize(ExecutionModel model) {
        this.model = model;
    }

    public abstract boolean checkForViolations();

    public abstract Collection<? extends Collection<Edge>> getViolations();

}
