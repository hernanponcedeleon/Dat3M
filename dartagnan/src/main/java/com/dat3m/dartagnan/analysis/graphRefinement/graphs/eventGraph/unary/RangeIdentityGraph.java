package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.unary;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.utils.MaterializedGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.util.GraphVisitor;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

public class RangeIdentityGraph extends MaterializedGraph {

    private final EventGraph inner;

    @Override
    public List<? extends EventGraph> getDependencies() {
        return List.of(inner);
    }

    public RangeIdentityGraph(EventGraph inner) {
        this.inner = inner;
    }

    @Override
    public void constructFromModel(ExecutionModel context) {
        super.constructFromModel(context);
        inner.edgeStream().forEach(e -> simpleGraph.add(new Edge(e.getSecond(), e.getSecond())));
    }

    @Override
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {
        if (changedGraph == inner) {
            addedEdges = addedEdges.stream()
                    .map(x -> new Edge(x.getSecond(), x.getSecond(), x.getTime(), x.getDerivationLength() + 1))
                    .filter(simpleGraph::add).collect(Collectors.toList());
        } else {
            addedEdges.clear();
        }
        return addedEdges;
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitRangeIdentity(this, data, context);
    }

}
