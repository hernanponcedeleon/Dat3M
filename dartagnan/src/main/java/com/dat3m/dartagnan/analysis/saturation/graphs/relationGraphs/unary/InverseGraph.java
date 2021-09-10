package com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.unary;

import com.dat3m.dartagnan.analysis.saturation.graphs.Edge;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.AbstractRelationGraph;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.analysis.saturation.util.EdgeDirection;
import com.dat3m.dartagnan.analysis.saturation.util.GraphVisitor;
import com.dat3m.dartagnan.utils.timeable.Timestamp;
import com.dat3m.dartagnan.verification.model.EventData;
import com.google.common.collect.Iterators;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class InverseGraph extends AbstractRelationGraph {

    protected final RelationGraph inner;

    public InverseGraph(RelationGraph inner) {
        this.inner = inner;
    }

    @Override
    public List<RelationGraph> getDependencies() {
        return Collections.singletonList(inner);
    }

    @Override
    public Optional<Edge> get(Edge edge) {
        return inner.get(edge.inverse()).map(this::derive);
    }

    @Override
    public boolean contains(Edge edge) {
        return inner.contains(edge.inverse());
    }

    @Override
    public Timestamp getTime(Edge edge) {
        return inner.getTime(edge.inverse());
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


    private Edge derive(Edge e) {
        return new Edge(e.getSecond(), e.getFirst(), e.getTime(), e.getDerivationLength() + 1);
    }

    @Override
    public Stream<Edge> edgeStream() {
        return inner.edgeStream().map(this::derive);
    }

    @Override
    public Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        return inner.edgeStream(e, dir.flip()).map(this::derive);
    }

    @Override
    public Iterator<Edge> edgeIterator() {
        return Iterators.transform(inner.edgeIterator(), this::derive);
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        return Iterators.transform(inner.edgeIterator(e, dir.flip()), this::derive);
    }

    @Override
    public Collection<Edge> forwardPropagate(RelationGraph changedGraph, Collection<Edge> addedEdges) {
        if (changedGraph == inner) {
            addedEdges = addedEdges.stream().map(this::derive).collect(Collectors.toList());
        } else {
            addedEdges.clear();
        }
        return addedEdges;
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitInverse(this, data, context);
    }
}
