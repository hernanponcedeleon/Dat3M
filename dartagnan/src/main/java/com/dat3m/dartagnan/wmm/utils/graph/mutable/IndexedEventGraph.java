package com.dat3m.dartagnan.wmm.utils.graph.mutable;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.collections.IndexedSet;
import com.dat3m.dartagnan.utils.collections.OneTimeIterable;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;

import java.util.*;
import java.util.function.BiConsumer;
import java.util.function.BiPredicate;

public final class IndexedEventGraph implements MutableEventGraph {
    // Invariants
    // `domain != null`
    // `map != null`
    // `map.length == domain.size()`
    // `Arrays.stream(map).allMatch(m -> m == null || m.domain().equals(domain))`
    // `size == Arrays.stream(map).filter(Objects::nonNull).mapToInt(IndexedSet::size).sum()`
    private final IndexedSet.Domain<Event> eventDomain;
    private final IndexedSet[] map;
    private int size;

    public IndexedEventGraph(IndexedSet.Domain<Event> d) {
        this(d, 0);
    }

    public IndexedEventGraph(IndexedEventGraph g) {
        this(g.eventDomain, g);
    }

    public IndexedEventGraph(IndexedSet.Domain<Event> d, EventGraph g) {
        this(d, 0);
        //TODO assume this graph is empty
        addAll(g);
    }

    private IndexedEventGraph(IndexedSet.Domain<Event> d, int ignore) {
        eventDomain = d;
        map = new IndexedSet[d.size()];
    }

    public IndexedSet.Domain<Event> eventDomain() {
        return eventDomain;
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
        final IndexedSet<Event> set = outSet(e1);
        return set != null && set.contains(e2);
    }

    @Override
    public IndexedEventGraph inverse() {
        final var inverse = new IndexedEventGraph(eventDomain, 0);
        for (int i = 0; i < map.length; i++) {
            final IndexedSet<Event> outSet = outSetAt(i);
            if (outSet != null) {
                for (int j : OneTimeIterable.create(outSet.indexIterator())) {
                    inverse.map[j] = Objects.requireNonNullElseGet(inverse.map[j], () -> new IndexedSet<>(eventDomain));
                    inverse.map[j].exchange(i, true);
                }
            }
        }
        inverse.size = size;
        return inverse;
    }

