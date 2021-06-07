package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.unary;

import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.SimpleGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.utils.timeable.Timestamp;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.stream.Collectors;

public class RangeIdentityGraph extends UnaryGraph {

    private final SimpleGraph graph = new SimpleGraph();

    public RangeIdentityGraph(EventGraph inner) {
        super(inner);
    }

    @Override
    public boolean contains(Edge edge) {
        return graph.contains(edge);
    }

    @Override
    public void constructFromModel(ExecutionModel context) {
        super.constructFromModel(context);
        graph.constructFromModel(context);

        for (Edge e : inner) {
            graph.add(new Edge(e.getSecond(), e.getSecond()));
        }
    }

    @Override
    public void backtrack() {
        graph.backtrack();
    }

    @Override
    public Timestamp getTime(Edge edge) {
        return graph.getTime(edge);
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return graph.contains(a, b);
    }

    @Override
    public Timestamp getTime(EventData a, EventData b) {
        return graph.getTime(a, b);
    }

    @Override
    public int getMinSize() {
        return graph.getMinSize();
    }

    @Override
    public int getMaxSize() {
        return graph.getMaxSize();
    }

    @Override
    public int getEstimatedSize() {
        return graph.getEstimatedSize();
    }

    @Override
    public int getEstimatedSize(EventData e, EdgeDirection dir) {
        return graph.getEstimatedSize(e, dir);
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return graph.getMinSize(e, dir);
    }

    @Override
    public int getMaxSize(EventData e, EdgeDirection dir) {
        return graph.getMaxSize(e, dir);
    }

    @Override
    public Iterator<Edge> edgeIterator() {
        return graph.edgeIterator();
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        return graph.edgeIterator(e, dir);
    }

    @Override
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {
        if (changedGraph == inner) {
            addedEdges = addedEdges.stream().map(x -> new Edge(x.getSecond(), x.getSecond(), x.getTime()))
                    .filter(graph::add).collect(Collectors.toSet());

        } else {
            addedEdges.clear();
        }
        return addedEdges;
    }

    @Override
    public Conjunction<CoreLiteral> computeReason(Edge edge) {
        for (Edge inEdge : inner.inEdges(edge.getSecond())) {
            return inner.computeReason(inEdge);
        }
        throw new IllegalStateException("RangeIdentityGraph: No matching edge is found");
    }

}
