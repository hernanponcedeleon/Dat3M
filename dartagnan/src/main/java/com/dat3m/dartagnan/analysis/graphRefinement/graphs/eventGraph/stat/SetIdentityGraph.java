package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat;

import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.analysis.graphRefinement.util.GraphVisitor;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.wmm.filter.FilterAbstract;
import com.google.common.collect.Iterators;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.stream.Stream;

public class SetIdentityGraph extends StaticEventGraph {

    private final List<EventData> events;
    private final FilterAbstract filter;

    public SetIdentityGraph(FilterAbstract filter) {
        this.filter = filter;
        events = new ArrayList<>();
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return filter.filter(a.getEvent()) && a.equals(b);
    }

    @Override
    public void constructFromModel(ExecutionModel context) {
        super.constructFromModel(context);
        events.clear();;

        for (EventData e : context.getEventList()) {
            if (filter.filter(e.getEvent()))
                events.add(e);
        }
        this.size = events.size();
    }

    @Override
    public boolean contains(Edge edge) {
        return contains(edge.getFirst(), edge.getSecond());
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return filter.filter(e.getEvent()) ? 1 : 0;
    }

    @Override
    public Stream<Edge> edgeStream() {
        return events.stream().map(x -> new Edge(x, x));
    }

    @Override
    public Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        return filter.filter(e.getEvent()) ? Stream.of(new Edge(e, e)) : Stream.empty();
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        return filter.filter(e.getEvent()) ? Iterators.singletonIterator(new Edge(e, e)) : Collections.emptyIterator();
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitBase(this, data, context);
    }
}
