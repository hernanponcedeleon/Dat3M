package com.dat3m.dartagnan.wmm.utils.graph.mutable;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.collections.IndexedDomain;
import com.dat3m.dartagnan.utils.collections.IndexedSet;
import com.dat3m.dartagnan.wmm.utils.Dimension;
import com.dat3m.dartagnan.wmm.utils.graph.AbstractEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.google.common.base.Preconditions;

import java.util.*;
import java.util.function.BiConsumer;
import java.util.function.BiPredicate;

/// Maps domain-side events to the set of connected range-side events.
// This implementation uses `IndexedDomain` to organise its elements.
public final class IndexedEventGraph extends AbstractEventGraph implements MutableEventGraph {
    // Corresponds to the set of elements with `map[i] != null && !map[i].isEmpty()`
    private final IndexedSet<Event> domain;
    // Placeholder for `getRange(Event)`, refers to the range event domain.
    private final IndexedSet<Event> emptyRange;
    // Does never contain empty sets.
    private final IndexedSet<Event>[] map;
    // Always corresponds to the sum of sizes in `map`.
    private int size;

    public IndexedEventGraph(IndexedDomain<Event> domain) {
        this(domain, domain);
    }

    public IndexedEventGraph(IndexedDomain<Event> domain, IndexedDomain<Event> range) {
        this(domain.newSet(), range.emptySet(), 0);
    }

    public IndexedEventGraph(IndexedEventGraph original) {
        this(new IndexedSet<>(original.domain), original.emptyRange, 0);
        for (int index = 0; index < map.length; index++) {
            map[index] = original.map[index] == null ? null : new IndexedSet<>(original.map[index]);
        }
        size = original.size;
    }

    public IndexedEventGraph(IndexedDomain<Event> domain, IndexedDomain<Event> range, EventGraph original) {
        this(domain.newSet(), range.emptySet(), 0);
        addAll(original);
    }

    @SuppressWarnings("unchecked")
    private IndexedEventGraph(IndexedSet<Event> d, IndexedSet<Event> r, int ignore) {
        domain = d;
        emptyRange = r;
        map = (IndexedSet<Event>[]) new IndexedSet[d.domain().size()];
    }

    public IndexedDomain<Event> eventDomain(Dimension dimension) {
        return switch (dimension) {
            case DOMAIN -> domain.domain();
            case RANGE -> emptyRange.domain();
        };
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
        final IndexedSet<Event> set = outSetAt(domain.domain().indexOf(e1));
        return set != null && set.contains(e2);
    }

    @Override
    public IndexedEventGraph inverse() {
        final var inverse = new IndexedEventGraph(rangeEvents().newSet(), domainEvents().emptySet(), 0);
        for (int i = 0; i < map.length; i++) {
            final IndexedSet<Event> outSet = outSetAt(i);
            if (outSet != null) {
                for (int j : outSet.toIndexArray()) {
                    inverse.map[j] = Objects.requireNonNullElseGet(inverse.map[j], domainEvents()::newSet);
                    inverse.map[j].exchange(i, true);
                    inverse.domain.exchange(j, true);
                }
            }
        }
        inverse.size = size;
        return inverse;
    }

    @Override
    public IndexedEventGraph filter(BiPredicate<Event, Event> f) {
        final var out = new IndexedEventGraph(domainEvents().newSet(), emptyRange, 0);
        for (int i = 0; i < map.length; i++) {
            final Event e1 = domainEvents().element(i);
            final IndexedSet<Event> outSet = outSetAt(i);
            if (outSet != null) {
                final IndexedSet<Event> set = new IndexedSet<>(outSet);
                set.removeIf(e2 -> !f.test(e1, e2));
                out.map[i] = set.isEmpty() ? null : set;
                out.domain.exchange(i, !set.isEmpty());
                out.size += set.size();
            }
        }
        return out;
    }

    @Override
    public Map<Event, Set<Event>> getOutMap() {
        final var outMap = new HashMap<Event, Set<Event>>();
        for (int i = 0; i < map.length; i++) {
            final IndexedSet<Event> outSet = outSetAt(i);
            if (outSet != null) {
                outMap.put(domainEvents().element(i), new IndexedSet<>(outSet));
            }
        }
        return outMap;
    }

    @Override
    public Map<Event, Set<Event>> getInMap() {
        final var inMap = new HashMap<Event, Set<Event>>();
        for (int index = 0; index < map.length; index++) {
            final IndexedSet<Event> outSet = outSetAt(index);
            if (outSet != null) {
                for (Event e2 : outSet) {
                    final Set<Event> set = inMap.computeIfAbsent(e2, k -> domainEvents().newSet());
                    ((IndexedSet<Event>) set).exchange(index, true);
                }
            }
        }
        return inMap;
    }

