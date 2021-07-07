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
import java.util.List;
import java.util.stream.Stream;

//TODO: Increase the derivation length of edges of this graph
public class ReflexiveClosureGraph extends AbstractEventGraph {

    private final EventGraph inner;

    public ReflexiveClosureGraph(EventGraph inner) {
        this.inner = inner;
    }

    @Override
    public List<EventGraph> getDependencies() {
        return Collections.singletonList(inner);
    }

    @Override
    public Edge get(Edge edge) {
        return edge.isLoop() ? edge.with(Timestamp.ZERO, 0) : inner.get(edge);
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return a.equals(b) || inner.contains(a, b);
    }

    @Override
    public Timestamp getTime(EventData a, EventData b) {
        return a.equals(b) ? Timestamp.ZERO : inner.getTime(a, b);
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

    @Override
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {
        if (changedGraph == inner) {
            addedEdges.removeIf(Edge::isLoop);
        } else {
            addedEdges.clear();
        }
        return addedEdges;
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitReflexiveClosure(this, data, context);
    }

    @Override
    public Stream<Edge> edgeStream() {
        return model.getEventList().stream().flatMap(e -> edgeStream(e, EdgeDirection.Outgoing));
    }

    @Override
    public Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        return Stream.concat(
                Stream.of(new Edge(e, e)),
                inner.edgeStream(e, dir).filter(edge -> !edge.isLoop())
        );
    }

}
