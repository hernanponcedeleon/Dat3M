package com.dat3m.dartagnan.solver.caat4wmm.basePredicates;

import com.dat3m.dartagnan.solver.caat.misc.EdgeDirection;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Stream;

// NOTE: Unlike RelLoc, this graph is reflexive!
public class LocationGraph extends StaticWMMGraph {

    private Map<Object, Set<EventData>> addrEventsMap;

    @Override
    public boolean containsById(int id1, int id2) {
        EventData a = getEvent(id1);
        EventData b = getEvent(id2);
        return a.isMemoryEvent() && b.isMemoryEvent() && a.getAccessedAddress().equals(b.getAccessedAddress());
    }

    @Override
    public int size(int id, EdgeDirection dir) {
        EventData e = getEvent(id);
        return e.isMemoryEvent() ? addrEventsMap.get(e.getAccessedAddress()).size() : 0;
    }

    @Override
    public void repopulate() {
        addrEventsMap = new HashMap<>(model.getAddressReadsMap().size());
        for (Object addr : model.getAddressReadsMap().keySet()) {
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
                .flatMap(x -> edgeStream(x.getId(), EdgeDirection.OUTGOING));
    }

    @Override
    public Stream<Edge> edgeStream(int id, EdgeDirection dir) {
        EventData e = getEvent(id);
        if (!e.isMemoryEvent()) {
            return Stream.empty();
        }
        Function<EventData, Edge> edgeMapping = dir == EdgeDirection.OUTGOING ?
                (x -> new Edge(id, x.getId())) : (x -> new Edge(x.getId(), id));
        return addrEventsMap.get(e.getAccessedAddress()).stream().map(edgeMapping);
    }

}
