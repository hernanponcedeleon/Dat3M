package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.unary;

import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.utils.timeable.Timestamp;

import java.util.Collection;
import java.util.Iterator;
import java.util.stream.Collectors;

public class InverseGraph extends UnaryGraph {

    public InverseGraph(EventGraph inner) {
        super(inner);
    }

    @Override
    public boolean contains(Edge edge) {
        return inner.contains(edge.getInverse());
    }

    @Override
    public Timestamp getTime(Edge edge) {
        return inner.getTime(edge.getInverse());
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return inner.contains(b, a);
    }

    @Override
    public Timestamp getTime(EventData a, EventData b) {
        return inner.getTime(b, a);
    }

    @Override
    public int getMinSize() {
        return inner.getMinSize();
    }

    @Override
    public int getMaxSize() {
        return inner.getMaxSize();
    }

    @Override
    public int getEstimatedSize() {
        return inner.getEstimatedSize();
    }

    @Override
    public int getEstimatedSize(EventData e, EdgeDirection dir) {
        return inner.getEstimatedSize(e, dir.flip());
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return inner.getMinSize(e, dir.flip());
    }

    @Override
    public int getMaxSize(EventData e, EdgeDirection dir) {
        return inner.getMaxSize(e, dir.flip());
    }

    @Override
    public Iterator<Edge> edgeIterator() {
        return new InverseIterator();
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        return new InverseIterator(e, dir);
    }

    @Override
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {
        if (changedGraph == inner) {
            addedEdges = addedEdges.stream().map(Edge::getInverse).collect(Collectors.toSet());
        } else {
            addedEdges.clear();
        }
        return addedEdges;
    }

    @Override
    public Conjunction<CoreLiteral> computeReason(Edge edge) {
        return inner.computeReason(edge.getInverse());
    }


    private class InverseIterator implements Iterator<Edge> {

        private final Iterator<Edge> innerIterator;

        public InverseIterator() {
            innerIterator = inner.edgeIterator();
        }

        public InverseIterator(EventData e, EdgeDirection dir) {
            innerIterator = inner.edgeIterator(e, dir.flip());
        }

        @Override
        public boolean hasNext() {
            return innerIterator.hasNext();
        }

        @Override
        public Edge next() {
            return innerIterator.next().getInverse();
        }
    }
}
