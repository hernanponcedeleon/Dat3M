package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.unary;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.utils.MaterializedGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.util.GraphVisitor;
import com.dat3m.dartagnan.utils.collections.SetUtil;
import com.dat3m.dartagnan.utils.timeable.Timestamp;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class TransitiveGraph extends MaterializedGraph {

    private final EventGraph inner;

    @Override
    public List<? extends EventGraph> getDependencies() {
        return List.of(inner);
    }

    public TransitiveGraph(EventGraph inner) {
        this.inner = inner;
    }

    @Override
    public void constructFromModel(ExecutionModel context) {
        super.constructFromModel(context);
        initialPopulation();
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitTransitiveClosure(this, data, context);
    }

    private Edge derive(Edge e) {
        return e.with(e.getDerivationLength() + 1);
    }

    private void initialPopulation() {
        //TODO: This is inefficient for many edges (the likely default case!)
        Set<Edge> fakeSet = SetUtil.fakeSet();
        inner.edgeStream().forEach(e -> updateEdge(derive(e), fakeSet));
    }

    private Edge combine(Edge a, Edge b, Timestamp time) {
        return new Edge(a.getFirst(), b.getSecond(), time,
                Math.max(a.getDerivationLength(), b.getDerivationLength()) + 1);
    }

    private void updateEdge(Edge edge, Set<Edge> addedEdges) {
        if (!simpleGraph.add(edge))
            return;
        addedEdges.add(edge);

        inEdgeStream(edge.getFirst()).forEach(inEdge -> {
            Edge newEdge = combine(inEdge, edge, edge.getTime());
            if (simpleGraph.add(newEdge)) {
                addedEdges.add(newEdge);
                outEdgeStream(edge.getSecond())
                        .map(outEdge -> combine(newEdge, outEdge, edge.getTime()))
                        .filter(simpleGraph::add).forEach(addedEdges::add);
            }
        });

        outEdgeStream(edge.getSecond())
                .map(outEdge -> combine(edge, outEdge, edge.getTime()))
                .filter(simpleGraph::add).forEach(addedEdges::add);
    }


    @Override
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {
        Set<Edge> newEdges = new HashSet<>();
        if (changedGraph == inner) {
            addedEdges.forEach(e -> updateEdge(derive(e), newEdges));
        }
        return newEdges;
    }

}
