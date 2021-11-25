package com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.unary;

import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.utils.MaterializedGraph;
import com.dat3m.dartagnan.solver.caat.util.GraphVisitor;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

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
        if (changedGraph == inner) {
            return addedEdges.stream().filter(simpleGraph::add).collect(Collectors.toList());
        } else {
            return Collections.emptyList();
        }
    }

    public void setConcreteGraph(RelationGraph concreteGraph) {
        this.inner = concreteGraph;
    }

}
