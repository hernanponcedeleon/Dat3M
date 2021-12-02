package com.dat3m.dartagnan.solver.caat.misc;


import java.util.ArrayList;
import java.util.Collection;
import java.util.function.Function;

//TODO: We probably do not need this anymore
public class IteratorPool<T, V extends Collection<T>> {

    private final ArrayList<ReusableIterator<T, V>> iteratorPool;
    private final Function<IteratorPool<T, V>, ? extends ReusableIterator<T, V>> iteratorSupplier;

    public IteratorPool(Function<IteratorPool<T, V>, ? extends ReusableIterator<T, V>> supplier, int capacity) {
        iteratorPool = new ArrayList<>(capacity);
        iteratorSupplier = supplier;
    }

    public ReusableIterator<T, V> get(V collection) {
        final int size = iteratorPool.size();
        ReusableIterator<T, V> iterator = size > 0 ? iteratorPool.remove(size - 1) : iteratorSupplier.apply(this);
        iterator.isInUse = true;
        iterator.reuseFor(collection);
        return iterator;
    }

    public void returnToPool(ReusableIterator<T, V> iterator) {
        // We only return iterators that are in use
        if (iterator.isInUse) {
            iterator.isInUse = false;
            iteratorPool.add(iterator);
        }
    }

}
