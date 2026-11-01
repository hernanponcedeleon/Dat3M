package com.dat3m.dartagnan.solver.caat.misc;

import com.dat3m.dartagnan.solver.caat.domain.GenericDomain;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.base.SimpleGraph;
import org.junit.Test;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import static org.junit.Assert.*;

public class EdgeStorageTest {

    @Test
    public void pairMapBehavesLikeHashMap() {
        final Random random = new Random(42);
        for (int round = 0; round < 20; round++) {
            final PairMap<Integer> pairMap = new PairMap<>(4);
            final Map<List<Integer>, Integer> reference = new HashMap<>();
            final int n = 1 + random.nextInt(60);
            for (int op = 0; op < 5000; op++) {
                final int a = random.nextInt(n);
                final int b = random.nextInt(n);
                final List<Integer> key = List.of(a, b);
                switch (random.nextInt(3)) {
                    case 0 -> {
                        final int value = random.nextInt();
                        assertEquals(reference.putIfAbsent(key, value), pairMap.putIfAbsent(a, b, value));
                    }
                    case 1 -> assertEquals(reference.remove(key) != null, pairMap.remove(a, b));
                    default -> assertEquals(reference.get(key), pairMap.get(a, b));
                }
                assertEquals(reference.size(), pairMap.size());
            }
            reference.forEach((key, value) -> assertEquals(value, pairMap.get(key.get(0), key.get(1))));
        }
    }

    @Test
    public void edgeStoreSurvivesDomainChanges() {
        // Dense mode reuses rows across domains; growing the domain must not break lookups.
        for (int domainSize : new int[] { 3, 10, 2000, 50, 5 }) {
            final EdgeStore store = new EdgeStore();
            store.initialize(domainSize);
            for (int size : new int[] { domainSize, domainSize + 7 }) {
                store.initialize(size);
                assertEquals(0, store.size());
                final Set<List<Integer>> added = new HashSet<>();
                for (int i = 0; i < size; i++) {
                    final int j = (i * 7 + 3) % size;
                    if (added.add(List.of(i, j))) {
                        assertTrue(store.add(new Edge(i, j)));
                    }
                    assertFalse(store.add(new Edge(i, j)));
                }
                assertEquals(added.size(), store.size());
                for (int i = 0; i < size; i++) {
                    assertEquals(added.contains(List.of(i, (i * 7 + 3) % size)), store.contains(i, (i * 7 + 3) % size));
                    assertEquals(added.contains(List.of(i, (i + 1) % size)), store.contains(i, (i + 1) % size));
                }
                added.forEach(e -> store.remove(e.get(0), e.get(1)));
                assertEquals(0, store.size());
            }
        }
    }

    @Test
    public void simpleGraphBacktracking() {
        final GenericDomain<Integer> domain = new GenericDomain<>(IntStream.range(0, 20).boxed().toList());
        final SimpleGraph graph = new SimpleGraph();
        graph.initializeToDomain(domain);
        final Random random = new Random(7);
        final List<Set<Edge>> snapshots = new ArrayList<>();
        for (int time = 0; time < 10; time++) {
            for (int i = 0; i < 15; i++) {
                graph.add(new Edge(random.nextInt(20), random.nextInt(20), time, 0));
            }
            snapshots.add(graph.edgeStream().collect(Collectors.toSet()));
        }
        for (int time = 9; time >= 0; time--) {
            graph.backtrackTo(time);
            assertEquals(snapshots.get(time), graph.edgeStream().collect(Collectors.toSet()));
            assertEquals(snapshots.get(time).size(), graph.size());
            for (Edge e : snapshots.get(time)) {
                assertTrue(graph.containsById(e.getFirst(), e.getSecond()));
                assertTrue(graph.outEdgeStream(e.getFirst()).anyMatch(e::equals));
                assertTrue(graph.inEdgeStream(e.getSecond()).anyMatch(e::equals));
            }
        }
    }
}
