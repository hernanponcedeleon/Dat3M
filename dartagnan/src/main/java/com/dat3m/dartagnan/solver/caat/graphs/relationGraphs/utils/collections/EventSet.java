package com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.utils.collections;

import com.dat3m.dartagnan.verification.model.EventData;

import java.util.*;
import java.util.stream.Stream;

/*
    TODO: This can be generalized to an EventMap
 */
public class EventSet implements Set<EventData> {

    private EventData[] events = new EventData[0];
    int size = 0;

    public EventSet() {
        this(20);
    }

    public EventSet(int capacity) {
        ensureCapacity(capacity);
    }

    public void ensureCapacity(int capacity) {
        if (capacity > events.length) {
            events = Arrays.copyOf(events, capacity);
        }
    }

    @Override
    public int size() {
        return size;
    }

    @Override
    public boolean isEmpty() {
        return size == 0;
    }

    public boolean contains(EventData e) {
        return events[e.getId()] != null;
    }

    @Override
    public boolean contains(Object o) {
        return o instanceof EventData && contains((EventData) o);
    }

    @Override
    public Iterator<EventData> iterator() {
        return new EventIterator(events, size);
    }

    @Override
    public Stream<EventData> stream() {
        return Arrays.stream(events).filter(Objects::nonNull);
    }

    @Override
    public Object[] toArray() {
        return Arrays.stream(events).toArray();
    }

    @Override
    public <T> T[] toArray(T[] a) {
        return (T[])Arrays.stream(events).toArray(Object[]::new);
    }

    @Override
    public boolean add(EventData e) {
        boolean notContains = !contains(e);
        if (notContains) {
            events[e.getId()] = e;
            size++;
        }
        return notContains;
    }

    public boolean remove(EventData e) {
        boolean contains = contains(e);
        if (contains) {
            events[e.getId()] = null;
            size--;
        }
        return contains;
    }

    @Override
    public boolean remove(Object o) {
        return o instanceof EventData && remove((EventData) o);
    }

    @Override
    public boolean containsAll(Collection<?> c) {
        for (Object o : c) {
            if (!contains(o)) {
                return false;
            }
        }
        return true;
    }

    @Override
    public boolean addAll(Collection<? extends EventData> c) {
        boolean changed = false;
        for (EventData e : c) {
            changed |= add(e);
        }
        return changed;
    }

    @Override
    public boolean retainAll(Collection<?> c) {
        boolean changed = false;
        for (int i = 0; i < events.length; i++) {
            EventData e = events[i];
            if (e != null && c.contains(e)) {
                events[i] = null;
                size--;
                changed = true;
            }
        }
        return changed;
    }

    @Override
    public boolean removeAll(Collection<?> c) {
       boolean changed = false;
       for (Object o : c) {
           changed |= remove(o);
       }
       return changed;
    }

    @Override
    public void clear() {
        if (size > 0) {
            Arrays.fill(events, null);
            size = 0;
        }
    }



    private static class EventIterator implements Iterator<EventData> {
        final EventData[] events;
        int index;
        int size;

        public EventIterator(EventData[] events, int size) {
            this.events = events;
            this.size = size;
            index = 0;
        }


        @Override
        public boolean hasNext() {
            return size > 0 && index < events.length;
        }

        @Override
        public EventData next() {
            EventData e;
            do {
                e = events[index++];
            } while (e == null);
            size--;
            return e;
        }
    }
}
