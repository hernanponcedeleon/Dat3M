package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.unary;

import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.ReasoningEngine;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.utils.timeable.Timestamp;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.Collection;
import java.util.Iterator;
import java.util.stream.Stream;

public class ReflexiveClosureGraph extends UnaryGraph {


    public ReflexiveClosureGraph(EventGraph inner) {
        super(inner);
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
        return Math.max(inner.getMinSize(), context.getEventList().size());
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return Math.max(inner.getMinSize(e, dir), 1);
    }

    @Override
    public int getMaxSize() {
        return inner.getMaxSize() + context.getEventList().size();
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
    public Iterator<Edge> edgeIterator() {
        return context.getEventList().stream().
                flatMap(x -> Stream.concat(
                        Stream.of(new Edge(x, x)),
                        inner.edgeStream(x, EdgeDirection.Outgoing).filter(edge -> !edge.isLoop())
                )).iterator();
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        return Stream.concat(
                Stream.of(new Edge(e, e)),
                inner.edgeStream(e, dir).filter(edge -> !edge.isLoop())
                ).iterator();
    }

    @Override
    public Conjunction<CoreLiteral> computeReason(Edge edge, ReasoningEngine reasEngine) {
        Conjunction<CoreLiteral> reason = reasEngine.tryGetStaticReason(this, edge);
        if (reason != null) {
            return reason;
        }

        return edge.isLoop() ? Conjunction.TRUE : inner.computeReason(edge, reasEngine);
    }

}
