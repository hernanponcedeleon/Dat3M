package com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.stat;

import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.analysis.saturation.util.EdgeDirection;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.math.BigInteger;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Stream;

// NOTE: Unlike RelLoc, this graph is reflexive!
public class LocationGraph extends StaticRelationGraph {

    private Map<BigInteger, Set<EventData>> addrEventsMap;

    @Override
    public boolean contains(Edge edge) {
        return edge.isLocEdge();
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return a.isMemoryEvent() && b.isMemoryEvent() && a.getAccessedAddress().equals(b.getAccessedAddress());
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return e.isMemoryEvent() ? addrEventsMap.get(e.getAccessedAddress()).size() : 0;
    }


    @Override
    public void constructFromModel(ExecutionModel model) {
        super.constructFromModel(model);
        addrEventsMap = new HashMap<>(model.getAddressReadsMap().size());
        for (BigInteger addr : model.getAddressReadsMap().keySet()) {
            // TODO: This can be improved via a disjoint union class
            Set<EventData> events = new HashSet<>(model.getAddressReadsMap().get(addr));
            events.addAll(model.getAddressWritesMap().get(addr));
            size += events.size() * events.size();
            addrEventsMap.put(addr, events);
        }
    }

    @Override
    public Stream<Edge> edgeStream() {
        return addrEventsMap.values().stream().flatMap(Collection::stream)
                .flatMap(x -> edgeStream(x, EdgeDirection.OUTGOING));
    }

    @Override
    public Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        if (!e.isMemoryEvent()) {
            return Stream.empty();
        }
        Function<EventData, Edge> edgeMapping = dir == EdgeDirection.OUTGOING ?
                (x -> new Edge(e, x)) : (x -> new Edge(x, e));
        return addrEventsMap.get(e.getAccessedAddress()).stream().map(edgeMapping);
    }

}
