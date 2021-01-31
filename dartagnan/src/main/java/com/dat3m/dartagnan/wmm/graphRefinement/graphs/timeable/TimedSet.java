package com.dat3m.dartagnan.wmm.graphRefinement.graphs.timeable;

import java.util.*;

public class TimedSet<T extends Timeable> extends AbstractTimedCollection<T> implements Set<T> {
    private final HashMap<T, T> map;

    public TimedSet() {
        super();
        map = new HashMap<>();
    }

    private void validate() {
        if (maxTime.isValid())
            return;
        map.values().removeIf(Timeable::isInvalid);
        minSize = 0;
        maxTime = Timestamp.ZERO;
        for (T item : map.values()) {
            maxTime = Timestamp.max(maxTime, item.getTime());
        }
    }

    @Override
    public int getMaxSize() {
        return map.size();
    }


    @Override
    public int size() {
        validate();
        return map.size();
    }

    @Override
    public boolean isEmpty() {
        if (minSize > 0)
            return false;
        validate();
        return map.size() == 0;
    }

    public T getEntry(Object o) {
        T item = map.get(o);
        if (item == null) {
            return null;
        } else if (item.isInvalid()) {
            map.remove(o);
            return null;
        }
        return item;
    }

    @Override
    public boolean contains(Object o) {
        return getEntry(o) != null;
    }

    @Override
    public boolean add(T t) {
        if (t.isInvalid())
            return false;
        T item = map.get(t);
        if (item == null) {
            if (maxTime.isInvalid() && 2*getMinSize() < getMaxSize()) {
                // We delete entries instead of directly adding to
                // (1) prevent unnecessary resizing and
                // (2) prevent too many dead object to pile up.
                // If we had access to the HashMap's capacity, we could more accurately
                // judge when to delete.
                validate();
            }
        } else if (item.getTime().compareTo(t.getTime()) <= 0) {
            return false;
        }
        map.put(t, t);
        super.add(t);
        return true;
    }

    @Override
    public void clear() {
        super.clear();
        map.clear();
    }

    @Override
    public Iterator<T> iterator() {
        return maxTime.isValid() ? map.values().iterator() : new TimedIterator();
    }

    @Override
    public Object[] toArray() {
        validate();
        return map.values().toArray();
    }

    @Override
    public <T1> T1[] toArray(T1[] a) {
        validate();
        return map.values().toArray(a);
    }


    private class TimedIterator implements Iterator<T> {
        final Iterator<T> iter = map.values().iterator();
        T item;
        Timestamp curMax = Timestamp.ZERO;

        public TimedIterator() {
            findNext();
        }

        private void findNext() {
            final Iterator<T> it = iter;

            while (it.hasNext()) {
                item = it.next();
                if (item.isInvalid()) {
                    it.remove();
                } else {
                    curMax = Timestamp.max(curMax, item.getTime());
                    return;
                }
            }
            item = null;
            maxTime = curMax;
        }


        @Override
        public boolean hasNext() {
            return item != null;
        }

        @Override
        public T next() {
            T next = item;
            findNext();
            return next;
        }
    }



    // The AbstractTimedCollection already provides these methods
    // but the Set interface demands this class to directly implement
    // the methods.

    @Override
    public boolean remove(Object o) {
        return super.remove(o);
    }

    @Override
    public boolean containsAll(Collection<?> c) {
        return super.containsAll(c);
    }

    @Override
    public boolean addAll(Collection<? extends T> c) {
        return super.addAll(c);
    }

    @Override
    public boolean removeAll(Collection<?> c) {
        return super.removeAll(c);
    }

    @Override
    public boolean retainAll(Collection<?> c) {
        return super.retainAll(c);
    }
}
