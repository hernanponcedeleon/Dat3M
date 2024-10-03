package com.dat3m.dartagnan.wmm.utils.graph.immutable;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MapEventGraph;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Sets;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.BiConsumer;
import java.util.function.BiPredicate;
import java.util.stream.Collectors;

public class ImmutableMapEventGraph implements ImmutableEventGraph {

    private final Map<Event, Set<Event>> data;
    private final int size;
    private ImmutableMapEventGraph inverse;

    public ImmutableMapEventGraph(Map<Event, Set<Event>> data) {
        this(data, data.values().stream().map(Set::size).reduce(0, Integer::sum));
    }

    private ImmutableMapEventGraph(Map<Event, Set<Event>> data, int size) {
        this.data = data.entrySet().stream()
                .filter(e -> !e.getValue().isEmpty())
                .collect(ImmutableMap.toImmutableMap(
                        Map.Entry::getKey,
                        entry -> ImmutableSet.copyOf(entry.getValue())));
        this.size = size;
    }

    public static ImmutableEventGraph empty() {
        return EmptyEventGraph.instance;
    }

    @Override
    public boolean isEmpty() {
        return size == 0;
    }

    @Override
    public int size() {
        return size;
    }

    @Override
    public boolean contains(Event e1, Event e2) {
        Set<Event> values = data.get(e1);
        if (values != null) {
            return values.contains(e2);
        }
        return false;
    }

    @Override
    public ImmutableMapEventGraph inverse() {
        if (inverse == null) {
            Map<Event, Set<Event>> invData = new HashMap<>();
            data.forEach((e1, value) -> value.forEach(e2 -> invData.computeIfAbsent(e2, x -> new HashSet<>()).add(e1)));
            inverse = new ImmutableMapEventGraph(invData, size);
            inverse.inverse = this;
        }
        return inverse;
    }

    @Override
    public ImmutableMapEventGraph filter(BiPredicate<Event, Event> f) {
        Map<Event, Set<Event>> filteredData = new ConcurrentHashMap<>();
        data.keySet().stream().unordered().parallel()
                .forEach(e1 -> filteredData.put(e1, data.get(e1).stream()
                        .filter(e2 -> f.test(e1, e2))
                        .collect(ImmutableSet.toImmutableSet())));
        return new ImmutableMapEventGraph(filteredData);
    }

    @Override
    public Map<Event, Set<Event>> getOutMap() {
        return data;
    }

    @Override
    public Map<Event, Set<Event>> getInMap() {
        return inverse().getOutMap();
    }

    @Override
    public Set<Event> getDomain() {
        return data.keySet();
    }

    @Override
    public Set<Event> getRange() {
        return inverse().getDomain();
    }

    @Override
    public Set<Event> getRange(Event e) {
        return data.getOrDefault(e, Set.of());
    }

    @Override
    public void apply(BiConsumer<Event, Event> f) {
        data.forEach((e1, value) -> value.forEach(e2 -> f.accept(e1, e2)));
    }

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (!(o instanceof EventGraph eg))
            return false;
        if (!(o instanceof ImmutableMapEventGraph that))
            return data.equals(eg.getOutMap());
        return Objects.equals(data, that.data);
    }

    @Override
    public int hashCode() {
        throw new UnsupportedOperationException(ImmutableMapEventGraph.class.getSimpleName()
                + " should not be used as a key");
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("[");
        for (Event e1 : data.keySet().stream().sorted().toList()) {
            for (Event e2 : data.get(e1).stream().sorted().toList()) {
                sb.append("(")
                        .append(e1.getGlobalId())
                        .append(",")
                        .append(e2.getGlobalId())
                        .append(")");
            }
        }
        return sb.append("]").toString();
    }

    public static ImmutableMapEventGraph from(EventGraph other) {
        if (other.isEmpty()) {
            return EmptyEventGraph.instance;
        }
        if (other instanceof ImmutableMapEventGraph iOther) {
            return iOther;
        }
        if (other instanceof LazyEventGraph || other instanceof MapEventGraph) {
            return new ImmutableMapEventGraph(other.getOutMap());
        }
        throw new IllegalArgumentException("Unexpected type of event graph " + other.getClass().getSimpleName());
    }

    public static ImmutableMapEventGraph union(EventGraph... operands) {
        EventGraph[] nonEmptyOperands = Arrays.stream(operands).filter(o -> !o.isEmpty()).toArray(EventGraph[]::new);
        if (nonEmptyOperands.length == 0) {
            return EmptyEventGraph.instance;
        }
        if (nonEmptyOperands.length == 1) {
            return ImmutableMapEventGraph.from(nonEmptyOperands[0]);
        }
        Set<Event> domain = Arrays.stream(nonEmptyOperands)
                .flatMap(eg -> eg.getDomain().stream())
                .collect(Collectors.toSet());
        Map<Event, Set<Event>> data = new ConcurrentHashMap<>();
        domain.stream().unordered().parallel()
                .forEach(e1 -> data.put(e1, Arrays.stream(nonEmptyOperands)
                        .flatMap(eg -> eg.getRange(e1).stream())
                        .collect(ImmutableSet.toImmutableSet())));
        return new ImmutableMapEventGraph(data);
    }

    public static ImmutableMapEventGraph intersection(EventGraph... operands) {
        if (Arrays.stream(operands).anyMatch(EventGraph::isEmpty)) {
            return EmptyEventGraph.instance;
        }
        if (operands.length == 1) {
            return ImmutableMapEventGraph.from(operands[0]);
        }
        Set<Event> domain = Arrays.stream(operands)
                .map(EventGraph::getDomain)
                .sorted(Comparator.comparing(Set::size))
                .reduce(Sets::intersection)
                .orElseThrow();
        Map<Event, Set<Event>> data = new ConcurrentHashMap<>();
        domain.stream().unordered().parallel()
                .forEach(e1 -> data.put(e1, Arrays.stream(operands)
                        .map(eg -> eg.getRange(e1))
                        .sorted(Comparator.comparing(Set::size))
                        .reduce(Sets::intersection)
                        .orElseThrow()));
        return new ImmutableMapEventGraph(data);
    }

    public static ImmutableMapEventGraph difference(EventGraph minuend, EventGraph subtrahend) {
        if (minuend.isEmpty() || subtrahend.isEmpty()) {
            ImmutableMapEventGraph.from(minuend);
        }
        Map<Event, Set<Event>> data = new ConcurrentHashMap<>();
        minuend.getDomain().stream().unordered().parallel()
                .forEach(e1 -> data.put(e1, Sets.difference(minuend.getRange(e1), subtrahend.getRange(e1))));
        return new ImmutableMapEventGraph(data);
    }

    public static class EmptyEventGraph extends ImmutableMapEventGraph {

        private static final EmptyEventGraph instance = new EmptyEventGraph();

        private EmptyEventGraph() {
            super(Map.of());
        }

        @Override
        public EmptyEventGraph filter(BiPredicate<Event, Event> f) {
            return this;
        }

        @Override
        public EmptyEventGraph inverse() {
            return this;
        }
    }
}
