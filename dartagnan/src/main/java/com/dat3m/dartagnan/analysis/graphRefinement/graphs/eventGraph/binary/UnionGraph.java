package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.binary;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.analysis.graphRefinement.util.GraphVisitor;
import com.dat3m.dartagnan.utils.timeable.Timestamp;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.Collection;
import java.util.stream.Stream;


//TODO: Since the addition of derivation length, this class is not correct anymore
public class UnionGraph extends BinaryEventGraph {

    public UnionGraph(EventGraph first, EventGraph second) {
        super(first, second);
    }

    @Override
    public Edge get(Edge edge) {
        // Note: does not guarantee minimality
        Edge a = first.get(edge);
        return a != null ? a : second.get(edge);
    }

    @Override
    public boolean contains(Edge edge) {
        return first.contains(edge) || second.contains(edge);
    }


    @Override
    public boolean contains(EventData a, EventData b) {
        return first.contains(a, b) || second.contains(a, b);
    }

    @Override
    public Timestamp getTime(Edge edge) {
        Timestamp time = first.getTime(edge);
        return time.isInitial() ? Timestamp.ZERO : Timestamp.min(time, second.getTime(edge));
    }

    @Override
    public Timestamp getTime(EventData a, EventData b) {
        Timestamp time = first.getTime(a, b);
        return time.isInitial() ? Timestamp.ZERO : Timestamp.min(time, second.getTime(a, b));
    }

    @Override
    public int getMinSize() {
        return Math.min(first.getMinSize(), second.getMinSize());
    }

    @Override
    public int getMaxSize() {
        return first.getMaxSize() + second.getMaxSize();
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return Math.min(first.getMinSize(e, dir), second.getMinSize(e, dir));
    }

    @Override
    public int getMaxSize(EventData e, EdgeDirection dir) {
        return first.getMaxSize(e, dir) + second.getMaxSize(e, dir);
    }

    @Override
    public Stream<Edge> edgeStream() {
        EventGraph a = first.getEstimatedSize() >= second.getEstimatedSize() ? first : second;
        EventGraph b = a == first ? second : first;
        return Stream.concat(a.edgeStream(), b.edgeStream().filter(edge -> !a.contains(edge)));
    }

    @Override
    public Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        EventGraph a = first.getEstimatedSize(e, dir) >= second.getEstimatedSize(e, dir) ? first : second;
        EventGraph b = a == first ? second : first;
        return Stream.concat(a.edgeStream(e, dir), b.edgeStream(e, dir).filter(edge -> !a.contains(edge)));
    }

    @Override
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {
        if (changedGraph == first || changedGraph == second) {
            EventGraph other = changedGraph == first ? second : first;
            //addedEdges.removeIf(other::contains); <---- Problem
            // NOTE: This shortcut can only be done, if R = A | B and A and B are independent.
            // This is not the case for recursive relations and will cause problems there.
        } else {
            addedEdges.clear();
        }
        return addedEdges;
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitUnion(this, data, context);
    }
}