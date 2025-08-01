package com.dat3m.dartagnan.solver.caat4wmm.basePredicates;

import com.dat3m.dartagnan.solver.caat.misc.EdgeDirection;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;


public class AllocPtrGraph extends StaticWMMGraph {

    private Map<Integer, Set<Integer>> allocptrs;

    @Override
    public boolean containsById(int id1, int id2) {
        if (allocptrs.containsKey(id1)) {
            return allocptrs.get(id1).contains(id2);
        }
        return false;
    }
    
    @Override
    public int size(int id, EdgeDirection dir) {
        if (dir == EdgeDirection.OUTGOING) {
            return allocptrs.containsKey(id) ? allocptrs.get(id).size() : 0;
        } else {
            return (int) allocptrs.values().stream()
                    .filter(sinks -> sinks.contains(id)).count();
        }
    }

    @Override
    public void repopulate() {
        final Map<Object, Set<EventData>> addressAllocsMap = model.getAddressAllocsMap();
        final Map<Object, Set<EventData>> addressFreesMap = model.getAddressFreesMap();
        allocptrs = new HashMap<>();
        // ALLOC -> FREE
        for (Map.Entry<Object, Set<EventData>> allocsEntry : addressAllocsMap.entrySet()) {
            final Object address = allocsEntry.getKey();
            if (!addressFreesMap.containsKey(address)) { continue; }
            final Set<EventData> allocs = allocsEntry.getValue();
            final Set<EventData> frees = addressFreesMap.get(address);
            for (EventData a : allocs) {
                final Set<Integer> freeIds = frees.stream()
                        .map(EventData::getId).collect(Collectors.toSet());
                allocptrs.put(a.getId(), freeIds);
            }
        }
        // FREE -> FREE
        for (Set<EventData> frees : addressFreesMap.values()) {
            for (EventData f : frees) {
                final Set<Integer> freeIds = frees.stream()
                        .map(EventData::getId).collect(Collectors.toSet());
                allocptrs.put(f.getId(), freeIds);
            }
            final int n = frees.size();
        }
        size = allocptrs.values().stream().mapToInt(Set::size).sum();
    }

    @Override
    public Stream<Edge> edgeStream() {
        return allocptrs.entrySet().stream()
                .flatMap(entry -> entry.getValue().stream()
                .map(id -> new Edge(entry.getKey(), id)));
    }

    @Override
    public Stream<Edge> edgeStream(int id, EdgeDirection dir) {
        if (dir == EdgeDirection.OUTGOING) {
            if (!allocptrs.containsKey(id)) {
                return Stream.empty();
            }
            return allocptrs.get(id).stream().map(i -> new Edge(id, i));
        } else {
            return allocptrs.entrySet().stream()
                    .filter(entry -> entry.getValue().contains(id))
                    .map(entry -> new Edge(entry.getKey(), id));
        }
    }

}
