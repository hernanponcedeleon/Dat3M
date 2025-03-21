package com.dat3m.dartagnan.wmm.utils.graph.mutable;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;

import java.util.*;
import java.util.function.BiConsumer;
import java.util.function.BiPredicate;
import java.util.stream.Collectors;

public class MapEventGraph implements MutableEventGraph {

    private final Map<Event, Set<Event>> data;

    public MapEventGraph() {
        this.data = new HashMap<>();
    }

    public MapEventGraph(Map<Event, Set<Event>> data) {
        this.data = new HashMap<>();
        data.forEach((e1, value) -> {
            if (!value.isEmpty()) {
                this.data.put(e1, new HashSet<>(value));
            }
        });
    }

    @Override
    public boolean isEmpty() {
        return data.isEmpty();
    }

    @Override
    public int size() {
        return data.values().stream()
                .map(Set::size)
                .reduce(0, Integer::sum);
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
    public boolean add(Event e1, Event e2) {
        return data.computeIfAbsent(e1, e -> new HashSet<>()).add(e2);
    }

    @Override
    public boolean remove(Event e1, Event e2) {
        Set<Event> set = data.get(e1);
        if (set != null && set.remove(e2)) {
            if (set.isEmpty()) {
                data.remove(e1);
            }
            return true;
        }
        return false;
    }

    @Override
    public boolean addAll(EventGraph other) {
        boolean modified = false;
        Map<Event, Set<Event>> copy = other instanceof MapEventGraph mOther ? mOther.data : other.getOutMap();
        for (Map.Entry<Event, Set<Event>> entry : copy.entrySet()) {
            modified |= data.computeIfAbsent(entry.getKey(), x -> new HashSet<>()).addAll(entry.getValue());
        }
        return modified;
    }

    @Override
    public boolean removeAll(EventGraph other) {
        boolean modified = false;
        Map<Event, Set<Event>> copy = other instanceof MapEventGraph mOther ? mOther.data : other.getOutMap();
        for (Map.Entry<Event, Set<Event>> entry : copy.entrySet()) {
            Event key = entry.getKey();
            Set<Event> value = data.get(key);
            if (value != null) {
                modified |= value.removeAll(entry.getValue());
                if (value.isEmpty()) {
                    data.remove(key);
                }
            }
        }
        return modified;
    }

    @Override
    public boolean retainAll(EventGraph other) {
        boolean modified = false;
        Map<Event, Set<Event>> copy = other instanceof MapEventGraph mOther ? mOther.data : other.getOutMap();
        Set<Event> removedKeys = new HashSet<>();
        for (Map.Entry<Event, Set<Event>> entry : data.entrySet()) {
            Event key = entry.getKey();
            Set<Event> otherValue = copy.get(key);
            if (otherValue != null) {
                Set<Event> value = entry.getValue();
                modified |= value.retainAll(otherValue);
                if (value.isEmpty()) {
                    removedKeys.add(key);
                }
            } else {
                modified = true;
                removedKeys.add(key);
            }
        }
        removedKeys.forEach(data::remove);
        return modified;
    }

    @Override
    public MapEventGraph inverse() {
        MapEventGraph inverse = new MapEventGraph();
        data.forEach((e1, value)
                -> value.forEach(e2
                -> inverse.data.computeIfAbsent(e2, x -> new HashSet<>()).add(e1)));
        return inverse;
    }

    @Override
    public MapEventGraph filter(BiPredicate<Event, Event> f) {
        MapEventGraph filtered = new MapEventGraph();
        data.forEach((e1, v) -> {
            Set<Event> set = v.stream()
                    .filter(e2 -> f.test(e1, e2))
                    .collect(Collectors.toCollection(HashSet::new));
            if (!set.isEmpty()) {
                filtered.data.put(e1, set);
            }
        });
        return filtered;
    }

    @Override
    public Map<Event, Set<Event>> getOutMap() {
        Map<Event, Set<Event>> outMap = new HashMap<>();
        data.forEach((k, v) -> outMap.put(k, Collections.unmodifiableSet(v)));
        return Collections.unmodifiableMap(outMap);
    }

    @Override
    public Map<Event, Set<Event>> getInMap() {
        return inverse().getOutMap();
    }

    @Override
    public Set<Event> getDomain() {
        return Collections.unmodifiableSet(data.keySet());
    }

    @Override
    public Set<Event> getRange() {
        return data.values().stream().flatMap(Collection::stream).collect(Collectors.toUnmodifiableSet());
    }

    @Override
    public Set<Event> getRange(Event e) {
        return Collections.unmodifiableSet(data.getOrDefault(e, Set.of()));
    }

    @Override
    public boolean addRange(Event e, Set<Event> range) {
        if (!range.isEmpty()) {
            return data.computeIfAbsent(e, x -> new HashSet<>()).addAll(range);
        }
        return false;
    }

    @Override
    public boolean removeIf(BiPredicate<Event, Event> f) {
        boolean modified = false;
        Set<Event> removedKeys = new HashSet<>();
        for (Map.Entry<Event, Set<Event>> entry : data.entrySet()) {
            Event key = entry.getKey();
            Set<Event> value = entry.getValue();
            modified |= value.removeIf(e2 -> f.test(key, e2));
            if (value.isEmpty()) {
                removedKeys.add(key);
            }
        }
        removedKeys.forEach(data::remove);
        return modified;
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
        if (!(o instanceof MapEventGraph that))
            return data.equals(eg.getOutMap());
        return Objects.equals(data, that.data);
    }

    @Override
    public int hashCode() {
        throw new UnsupportedOperationException(MapEventGraph.class.getSimpleName()
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

    public static MapEventGraph from(EventGraph other) {
        MapEventGraph newInstance = new MapEventGraph();
        newInstance.addAll(other);
        return newInstance;
    }

    public static MapEventGraph union(EventGraph... operands) {
        operands = Arrays.stream(operands).filter(o -> !o.isEmpty()).toArray(EventGraph[]::new);
        if (operands.length == 0) {
            return new MapEventGraph();
        }
        if (operands.length == 1) {
            return MapEventGraph.from(operands[0]);
        }
        List<Map<Event, Set<Event>>> maps = Arrays.stream(operands).unordered().parallel()
                .map(MapEventGraph::getOtherMap)
                .toList();
        MapEventGraph result = new MapEventGraph();
        maps.stream().flatMap(m -> m.keySet().stream())
                .collect(Collectors.toSet())
                .forEach(e1 -> result.data.put(e1, maps.stream()
                        .flatMap(m -> m.getOrDefault(e1, Set.of()).stream())
                        .collect(Collectors.toCollection(HashSet::new))));
        return result;
    }

    public static MapEventGraph intersection(EventGraph... operands) {
        if (Arrays.stream(operands).anyMatch(EventGraph::isEmpty)) {
            return new MapEventGraph();
        }
        if (operands.length == 1) {
            return MapEventGraph.from(operands[0]);
        }
        List<Map<Event, Set<Event>>> maps = Arrays.stream(operands).unordered().parallel()
                .map(MapEventGraph::getOtherMap)
                .toList();
        MapEventGraph result = new MapEventGraph();
        setIntersection(maps.stream().map(Map::keySet).toList()).forEach(e1 -> {
            Set<Event> range = setIntersection(maps.stream().map(m -> m.get(e1)).toList());
            if (!range.isEmpty()) {
                result.data.put(e1, range);
            }
        });
        return result;
    }

    public static MapEventGraph difference(EventGraph minuend, EventGraph subtrahend) {
        MapEventGraph result = new MapEventGraph();
        Map<Event, Set<Event>> subtrahendMap = getOtherMap(subtrahend);
        getOtherMap(minuend).forEach((e1, range) -> {
            Set<Event> copyRange = new HashSet<>(range);
            if (subtrahendMap.containsKey(e1)) {
                copyRange.removeAll(subtrahendMap.get(e1));
            }
            if (!copyRange.isEmpty()) {
                result.data.put(e1, copyRange);
            }
        });
        return result;
    }

    private static Set<Event> setIntersection(Collection<Set<Event>> data) {
        List<Set<Event>> sorted = data.stream().sorted(Comparator.comparing(Set::size)).toList();
        Set<Event> result = new HashSet<>(sorted.get(0));
        for (int i = 1; i < sorted.size(); i++) {
            result.retainAll(sorted.get(i));
        }
        return result;
    }

    private static Map<Event, Set<Event>> getOtherMap(EventGraph other) {
        if (other instanceof MapEventGraph mapOther) {
            return mapOther.data;
        }
        return other.getOutMap();
    }
}
