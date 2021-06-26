package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.binary;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.analysis.graphRefinement.util.GraphVisitor;
import com.dat3m.dartagnan.utils.timeable.Timestamp;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.Collection;
import java.util.Iterator;

public class DifferenceGraph extends BinaryEventGraph {

    public DifferenceGraph(EventGraph first, EventGraph second) {
        super(first, second);
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
    public Iterator<Edge> edgeIterator() {
        return new DifferenceIterator();
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        return new DifferenceIterator(e, dir);
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


    private class DifferenceIterator implements Iterator<Edge> {

        private final Iterator<Edge> innerIterator;
        private Edge nextEdge;

        public DifferenceIterator() {
            innerIterator = first.edgeIterator();
            nextInternal();
        }

        public DifferenceIterator(EventData e, EdgeDirection dir) {
            innerIterator = first.edgeIterator(e, dir);
            nextInternal();
        }

        private void nextInternal() {
            nextEdge = null;
            while (innerIterator.hasNext() && nextEdge == null) {
                nextEdge = innerIterator.next();
                if (second.contains(nextEdge))
                    nextEdge = null;
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
