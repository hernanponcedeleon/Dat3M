package com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.unary;

import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.utils.MaterializedGraph;
import com.dat3m.dartagnan.analysis.saturation.util.GraphVisitor;
import com.dat3m.dartagnan.utils.collections.SetUtil;
import com.dat3m.dartagnan.utils.timeable.Timestamp;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.*;

public class TransitiveGraph extends MaterializedGraph {

    private final RelationGraph inner;

    @Override
    public List<? extends RelationGraph> getDependencies() {
        return Collections.singletonList(inner);
    }

    public TransitiveGraph(RelationGraph inner) {
        this.inner = inner;
    }

    @Override
    public void constructFromModel(ExecutionModel model) {
        super.constructFromModel(model);
        initialPopulation();
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitTransitiveClosure(this, data, context);
    }

    private Edge derive(Edge e) {
        return e.with(e.getDerivationLength() + 1);
    }

    private Edge combine(Edge a, Edge b, Timestamp time) {
        return new Edge(a.getFirst(), b.getSecond(), time,
                Math.max(a.getDerivationLength(), b.getDerivationLength()) + 1);
    }

    private void initialPopulation() {
        //TODO: This is inefficient for many edges (the likely default case!)
        Set<Edge> fakeSet = SetUtil.fakeSet();
        inner.edgeStream().forEach(e -> updateEdge(derive(e), fakeSet));
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
    public Collection<Edge> forwardPropagate(RelationGraph changedGraph, Collection<Edge> addedEdges) {
        Set<Edge> newEdges = new HashSet<>();
        if (changedGraph == inner) {
            addedEdges.forEach(e -> updateEdge(derive(e), newEdges));
        }
        return newEdges;
    }

}
