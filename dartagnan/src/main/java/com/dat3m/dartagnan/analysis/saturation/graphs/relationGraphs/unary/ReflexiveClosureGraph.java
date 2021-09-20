package com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.unary;

import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.AbstractRelationGraph;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.analysis.saturation.util.EdgeDirection;
import com.dat3m.dartagnan.analysis.saturation.util.GraphVisitor;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class ReflexiveClosureGraph extends AbstractRelationGraph {

    private final RelationGraph inner;

    public ReflexiveClosureGraph(RelationGraph inner) {
        this.inner = inner;
    }

    @Override
    public List<RelationGraph> getDependencies() {
        return Collections.singletonList(inner);
    }

    @Override
    public Optional<Edge> get(Edge edge) {
        return edge.isLoop() ? Optional.of(edge.with(0, 0)) : inner.get(edge);
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return a.equals(b) || inner.contains(a, b);
    }

    @Override
    public int getMinSize() {
        return Math.max(inner.getMinSize(), model.getEventList().size());
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return Math.max(inner.getMinSize(e, dir), 1);
    }

    @Override
    public int getMaxSize() {
        return inner.getMaxSize() + model.getEventList().size();
    }

    @Override
    public int getMaxSize(EventData e, EdgeDirection dir) {
        return inner.getMaxSize(e, dir) + 1;
    }

    private Edge derive(Edge e) {
        return e.withDerivLength(e.getDerivationLength() + 1);
    }

    @Override
    public Collection<Edge> forwardPropagate(RelationGraph changedGraph, Collection<Edge> addedEdges) {
        if (changedGraph == inner) {
            return addedEdges.stream().filter(e -> !e.isLoop()).map(this::derive).collect(Collectors.toList());
        } else {
            return Collections.emptyList();
        }
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitReflexiveClosure(this, data, context);
    }

    @Override
    public Stream<Edge> edgeStream() {
        return model.getEventList().stream().flatMap(e -> edgeStream(e, EdgeDirection.OUTGOING));
    }

    @Override
    public Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        return Stream.concat(
                Stream.of(new Edge(e, e)),
                inner.edgeStream(e, dir).filter(edge -> !edge.isLoop())
        );
    }

}
