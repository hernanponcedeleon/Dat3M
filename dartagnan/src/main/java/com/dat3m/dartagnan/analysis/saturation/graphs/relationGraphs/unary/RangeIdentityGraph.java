package com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.unary;

import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.utils.MaterializedGraph;
import com.dat3m.dartagnan.analysis.saturation.util.GraphVisitor;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

public class RangeIdentityGraph extends MaterializedGraph {

    private final RelationGraph inner;

    @Override
    public List<? extends RelationGraph> getDependencies() {
        return List.of(inner);
    }

    public RangeIdentityGraph(RelationGraph inner) {
        this.inner = inner;
    }

    private Edge derive(Edge e) {
        return new Edge(e.getSecond(), e.getSecond(), e.getTime(), e.getDerivationLength() + 1);
    }

    @Override
    public void constructFromModel(ExecutionModel model) {
        super.constructFromModel(model);
        inner.edgeStream().forEach(e -> simpleGraph.add(derive(e)));
    }

    @Override
    public Collection<Edge> forwardPropagate(RelationGraph changedGraph, Collection<Edge> addedEdges) {
        if (changedGraph == inner) {
            return addedEdges.stream()
                    .map(this::derive)
                    .filter(simpleGraph::add)
                    .collect(Collectors.toList());
        } else {
            return Collections.emptyList();
        }
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitRangeIdentity(this, data, context);
    }

}
