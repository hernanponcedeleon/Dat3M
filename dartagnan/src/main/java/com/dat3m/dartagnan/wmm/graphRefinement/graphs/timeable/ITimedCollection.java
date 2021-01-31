package com.dat3m.dartagnan.wmm.graphRefinement.graphs.timeable;

import java.util.Collection;

public interface ITimedCollection<T extends Timeable> extends Collection<T> {

    int getMinSize();
    int getMaxSize();

    default int getEstimatedSize() {
        return (getMinSize() + getMaxSize() + 1) >> 1;
    }

    @Override
    default boolean remove(Object o) {
        throw new UnsupportedOperationException();
    }

    @Override
    default boolean containsAll(Collection<?> c) {
        for (Object o : c) {
            if (!contains(o))
                return false;
        }
        return true;
    }

    @Override
    default boolean addAll(Collection<? extends T> c) {
        boolean changed = false;
        for (T o : c) {
            changed |= add(o);
        }
        return changed;
    }

    @Override
    default boolean removeAll(Collection<?> c) { throw new UnsupportedOperationException();}

    @Override
    default boolean retainAll(Collection<?> c) { throw new UnsupportedOperationException();}
}
