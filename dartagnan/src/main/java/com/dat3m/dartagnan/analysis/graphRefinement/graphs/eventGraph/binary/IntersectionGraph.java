package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.binary;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.analysis.graphRefinement.util.GraphVisitor;
import com.dat3m.dartagnan.utils.timeable.Timestamp;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.Collection;
import java.util.Iterator;

public class IntersectionGraph extends BinaryEventGraph {

    public IntersectionGraph(EventGraph first, EventGraph second) {
        super(first, second);
    }


    @Override
    public boolean contains(Edge edge) {
        return first.contains(edge) && second.contains(edge);
    }

    @Override
    public Timestamp getTime(Edge edge) {
        Timestamp time = first.getTime(edge);
        return !time.isValid() ? Timestamp.INVALID : Timestamp.max(time, second.getTime(edge));
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return first.contains(a, b) && second.contains(a, b);
    }

    @Override
    public Timestamp getTime(EventData a, EventData b) {
        Timestamp time = first.getTime(a, b);
        return !time.isValid() ? Timestamp.INVALID : Timestamp.max(time, second.getTime(a, b));
    }

    @Override
    public int getMinSize() {
        return 0;
    }

    @Override
    public int getMaxSize() {
        return Math.min(first.getMaxSize(), second.getMaxSize());
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return 0;
    }

    @Override
    public int getMaxSize(EventData e, EdgeDirection dir) {
        return Math.min(first.getMaxSize(e, dir), second.getMaxSize(e, dir));
    }

    @Override
    public Iterator<Edge> edgeIterator() {
        return new IntersectionIterator();
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        return new IntersectionIterator(e, dir);
    }

    @Override
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {
        if (changedGraph == first || changedGraph == second) {
            EventGraph other = changedGraph == first ? second : first;
            addedEdges.removeIf(x -> !other.contains(x));
        } else {
            addedEdges.clear();
        }
        return addedEdges;
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitIntersection(this, data, context);
    }


    private class IntersectionIterator implements Iterator<Edge> {

        private final Iterator<Edge> innerIterator;
        private final EventGraph other;

        private Edge nextEdge;

        public IntersectionIterator() {
            if (first.getEstimatedSize() <= second.getEstimatedSize()) {
                innerIterator = first.edgeIterator();
                other = second;
            } else {
                innerIterator = second.edgeIterator();
                other = first;
            }
            nextInternal();
        }

        public IntersectionIterator(EventData e, EdgeDirection dir) {
            if (first.getEstimatedSize(e, dir) <= second.getEstimatedSize(e, dir)) {
                innerIterator = first.edgeIterator(e, dir);
                other = second;
            } else {
                innerIterator = second.edgeIterator(e, dir);
                other = first;
            }
            nextInternal();
        }

        private void nextInternal() {
            nextEdge = null;
            while (innerIterator.hasNext() && nextEdge == null) {
                nextEdge = innerIterator.next();
                Timestamp t = other.getTime(nextEdge);
                if (t.isInvalid()) {
                    nextEdge = null;
                } else if (nextEdge.getTime().compareTo(t) > 0)
                    nextEdge = nextEdge.withTimestamp(t);
            }
        }

        @Override
        public boolean hasNext() {
            return nextEdge != null;
        }

        @Override
        public Edge next() {
            Edge e = nextEdge;
            nextInternal();
            return e;
        }
    }
}