    @Override
    public IndexedSet<Event> getDomain() {
        return domain.toUnmodifiableCopy();
    }

    @Override
    public IndexedSet<Event> getRange() {
        final IndexedSet<Event> range = rangeEvents().newSet();
        for (IndexedSet<Event> outSet : map) {
            if (outSet != null) {
                range.addAll(outSet);
            }
        }
        return range;
    }

    @Override
    public IndexedSet<Event> getRange(Event e) {
        final IndexedSet<Event> range = outSetAt(domainEvents().indexOf(e));
        return range == null ? emptyRange : range.toUnmodifiableCopy();
    }

    @Override
    public void apply(BiConsumer<Event, Event> f) {
        for (int i = 0; i < map.length; i++) {
            final IndexedSet<Event> range = outSetAt(i);
            if (range != null) {
                final Event e1 = domain.domain().element(i);
                for (Event e2 : range) {
                    f.accept(e1, e2);
                }
            }
        }
    }

    @Override
    public boolean add(Event e1, Event e2) {
        final int index = domainEvents().indexOf(e1);
        final IndexedSet<Event> foundOutSet = outSetAt(index);
        final IndexedSet<Event> outSet = foundOutSet != null ? foundOutSet : rangeEvents().newSet();
        map[index] = outSet;
        final boolean changed = outSet.add(e2);
        size += changed ? 1 : 0;
        domain.exchange(index, true);
        return changed;
    }

    @Override
    public boolean remove(Event e1, Event e2) {
        final int index = domainEvents().indexOf(e1);
        final IndexedSet<Event> outSet = outSetAt(index);
        if (outSet == null) {
            return false;
        }
        final boolean changed = outSet.remove(e2);
        map[index] = changed && outSet.isEmpty() ? null : map[index];
        size -= changed ? 1 : 0;
        domain.exchange(index, map[index] != null);
        return changed;
    }

    @Override
    public boolean addAll(EventGraph other) {
        if (other instanceof IndexedEventGraph indexedOther
                && domain.domain().isCompatibleWith(indexedOther.domain.domain())
                && emptyRange.domain().isCompatibleWith(indexedOther.emptyRange.domain())) {
            int diff = 0;
            for (int index = 0; index < map.length; index++) {
                final IndexedSet<Event> otherOutSet = indexedOther.outSetAt(index);
                if (otherOutSet != null) {
                    final IndexedSet<Event> foundOutSet = outSetAt(index);
                    final IndexedSet<Event> outSet = foundOutSet != null ? foundOutSet : emptyRange.domain().newSet();
                    diff -= foundOutSet == null ? 0 : outSet.size();
                    outSet.addAll(otherOutSet);
                    diff += outSet.size();
                    map[index] = outSet;
                    domain.exchange(index, true);
                }
            }
            size += diff;
            assert diff >= 0;
            return diff > 0;
        } else {
            final int oldSize = size;
            other.apply(this::add);
            return size != oldSize;
        }
    }

    @Override
    public boolean removeAll(EventGraph other) {
        if (other instanceof IndexedEventGraph indexedOther
                && domainEvents().isCompatibleWith(indexedOther.domainEvents())
                && rangeEvents().isCompatibleWith(indexedOther.rangeEvents())) {
            int diff = 0;
            for (int index = 0; index < map.length; index++) {
                final IndexedSet<Event> otherOutSet = indexedOther.outSetAt(index);
                final IndexedSet<Event> outSet = outSetAt(index);
                if (otherOutSet != null && outSet != null) {
                    diff -= outSet.size();
                    outSet.removeAll(otherOutSet);
                    diff += outSet.size();
                    map[index] = outSet.isEmpty() ? null : outSet;
                    domain.exchange(index, map[index] != null);
                }
            }
            size += diff;
            assert diff <= 0;
            return diff < 0;
        } else {
            final int oldSize = size;
            other.apply(this::remove);
            return size != oldSize;
        }
    }

    @Override
    public boolean retainAll(EventGraph other) {
        int diff = 0;
        if (other instanceof IndexedEventGraph indexedOther
                && domainEvents().isCompatibleWith(indexedOther.domainEvents())
                && rangeEvents().isCompatibleWith(indexedOther.rangeEvents())) {
            for (int index = 0; index < map.length; index++) {
                final IndexedSet<Event> outSet = outSetAt(index);
                if (outSet != null) {
                    final IndexedSet<Event> otherOutSet = indexedOther.outSetAt(index);
                    diff -= outSet.size();
                    if (otherOutSet != null) {
                        outSet.retainAll(otherOutSet);
                        diff += outSet.size();
                        map[index] = outSet.isEmpty() ? null : outSet;
                    } else {
                        map[index] = null;
                    }
                    domain.exchange(index, map[index] != null);
                }
            }
        } else {
            for (int index = 0; index < map.length; index++) {
                final IndexedSet<Event> outSet = outSetAt(index);
                if (outSet != null) {
                    diff -= outSet.size();
                    outSet.retainAll(other.getRange(domainEvents().element(index)));
                    diff += outSet.size();
                    map[index] = outSet.isEmpty() ? null : outSet;
                    domain.exchange(index, map[index] != null);
                }
            }
        }
        size += diff;
        assert diff <= 0;
        return diff < 0;
    }

