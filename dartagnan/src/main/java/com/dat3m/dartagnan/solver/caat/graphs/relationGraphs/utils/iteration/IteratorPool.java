package com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.utils.iteration;

import java.util.ArrayList;
import java.util.Collection;
import java.util.function.Function;

public class IteratorPool<T, V extends Collection<T>> {

    private final ArrayList<ReusableIterator<T, V>> iteratorPool;
    private ReusableIterator<T, V> hotspot;
    private final Function<IteratorPool<T, V>, ? extends ReusableIterator<T, V>> iteratorSupplier;

    public IteratorPool(Function<IteratorPool<T, V>, ? extends ReusableIterator<T, V>> supplier, int capacity) {
        iteratorPool = new ArrayList<>(capacity);
        iteratorSupplier = supplier;
    }

    public ReusableIterator<T, V> get(V collection) {
        ReusableIterator<T, V> iterator;
        if (hotspot != null) {
            iterator = hotspot;
            hotspot = null;
        } else if (iteratorPool.size() > 0) {
            iterator = iteratorPool.get(iteratorPool.size() - 1);
            iteratorPool.remove(iteratorPool.size() - 1);
        } else {
            iterator = iteratorSupplier.apply(this);
        }
        iterator.isInUse = true;
        iterator.reuseFor(collection);
        return iterator;
    }

    public void returnToPool(ReusableIterator<T, V> iterator) {
        // We only return iterators that are in use
        if (iterator.isInUse) {
            iterator.isInUse = false;
            if (hotspot == null) {
                hotspot = iterator;
            } else {
                iteratorPool.add(iterator);
            }
        }
    }

}
