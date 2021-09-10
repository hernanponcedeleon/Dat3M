package com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.unary;

import com.dat3m.dartagnan.analysis.saturation.graphs.Edge;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.utils.MaterializedGraph;
import com.dat3m.dartagnan.analysis.saturation.util.GraphVisitor;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Collection;
import java.util.Collections;
import java.util.List;

public class RecursiveGraph extends MaterializedGraph {

    private RelationGraph inner;

    @Override
    public List<RelationGraph> getDependencies() {
        return Collections.singletonList(inner);
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitRecursive(this, data, context);
    }

    public RelationGraph getInner() { return inner; }

    @Override
    public void constructFromModel(ExecutionModel model) {
        super.constructFromModel(model);
    }

    @Override
    public Collection<Edge> forwardPropagate(RelationGraph changedGraph, Collection<Edge> addedEdges) {
        addedEdges.removeIf(x -> !simpleGraph.add(x));
        return addedEdges;
    }

    public void setConcreteGraph(RelationGraph concreteGraph) {
        this.inner = concreteGraph;
    }

}