    @Override
    public boolean addRange(Event e, Set<Event> range) {
        final int index = domainEvents().indexOf(e);
        final IndexedSet<Event> foundOutSet = outSetAt(index);
        final IndexedSet<Event> outSet = foundOutSet != null ? foundOutSet : rangeEvents().newSet();
        final int oldSize = foundOutSet == null ? 0 : outSet.size();
        outSet.addAll(range);
        final int newSize = outSet.size();
        map[index] = newSize == 0 ? null : outSet;
        domain.exchange(index, map[index] != null);
        size += newSize - oldSize;
        return newSize > oldSize;
    }

    @Override
    public boolean removeIf(BiPredicate<Event, Event> f) {
        boolean changed = false;
        for (int index = 0; index < map.length; index++) {
            final Event e1 = domainEvents().element(index);
            final IndexedSet<Event> outSet = outSetAt(index);
            if (outSet != null) {
                final int oldSize = outSet.size();
                changed |= outSet.removeIf(e2 -> f.test(e1, e2));
                size -= oldSize - outSet.size();
                map[index] = outSet.isEmpty() ? null : outSet;
                domain.exchange(index, map[index] != null);
            }
        }
        return changed;
    }

    public static IndexedEventGraph union(EventGraph... operands) {
        final IndexedDomain<Event> domain = Arrays.stream(operands)
                .filter(IndexedEventGraph.class::isInstance)
                .map(operand -> ((IndexedEventGraph) operand).eventDomain(Dimension.DOMAIN))
                .max(Comparator.comparingInt(IndexedDomain::size))
                .orElseThrow(() -> new IllegalArgumentException("Missing domain for graph union."));
        final IndexedDomain<Event> range = Arrays.stream(operands)
                .filter(IndexedEventGraph.class::isInstance)
                .map(operand -> ((IndexedEventGraph) operand).eventDomain(Dimension.RANGE))
                .max(Comparator.comparingInt(IndexedDomain::size)).orElseThrow();
        final var union = new IndexedEventGraph(domain.newSet(), range.emptySet(), 0);
        Arrays.stream(operands).forEach(union::addAll);
        return union;
    }

    public static IndexedEventGraph intersection(EventGraph... operands) {
        final IndexedEventGraph indexedOperand = Arrays.stream(operands)
                .filter(IndexedEventGraph.class::isInstance)
                .map(IndexedEventGraph.class::cast)
                .findAny().orElseThrow(() -> new IllegalArgumentException("Missing domain for graph intersection."));
        final var intersection = new IndexedEventGraph(indexedOperand);
        Arrays.stream(operands).filter(operand -> operand != indexedOperand).forEach(intersection::retainAll);
        return intersection;
    }

    public static IndexedEventGraph difference(EventGraph minuend, EventGraph subtrahend) {
        Preconditions.checkArgument(minuend instanceof IndexedEventGraph, "Missing domain for graph difference.");
        final var difference = new IndexedEventGraph((IndexedEventGraph) minuend);
        difference.removeAll(subtrahend);
        return difference;
    }

    public static boolean isUnionFeasible(EventGraph... operands) {
        if (operands.length == 0 || !(operands[0] instanceof IndexedEventGraph firstOperand)) {
            return false;
        }
        final IndexedDomain<Event> firstDomain = firstOperand.eventDomain(Dimension.DOMAIN);
        final IndexedDomain<Event> firstRange = firstOperand.eventDomain(Dimension.RANGE);
        return Arrays.stream(operands, 1, operands.length)
                .allMatch(operand -> operand instanceof IndexedEventGraph o
                        && o.eventDomain(Dimension.DOMAIN).isCompatibleWith(firstDomain)
                        && o.eventDomain(Dimension.RANGE).isCompatibleWith(firstRange));
    }

    public static boolean isIntersectionFeasible(EventGraph... operands) {
        return Arrays.stream(operands).anyMatch(IndexedEventGraph.class::isInstance);
    }

    public static boolean isDifferenceFeasible(EventGraph minuend, EventGraph ignoreSubtrahend) {
        return minuend instanceof IndexedEventGraph;
    }

    private IndexedDomain<Event> domainEvents() {
        return domain.domain();
    }

    private IndexedDomain<Event> rangeEvents() {
        return emptyRange.domain();
    }

    private IndexedSet<Event> outSetAt(int index) {
        return index < 0 || index >= map.length ? null : map[index];
    }
}
