package com.dat3m.dartagnan.wmm.utils;

import com.dat3m.dartagnan.program.event.Event;

import java.util.*;
import java.util.function.BiConsumer;
import java.util.function.BiPredicate;
import java.util.stream.Collectors;

public class EventGraph {

    private final Map<Event, Set<Event>> data;

    public EventGraph() {
        this.data = new HashMap<>();
    }

    public EventGraph(EventGraph other) {
        this.data = new HashMap<>();
        other.data.forEach((k, v) -> this.data.put(k, new HashSet<>(v)));
    }

    protected EventGraph(Map<Event, Set<Event>> data) {
        this.data = data;
    }

    public boolean isEmpty() {
        return data.isEmpty();
    }

    public int size() {
        return data.values().stream()
                .map(Set::size)
                .reduce(0, Integer::sum);
    }

    public boolean contains(Event e1, Event e2) {
        Set<Event> values = data.get(e1);
        if (values != null) {
            return values.contains(e2);
        }
        return false;
    }

    public boolean add(Event e1, Event e2) {
        return data.computeIfAbsent(e1, e -> new HashSet<>()).add(e2);
    }

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

    public boolean addAll(EventGraph other) {
        boolean modified = false;
        for (Map.Entry<Event, Set<Event>> otherEntry : other.data.entrySet()) {
            modified |= data.computeIfAbsent(otherEntry.getKey(), x -> new HashSet<>()).addAll(otherEntry.getValue());
        }
        return modified;
    }

    public boolean removeAll(EventGraph other) {
        boolean modified = false;
        for (Map.Entry<Event, Set<Event>> otherEntry : other.data.entrySet()) {
            Event key = otherEntry.getKey();
            Set<Event> value = data.get(key);
            if (value != null) {
                modified |= value.removeAll(otherEntry.getValue());
                if (value.isEmpty()) {
                    data.remove(key);
                }
            }
        }
        return modified;
    }

    public boolean retainAll(EventGraph other) {
        boolean modified = false;
        Set<Event> removedKeys = new HashSet<>();
        for (Map.Entry<Event, Set<Event>> entry : data.entrySet()) {
            Event key = entry.getKey();
            Set<Event> otherValue = other.data.get(key);
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

    public EventGraph inverse() {
        EventGraph inverse = new EventGraph();
        data.forEach((e1, value)
                -> value.forEach(e2
                -> inverse.data.computeIfAbsent(e2, x -> new HashSet<>()).add(e1)));
        return inverse;
    }

    public EventGraph filter(BiPredicate<Event, Event> f) {
        EventGraph filtered = new EventGraph();
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

    public Map<Event, Set<Event>> getOutMap() {
        Map<Event, Set<Event>> temp = new HashMap<>();
        data.forEach((k, v) -> temp.put(k, Collections.unmodifiableSet(v)));
        return Collections.unmodifiableMap(temp);
    }

    public Map<Event, Set<Event>> getInMap() {
        return inverse().getOutMap();
    }

    public Set<Event> getDomain() {
        return Collections.unmodifiableSet(data.keySet());
    }

    public Set<Event> getRange() {
        return data.values().stream().flatMap(Collection::stream).collect(Collectors.toUnmodifiableSet());
    }

    public Set<Event> getRange(Event e) {
        return Collections.unmodifiableSet(data.getOrDefault(e, Set.of()));
    }

    public boolean addRange(Event e, Set<Event> range) {
        if (!range.isEmpty()) {
            return data.computeIfAbsent(e, x -> new HashSet<>()).addAll(range);
        }
        return false;
    }

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

    public void apply(BiConsumer<Event, Event> f) {
        data.forEach((e1, value) -> value.forEach(e2 -> f.accept(e1, e2)));
    }

    public static EventGraph union(EventGraph first, EventGraph second) {
        EventGraph result = new EventGraph();
        first.data.forEach((e1, set) -> result.data.put(e1, new HashSet<>(set)));
        second.data.forEach((e1, set) -> result.data.computeIfAbsent(e1, x -> new HashSet<>()).addAll(set));
        return result;
    }

    public static EventGraph intersection(EventGraph first, EventGraph second) {
        EventGraph result = new EventGraph();
        first.data.forEach((e1, firstSet) -> {
            Set<Event> secondSet = second.data.get(e1);
            if (secondSet != null) {
                Set<Event> resultSet = new HashSet<>();
                if (firstSet.size() > secondSet.size()) {
                    resultSet.addAll(firstSet);
                    resultSet.retainAll(secondSet);
                } else {
                    resultSet.addAll(secondSet);
                    resultSet.retainAll(firstSet);
                }
                if (!resultSet.isEmpty()) {
                    result.data.put(e1, resultSet);
                }
            }
        });
        return result;
    }

    public static EventGraph difference(EventGraph first, EventGraph second) {
        EventGraph result = new EventGraph();
        first.data.forEach((e1, firstSet) -> {
            Set<Event> resultSet = new HashSet<>(firstSet);
            Set<Event> secondSet = second.data.get(e1);
            if (secondSet != null) {
                resultSet.removeAll(secondSet);
            }
            if (!resultSet.isEmpty()) {
                result.data.put(e1, resultSet);
            }
        });
        return result;
    }

    public static EventGraph empty() {
        return EmptyEventGraph.singleton;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("[");
        List<Event> keys = data.keySet().stream().sorted().toList();
        for (Event e1 : keys) {
            List<Event> values = data.get(e1).stream().sorted().toList();
            values.forEach(e2 -> sb.append("(")
                    .append(e1.getGlobalId())
                    .append(",")
                    .append(e2.getGlobalId())
                    .append(")"));
        }
        return sb.append("]").toString();
    }
}
