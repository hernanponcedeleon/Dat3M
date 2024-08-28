package com.dat3m.dartagnan.wmm.utils.graph.immutable;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MapEventGraph;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;

import java.util.*;
import java.util.function.BiConsumer;
import java.util.function.BiPredicate;
import java.util.function.Function;

public class LazyEventGraph implements ImmutableEventGraph {

    private final Set<Event> domain;
    private final Set<Event> range;
    private final BiPredicate<Event, Event> function;
    private final boolean empty;
    private int size = -1;

    public LazyEventGraph(Set<Event> domain, Set<Event> range,
                          BiPredicate<Event, Event> function) {
        this.domain = ImmutableSet.copyOf(domain);
        this.range = ImmutableSet.copyOf(range);
        this.function = function;
        this.empty = domain.stream().noneMatch(e1 -> range.stream().anyMatch((e2 -> function.test(e1, e2))));
    }

    public BiPredicate<Event, Event> getFunction() {
        return function;
    }

    @Override
    public boolean isEmpty() {
        return empty;
    }

    @Override
    public int size() {
        if (size == -1) {
            size = domain.stream().parallel()
                    .map(e1 -> range.stream().filter(e2 -> function.test(e1, e2)).count())
                    .map(s -> Integer.parseInt(s.toString()))
                    .reduce(0, Integer::sum);
        }
        return size;
    }

    @Override
    public boolean contains(Event e1, Event e2) {
        return domain.contains(e1) && range.contains(e2) && function.test(e1, e2);
    }

    @Override
    public LazyEventGraph inverse() {
        return new LazyEventGraph(range, domain, (e1, e2) -> function.test(e2, e1));
    }

    @Override
    public LazyEventGraph filter(BiPredicate<Event, Event> f) {
        Set<Event> newDomain = domain.stream().unordered().parallel()
                .filter(e1 -> range.stream().anyMatch(e2 -> function.test(e1, e2) && f.test(e1, e2)))
                .collect(ImmutableSet.toImmutableSet());
        Set<Event> newRange = range.stream().unordered().parallel()
                .filter(e2 -> domain.stream().anyMatch(e1 -> function.test(e1, e2) && f.test(e1, e2)))
                .collect(ImmutableSet.toImmutableSet());
        return new LazyEventGraph(newDomain, newRange, (e1, e2) -> function.test(e1, e2) && f.test(e1, e2));
    }

    @Override
    public Map<Event, Set<Event>> getOutMap() {
        ImmutableMap.Builder<Event, Set<Event>> builder = new ImmutableMap.Builder<>();
        for (Event e1 : domain) {
            Set<Event> set = range.stream()
                    .filter(e2 -> function.test(e1, e2))
                    .collect(ImmutableSet.toImmutableSet());
            if (!set.isEmpty()) {
                builder.put(e1, set);
            }
        }
        return builder.build();
    }

    @Override
    public Map<Event, Set<Event>> getInMap() {
        return inverse().getOutMap();
    }

    @Override
    public Set<Event> getDomain() {
        return domain;
    }

    @Override
    public Set<Event> getRange() {
        return range;
    }

    @Override
    public Set<Event> getRange(Event e1) {
        if (domain.contains(e1)) {
            return range.stream()
                    .filter(e2 -> function.test(e1, e2))
                    .collect(ImmutableSet.toImmutableSet());
        }
        return Set.of();
    }

