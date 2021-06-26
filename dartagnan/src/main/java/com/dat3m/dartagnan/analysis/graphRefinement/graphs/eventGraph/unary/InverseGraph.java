package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.unary;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.AbstractEventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.analysis.graphRefinement.util.GraphVisitor;
import com.dat3m.dartagnan.utils.timeable.Timestamp;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.stream.Collectors;

public class InverseGraph extends AbstractEventGraph {

    protected final EventGraph inner;

    public InverseGraph(EventGraph inner) {
        this.inner = inner;
    }

    public List<EventGraph> getDependencies() {
        return Collections.singletonList(inner);
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
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitInverse(this, data, context);
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
