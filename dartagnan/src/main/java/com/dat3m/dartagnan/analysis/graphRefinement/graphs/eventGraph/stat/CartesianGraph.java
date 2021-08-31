package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat;

import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.wmm.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelCartesian;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Stream;

public class CartesianGraph extends StaticEventGraph {

    private final List<EventData> firstEvents;
    private final List<EventData> secondEvents;

    private final FilterAbstract first;
    private final FilterAbstract second;

    public CartesianGraph(RelCartesian rel) {
        this(rel.getFirstFilter(), rel.getSecondFilter());
    }

    public CartesianGraph(FilterAbstract first, FilterAbstract second) {
        this.first = first;
        this.second = second;

        firstEvents = new ArrayList<>();
        secondEvents = new ArrayList<>();
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return first.filter(a.getEvent()) && second.filter(b.getEvent());
    }

    @Override
    public void constructFromModel(ExecutionModel model) {
        super.constructFromModel(model);
        firstEvents.clear();
        secondEvents.clear();

        for (EventData e : model.getEventList()) {
            if (first.filter(e.getEvent())) {
                firstEvents.add(e);
            }
            if (second.filter(e.getEvent())) {
                secondEvents.add(e);
            }
        }
        size = firstEvents.size() * secondEvents.size();
    }

    @Override
    public boolean contains(Edge edge) {
        return contains(edge.getFirst(), edge.getSecond());
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        if (dir == EdgeDirection.Outgoing) {
            return first.filter(e.getEvent()) ? secondEvents.size() : 0;
        } else {
            return second.filter(e.getEvent()) ? firstEvents.size() : 0;
        }
    }

    @Override
    public Stream<Edge> edgeStream() {
        return firstEvents.stream().flatMap(a -> secondEvents.stream().map(b -> new Edge(a, b)));
    }

    @Override
    public Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        if (dir == EdgeDirection.Outgoing) {
            return first.filter(e.getEvent()) ? secondEvents.stream().map(b -> new Edge(e, b)) : Stream.empty();
        } else {
            return second.filter(e.getEvent()) ? firstEvents.stream().map(a -> new Edge(a, e)) : Stream.empty();
        }
    }
}
