package com.dat3m.dartagnan.wmm.utils.graph.immutable;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MapEventGraph;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Sets;

import java.util.*;
import java.util.function.BiConsumer;
import java.util.function.BiPredicate;
import java.util.stream.Collectors;

public class ImmutableMapEventGraph implements ImmutableEventGraph {

    private final Map<Event, Set<Event>> data;
    private final int size;
    private ImmutableMapEventGraph inverse;

    public ImmutableMapEventGraph(Map<Event, Set<Event>> data) {
        ImmutableMap.Builder<Event, Set<Event>> builder = ImmutableMap.builder();
        data.forEach((e1, value) -> {
            if (!value.isEmpty()) {
                builder.put(e1, ImmutableSet.copyOf(value));
            }
        });
        this.data = builder.build();
        this.size = data.values().stream().map(Set::size).reduce(0, Integer::sum);
    }

    private ImmutableMapEventGraph(ImmutableMapEventGraph inverse, Map<Event, Set<Event>> data, int size) {
        this.data = data;
        this.inverse = inverse;
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
            ImmutableMap.Builder<Event, Set<Event>> builder = new ImmutableMap.Builder<>();
            invData.forEach((e1, range) -> builder.put(e1, ImmutableSet.copyOf(range)));
            inverse = new ImmutableMapEventGraph(this, builder.build(), size);
        }
        return inverse;
    }

    @Override
    public ImmutableMapEventGraph filter(BiPredicate<Event, Event> f) {
        Map<Event, Set<Event>> mutable = new HashMap<>();
        data.forEach((e1, v) -> {
            Set<Event> set = v.stream()
                    .filter(e2 -> f.test(e1, e2))
                    .collect(Collectors.toSet());
            if (!set.isEmpty()) {
                mutable.put(e1, set);
            }
        });
        return new ImmutableMapEventGraph(mutable);
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
        // TODO: Inverse is a heavier computation than range.
        //  Would it make sense to compute range separately if there is no inverse?
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
        operands = Arrays.stream(operands).filter(o -> !o.isEmpty()).toArray(EventGraph[]::new);
        if (operands.length == 0) {
            return EmptyEventGraph.instance;
        }
        if (operands.length == 1) {
            return ImmutableMapEventGraph.from(operands[0]);
        }

        List<Map<Event, Set<Event>>> maps = Arrays.stream(operands).unordered().parallel()
                .map(EventGraph::getOutMap)
                .toList();
        Map<Event, Set<Event>> data = new HashMap<>();
        maps.stream().flatMap(m -> m.keySet().stream()).forEach(e1 -> {
            Set<Event> range = maps.stream()
                    .flatMap(m -> m.getOrDefault(e1, Set.of()).stream())
                    .collect(ImmutableSet.toImmutableSet());
            data.put(e1, range);
        });
        return new ImmutableMapEventGraph(data);
    }

    public static ImmutableMapEventGraph intersection(EventGraph... operands) {
        if (Arrays.stream(operands).anyMatch(EventGraph::isEmpty)) {
            return EmptyEventGraph.instance;
        }
        if (operands.length == 1) {
            return ImmutableMapEventGraph.from(operands[0]);
        }

        List<Map<Event, Set<Event>>> maps = Arrays.stream(operands).unordered().parallel()
                .map(EventGraph::getOutMap)
                .toList();
        Map<Event, Set<Event>> data = new HashMap<>();
        computeIntersection(maps.stream().map(Map::keySet).toList()).forEach(e1 -> {
            Set<Event> range = computeIntersection(maps.stream().map(m -> m.get(e1)).toList());
            if (!range.isEmpty()) {
                data.put(e1, ImmutableSet.copyOf(range));
            }
        });
        return new ImmutableMapEventGraph(data);
    }

    public static ImmutableMapEventGraph difference(EventGraph minuend, EventGraph subtrahend) {
        if (minuend.isEmpty() || subtrahend.isEmpty()) {
            ImmutableMapEventGraph.from(minuend);
        }

        Map<Event, Set<Event>> data = new HashMap<>();
        Map<Event, Set<Event>> subtrahendMap = subtrahend.getOutMap();
        minuend.getOutMap().forEach((e1, range) -> {
            if (!subtrahendMap.containsKey(e1)) {
                data.put(e1, range);
                return;
            }
            Set<Event> set = Sets.difference(range, subtrahendMap.get(e1));
            if (!set.isEmpty()) {
                data.put(e1, set);
            }
        });
        return new ImmutableMapEventGraph(data);
    }

    private static Set<Event> computeIntersection(Collection<Set<Event>> data) {
        List<Set<Event>> sorted = data.stream().sorted(Comparator.comparing(Set::size)).toList();
        Set<Event> result = new HashSet<>(sorted.get(0));
        for (int i = 1; i < sorted.size(); i++) {
            result.retainAll(sorted.get(i));
        }
        return result;
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
