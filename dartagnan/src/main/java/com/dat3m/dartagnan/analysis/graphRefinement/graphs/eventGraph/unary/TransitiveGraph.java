package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.unary;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.utils.MaterializedGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.util.GraphVisitor;
import com.dat3m.dartagnan.utils.collections.SetUtil;
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

    private void initialPopulation() {
        //TODO: This is inefficient for many edges (the likely default case!)
        Set<Edge> fakeSet = SetUtil.fakeSet();
        for (Edge e : inner.edges()) {
            updateEdgeRecursive(e, fakeSet);
        }
    }

    private void updateEdgeRecursive(Edge edge, Set<Edge> addedEdges) {
        if (!simpleGraph.add(edge))
            return;
        addedEdges.add(edge);
        for (Edge inEdge : inEdges(edge.getFirst())) {
            Edge newEdge = new Edge(inEdge.getFirst(), edge.getSecond(), edge.getTime());
            if (simpleGraph.add(newEdge)) {
                addedEdges.add(newEdge);
                for (Edge outEdge : outEdges(edge.getSecond())) {
                    newEdge = new Edge(inEdge.getFirst(), outEdge.getSecond(), edge.getTime());
                    if (simpleGraph.add(newEdge))
                        addedEdges.add(newEdge);
                }
            }
        }

        for (Edge outEdge : outEdges(edge.getSecond())) {
            Edge newEdge = new Edge(edge.getFirst(), outEdge.getSecond(), edge.getTime());
            if (simpleGraph.add(newEdge))
                addedEdges.add(newEdge);
        }
    }


    @Override
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {
        Set<Edge> newEdges = new HashSet<>();
        if (changedGraph == inner) {
            for (Edge e : addedEdges) {
                updateEdgeRecursive(e, newEdges);
            }
        }
        return newEdges;
    }

}