    @Override
    public MutableEventGraph filter(BiPredicate<Event, Event> f) {
        final IndexedEventGraph out = new IndexedEventGraph(eventDomain);
        for (int i = 0; i < map.length; i++) {
            final Event e1 = eventDomain.element(i);
            final IndexedSet<Event> outSet = outSetAt(i);
            if (outSet != null) {
                final IndexedSet<Event> set = new IndexedSet<>(outSet);
                set.removeIf(e2 -> !f.test(e1, e2));
                out.map[i] = set.isEmpty() ? null : set;
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
                outMap.put(eventDomain.element(i), new IndexedSet<>(outSet));
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
                    final Set<Event> set = inMap.computeIfAbsent(e2, k -> new IndexedSet<>(eventDomain));
                    ((IndexedSet<Event>) set).exchange(index, true);
                }
            }
        }
        return inMap;
    }

    @Override
    public Set<Event> getDomain() {
        final IndexedSet<Event> domain = new IndexedSet<>(eventDomain);
        for (int i = 0; i < map.length; i++) {
            if (map[i] != null) {
                domain.exchange(i, true);
            }
        }
        return domain;
    }

    @Override
    public Set<Event> getRange() {
        final IndexedSet<Event> range = new IndexedSet<>(eventDomain);
        for (IndexedSet<Event> outSet : map) {
            if (outSet != null) {
                range.addAll(outSet);
            }
        }
        return range;
    }

    @Override
    public Set<Event> getRange(Event e) {
        final IndexedSet<Event> range = outSet(e);
        return range == null ? Set.of() : new IndexedSet.Immutable<>(range);
    }

    @Override
    public void apply(BiConsumer<Event, Event> f) {
        for (int i = 0; i < map.length; i++) {
            final IndexedSet<Event> range = outSetAt(i);
            if (range != null) {
                final Event e1 = eventDomain.element(i);
                for (Event e2 : range) {
                    f.accept(e1, e2);
                }
            }
        }
    }

    @Override
    public boolean add(Event e1, Event e2) {
        final int index = eventDomain.indexOf(e1);
        final IndexedSet<Event> outSet = ensureOutSetAt(index);
        map[index] = outSet;
        final boolean changed = outSet.add(e2);
        size += changed ? 1 : 0;
        return changed;
    }

    @Override
    public boolean remove(Event e1, Event e2) {
        final int index = eventDomain.indexOf(e1);
        final IndexedSet<Event> outSet = outSetAt(index);
        final boolean changed = outSet != null && outSet.remove(e2);
        map[index] = changed && outSet.isEmpty() ? null : map[index];
        size -= changed ? 1 : 0;
        return changed;
    }

    @Override
    public boolean addAll(EventGraph other) {
        if (other instanceof IndexedEventGraph indexedOther && eventDomain.equals(indexedOther.eventDomain)) {
            int diff = 0;
            for (int index = 0; index < map.length; index++) {
                final IndexedSet<Event> otherOutSet = indexedOther.outSetAt(index);
                if (otherOutSet != null) {
                    final IndexedSet<Event> outSet = ensureOutSetAt(index);
                    diff -= outSet.size();
                    outSet.addAll(otherOutSet);
                    diff += outSet.size();
                    map[index] = outSet;
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
        if (other instanceof IndexedEventGraph indexedOther && eventDomain.equals(indexedOther.eventDomain)) {
            int diff = 0;
            for (int index = 0; index < map.length; index++) {
                final IndexedSet<Event> otherOutSet = indexedOther.outSetAt(index);
                final IndexedSet<Event> outSet = outSetAt(index);
                if (otherOutSet != null && outSet != null) {
                    diff -= outSet.size();
                    outSet.removeAll(otherOutSet);
                    diff += outSet.size();
                    map[index] = outSet.isEmpty() ? null : outSet;
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
        if (other instanceof IndexedEventGraph indexedOther && eventDomain.equals(indexedOther.eventDomain)) {
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
                }
            }
        } else {
            for (int index = 0; index < map.length; index++) {
                final IndexedSet<Event> outSet = outSetAt(index);
                if (outSet != null) {
                    diff -= outSet.size();
                    outSet.retainAll(other.getRange(eventDomain.element(index)));
                    diff += outSet.size();
                    map[index] = outSet.isEmpty() ? null : outSet;
                }
            }
        }
        size += diff;
        assert diff <= 0;
        return diff < 0;
    }

    @Override
    public boolean addRange(Event e, Set<Event> range) {
        final int index = eventDomain.indexOf(e);
        final IndexedSet<Event> outSet = ensureOutSetAt(index);
        final int oldSize = outSet.size();
        outSet.addAll(range);
        final int diff = outSet.size() - oldSize;
        map[index] = outSet.isEmpty() ? null : outSet;
        size += diff;
        return diff > 0;
    }

    @Override
    public boolean removeIf(BiPredicate<Event, Event> f) {
        boolean changed = false;
        for (int index = 0; index < map.length; index++) {
            final Event e1 = eventDomain.element(index);
            final IndexedSet<Event> outSet = outSetAt(index);
            if (outSet != null) {
                final int oldSize = outSet.size();
                changed |= outSet.removeIf(e2 -> f.test(e1, e2));
                size -= oldSize - outSet.size();
                map[index] = outSet.isEmpty() ? null : outSet;
            }
        }
        return changed;
    }

    private IndexedSet<Event> outSet(Event key) {
        return outSetAt(eventDomain.indexOf(key));
    }

    private IndexedSet<Event> outSetAt(int index) {
        return (IndexedSet<Event>) map[index];
    }

    private IndexedSet<Event> ensureOutSetAt(int index) {
        return (IndexedSet<Event>) Objects.requireNonNullElseGet(map[index], () -> new IndexedSet<>(eventDomain));
    }
}
