package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.binary;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.AbstractEventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.analysis.graphRefinement.util.GraphVisitor;
import com.dat3m.dartagnan.utils.timeable.Timestamp;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.stream.Stream;

//TODO: This class is not up-to-date with the new derivation length.
// However, this doesn't cause any issues as we do not support differences in recursion.
public class DifferenceGraph extends AbstractEventGraph {

    private final EventGraph first;
    private final EventGraph second;

    @Override
    public List<? extends EventGraph> getDependencies() {
        return Arrays.asList(first, second);
    }

    public EventGraph getFirst() { return first; }
    public EventGraph getSecond() { return second; }

    public DifferenceGraph(EventGraph first, EventGraph second) {
        this.first = first;
        this.second = second;
    }

    @Override
    public Edge get(Edge edge) {
        return second.contains(edge) ? null : first.get(edge);
    }

    @Override
    public boolean contains(Edge edge) {
        return first.contains(edge) && !second.contains(edge);
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return first.contains(a, b) && !second.contains(a, b);
    }

    @Override
    public Timestamp getTime(Edge edge) {
        return second.contains(edge) ? Timestamp.INVALID : first.getTime(edge);
    }

    @Override
    public Timestamp getTime(EventData a, EventData b) {
        return second.contains(a, b) ? Timestamp.INVALID : first.getTime(a, b);
    }

    @Override
    public int getMinSize() {
        return Math.max(0, first.getMinSize() - second.getMaxSize());
    }

    @Override
    public int getMaxSize() {
        return first.getMaxSize();
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return Math.max(0, first.getMinSize(e, dir) - second.getMaxSize(e, dir));
    }

    @Override
    public int getMaxSize(EventData e, EdgeDirection dir) {
        return first.getMaxSize(e, dir);
    }

    @Override
    public Stream<Edge> edgeStream() {
        return first.edgeStream().filter(edge -> !second.contains(edge));
    }

    @Override
    public Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        return first.edgeStream(e, dir).filter(edge -> !second.contains(edge));
    }

    @Override
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {

        if (changedGraph == first) {
            addedEdges.removeIf(second::contains);
        } else if (changedGraph == second) {
            throw new IllegalStateException("Non-static relations on the right hand side of Set Minus are invalid.");
        } else {
            addedEdges.clear();
        }
        return addedEdges;
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitDifference(this, data, context);
    }

}
