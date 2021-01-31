package com.dat3m.dartagnan.wmm.graphRefinement.graphs.timeable;

import java.util.Collection;
import java.util.Iterator;
import java.util.Set;

public class TimedIterableSet<T extends Timeable> implements ITimedCollection<T>, Set<T> {

    private final TimedSet<T> set;
    private final TimedCollection<T> coll;

    public TimedIterableSet() {
        set = new TimedSet<>();
        coll = new TimedCollection<>();
    }

    public T getEntry(Object item) {
        return set.getEntry(item);
    }

    @Override
    public int getEstimatedSize() {
        return coll.getEstimatedSize();
    }

    @Override
    public int getMinSize() {
        return coll.getMinSize();
    }

    @Override
    public int getMaxSize() {
        return coll.getMaxSize();
    }

    @Override
    public int size() {
        return coll.size();
    }

    @Override
    public boolean isEmpty() {
        return coll.isEmpty();
    }

    @Override
    public boolean contains(Object o) {
        return set.contains(o);
    }

    @Override
    public Iterator<T> iterator() {
        return coll.iterator();
    }

    @Override
    public Object[] toArray() {
        return coll.toArray();
    }

    @Override
    public <T1> T1[] toArray(T1[] a) {
        return coll.toArray(a);
    }

    @Override
    public boolean add(T t) {
        if (set.add(t)) {
            coll.add(t);
            return true;
        }
        return false;
    }

    @Override
    public void clear() {
        coll.clear();
        set.clear();
    }


    // The ITimedCollection interface already provides these methods
    // but the Set interface demands this class to directly implement
    // the methods.

    @Override
    public boolean remove(Object o) {
        return set.remove(o);
    }

    @Override
    public boolean containsAll(Collection<?> c) {
        return set.containsAll(c);
    }

    @Override
    public boolean addAll(Collection<? extends T> c) {
        return set.addAll(c);
    }

    @Override
    public boolean removeAll(Collection<?> c) {
        return set.removeAll(c);
    }

    @Override
    public boolean retainAll(Collection<?> c) {
        return set.retainAll(c);
    }
}