    @Override
    public void apply(BiConsumer<Event, Event> f) {
        for (Event e1 : domain) {
            for (Event e2 : range) {
                if (function.test(e1, e2)) {
                    f.accept(e1, e2);
                }
            }
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof LazyEventGraph that)) return false;
        return Objects.equals(domain, that.domain) && Objects.equals(range, that.range) && Objects.equals(function, that.function);
    }

    @Override
    public int hashCode() {
        return Objects.hash(domain, range, function);
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("[");
        for (Event e1 : domain.stream().sorted().toList()) {
            for (Event e2 : range.stream().sorted().toList()) {
                if (function.test(e1, e2)) {
                    sb.append("(")
                            .append(e1.getGlobalId())
                            .append(",")
                            .append(e2.getGlobalId())
                            .append(")");
                }
            }
        }
        return sb.append("]").toString();
    }

    public static LazyEventGraph empty() {
        return EmptyEventGraph.instance;
    }

    public static LazyEventGraph from(EventGraph other) {
        if (other.isEmpty()) {
            return EmptyEventGraph.instance;
        }
        if (other instanceof LazyEventGraph iOther) {
            return iOther;
        }
        if (other instanceof ImmutableMapEventGraph) {
            return new LazyEventGraph(other.getDomain(), other.getRange(), other::contains);
        }
        if (other instanceof MapEventGraph) {
            return LazyEventGraph.from(ImmutableMapEventGraph.from(other));
        }
        throw new IllegalArgumentException("Unexpected type of event graph " + other.getClass().getSimpleName());
    }

    public static LazyEventGraph union(EventGraph... operands) {
        operands = Arrays.stream(operands).filter(o -> !o.isEmpty()).toArray(EventGraph[]::new);
        if (operands.length == 0) {
            return EmptyEventGraph.instance;
        }
        if (operands.length == 1) {
            return LazyEventGraph.from(operands[0]);
        }

        BiPredicate<Event, Event> function = computeUnionFunction(operands);
        Set<Event> domain = Arrays.stream(operands).unordered().parallel()
                .flatMap(o -> o.getDomain().stream())
                .collect(ImmutableSet.toImmutableSet());
        Set<Event> range = Arrays.stream(operands).unordered().parallel()
                .flatMap(o -> o.getRange().stream())
                .collect(ImmutableSet.toImmutableSet());

        return new LazyEventGraph(domain, range, function);
    }

    public static LazyEventGraph intersection(EventGraph... operands) {
        if (Arrays.stream(operands).anyMatch(EventGraph::isEmpty)) {
            return EmptyEventGraph.instance;
        }
        if (operands.length == 1) {
            return LazyEventGraph.from(operands[0]);
        }

        BiPredicate<Event, Event> function = computeIntersectionFunction(operands);
        Set<Event> baseDomain = computeBaseIntersection(EventGraph::getDomain, operands);
        Set<Event> baseRange = computeBaseIntersection(EventGraph::getRange, operands);
        Set<Event> domain = baseDomain.stream()
                .filter(e1 -> baseRange.stream()
                        .anyMatch(e2 -> function.test(e1, e2)))
                .collect(ImmutableSet.toImmutableSet());
        Set<Event> range = baseRange.stream()
                .filter(e2 -> domain.stream()
                        .anyMatch(e1 -> function.test(e1, e2)))
                .collect(ImmutableSet.toImmutableSet());

        return new LazyEventGraph(domain, range, function);
    }

    public static LazyEventGraph difference(EventGraph minuend, EventGraph subtrahend) {
        if (minuend.isEmpty() || subtrahend.isEmpty()) {
            LazyEventGraph.from(minuend);
        }

        BiPredicate<Event, Event> function = computeDifferenceFunction(minuend, subtrahend);
        Set<Event> baseRange = minuend.getRange();
        Set<Event> domain = minuend.getDomain().stream().unordered().parallel()
                .filter(e1 -> baseRange.stream().anyMatch(e2 -> function.test(e1, e2)))
                .collect(ImmutableSet.toImmutableSet());
        Set<Event> range = baseRange.stream().unordered().parallel()
                .filter(e2 -> domain.stream().anyMatch(e1 -> function.test(e1, e2)))
                .collect(ImmutableSet.toImmutableSet());

        return new LazyEventGraph(domain, range, function);
    }

    private static BiPredicate<Event, Event> computeUnionFunction(EventGraph... operands) {
        List<ImmutableEventGraph> iOperands = Arrays.stream(operands)
                .map(ImmutableEventGraph::from)
                .toList();
        return (e1, e2) -> iOperands.stream().anyMatch(o -> o.contains(e1, e2));
    }

    private static BiPredicate<Event, Event> computeIntersectionFunction(EventGraph... operands) {
        List<ImmutableEventGraph> iOperands = Arrays.stream(operands)
                .map(ImmutableEventGraph::from)
                .toList();
        List<BiPredicate<Event, Event>> functions = iOperands.stream()
                .map(eg -> eg instanceof LazyEventGraph leg ? leg.function : (BiPredicate<Event, Event>) eg::contains)
                .toList();
        return (e1, e2) -> functions.stream().allMatch(f -> f.test(e1, e2));
    }

    private static BiPredicate<Event, Event> computeDifferenceFunction(EventGraph minuend, EventGraph subtrahend) {
        ImmutableEventGraph iMinuend = ImmutableEventGraph.from(minuend);
        ImmutableEventGraph iSubtrahend = ImmutableEventGraph.from(subtrahend);
        BiPredicate<Event, Event> firstFunction = iMinuend instanceof LazyEventGraph leg ? leg.function : iMinuend::contains;
        return (e1, e2) -> firstFunction.test(e1, e2) && !iSubtrahend.contains(e1, e2);
    }

    private static Set<Event> computeBaseIntersection(Function<EventGraph, Set<Event>> f, EventGraph... data) {
        List<Set<Event>> sorted = Arrays.stream(data)
                .map(f)
                .sorted(Comparator.comparing(Set::size))
                .toList();
        Set<Event> base = new HashSet<>(sorted.get(0));
        for (int i = 1; i < sorted.size(); i++) {
            base.retainAll(sorted.get(i));
        }
        return base;
    }

    public static class EmptyEventGraph extends LazyEventGraph {

        private static final EmptyEventGraph instance = new EmptyEventGraph();

        private EmptyEventGraph() {
            super(Set.of(), Set.of(), (e1, e2) -> false);
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
