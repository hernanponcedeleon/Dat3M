package com.dat3m.dartagnan.solver.caat4wmm.basePredicates;

import com.dat3m.dartagnan.solver.caat.misc.EdgeDirection;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;


public class AllocMemGraph extends StaticWMMGraph {

    private Map<Integer, Set<Integer>> allocmems;

    @Override
    public boolean containsById(int id1, int id2) {
        if (allocmems.containsKey(id1)) {
            return allocmems.get(id1).contains(id2);
        }
        return false;
    }

    @Override
    public int size(int id, EdgeDirection dir) {
        if (dir == EdgeDirection.OUTGOING) {
            return allocmems.containsKey(id) ? allocmems.get(id).size() : 0;
        } else {
            return (int) allocmems.values().stream()
                    .filter(sinks -> sinks.contains(id)).count();
        }
    }

    @Override
    public void repopulate() {
        final Map<Object, Set<EventData>> addressAllocsMap = model.getAddressAllocsMap();
        final Map<Object, Set<EventData>> addressReadsMap = model.getAddressReadsMap();
        final Map<Object, Set<EventData>> addressWritesMap = model.getAddressWritesMap();
        allocmems = new HashMap<>();
        for (Map.Entry<Object, Set<EventData>> allocsEntry : addressAllocsMap.entrySet()) {
            final Object address = allocsEntry.getKey();
            final Set<Integer> allocs = allocsEntry.getValue().stream()
                    .map(EventData::getId).collect(Collectors.toSet());
            Stream.of(addressReadsMap, addressWritesMap)
                    .forEach(accessMap -> {
                        if (accessMap.containsKey(address)) {
                            final Set<Integer> accessIds = accessMap.get(address).stream()
                                    .map(EventData::getId).collect(Collectors.toSet());
                            allocs.forEach(id -> allocmems.computeIfAbsent(id, k -> new HashSet<>())
                                    .addAll(accessIds));
                        }
                    });
        }
        size = allocmems.values().stream().mapToInt(Set::size).sum();
    }

    @Override
    public Stream<Edge> edgeStream() {
        return allocmems.entrySet().stream()
                .flatMap(entry -> entry.getValue().stream()
                .map(id -> new Edge(entry.getKey(), id)));
    }

    @Override
    public Stream<Edge> edgeStream(int id, EdgeDirection dir) {
        if (dir == EdgeDirection.OUTGOING) {
            if (!allocmems.containsKey(id)) {
                return Stream.empty();
            }
            return allocmems.get(id).stream().map(i -> new Edge(id, i));
        } else {
            return allocmems.entrySet().stream()
                    .filter(entry -> entry.getValue().contains(id))
                    .map(entry -> new Edge(entry.getKey(), id));
        }
    }

}
