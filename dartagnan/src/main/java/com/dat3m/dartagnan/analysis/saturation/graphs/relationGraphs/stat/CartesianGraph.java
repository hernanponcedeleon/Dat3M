package com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.stat;

import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.analysis.saturation.util.EdgeDirection;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.wmm.filter.FilterAbstract;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Stream;

public class CartesianGraph extends StaticRelationGraph {

    private final List<EventData> firstEvents;
    private final List<EventData> secondEvents;

    private final FilterAbstract firstFilter;
    private final FilterAbstract secondFilter;

    public CartesianGraph(FilterAbstract first, FilterAbstract second) {
        this.firstFilter = first;
        this.secondFilter = second;

        firstEvents = new ArrayList<>();
        secondEvents = new ArrayList<>();
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return firstFilter.filter(a.getEvent()) && secondFilter.filter(b.getEvent());
    }

    @Override
    public void constructFromModel(ExecutionModel model) {
        super.constructFromModel(model);
        firstEvents.clear();
        secondEvents.clear();

        model.getEventList().stream().filter(e -> firstFilter.filter(e.getEvent())).forEach(firstEvents::add);
        model.getEventList().stream().filter(e -> secondFilter.filter(e.getEvent())).forEach(secondEvents::add);
        size = firstEvents.size() * secondEvents.size();
    }

    @Override
    public boolean contains(Edge edge) {
        return contains(edge.getFirst(), edge.getSecond());
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        if (dir == EdgeDirection.OUTGOING) {
            return firstFilter.filter(e.getEvent()) ? secondEvents.size() : 0;
        } else {
            return secondFilter.filter(e.getEvent()) ? firstEvents.size() : 0;
        }
    }

    @Override
    public Stream<Edge> edgeStream() {
        return firstEvents.stream().flatMap(a -> secondEvents.stream().map(b -> new Edge(a, b)));
    }

    @Override
    public Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        if (dir == EdgeDirection.OUTGOING) {
            return firstFilter.filter(e.getEvent()) ? secondEvents.stream().map(b -> new Edge(e, b)) : Stream.empty();
        } else {
            return secondFilter.filter(e.getEvent()) ? firstEvents.stream().map(a -> new Edge(a, e)) : Stream.empty();
        }
    }
}
