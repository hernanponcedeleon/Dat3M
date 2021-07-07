package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.unary;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.utils.MaterializedGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.util.GraphVisitor;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Collection;
import java.util.Collections;
import java.util.List;

//TODO:
// (1) Implement.
// (2)We surely need to materialize this set
// There is probably no reasonable way to do it virtually
// Maybe by temporarily storing all queries during calls to getTime/contains
// But how about iteration?
//
public class RecursiveGraph extends MaterializedGraph {

    private EventGraph inner;

    @Override
    public List<EventGraph> getDependencies() {
        return Collections.singletonList(inner);
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitRecursive(this, data, context);
    }

    public EventGraph getInner() { return inner; }

    @Override
    public void constructFromModel(ExecutionModel model) {
        super.constructFromModel(model);
    }

    @Override
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {
        addedEdges.removeIf(x -> !simpleGraph.add(x));
        return addedEdges;
    }

    public void setConcreteGraph(EventGraph concreteGraph) {
        this.inner = concreteGraph;
    }

}
