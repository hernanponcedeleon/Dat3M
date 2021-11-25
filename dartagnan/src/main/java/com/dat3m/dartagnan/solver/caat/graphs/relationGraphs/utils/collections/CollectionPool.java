package com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.utils.collections;

import java.util.ArrayList;
import java.util.Collection;
import java.util.function.Supplier;

/*
    TODO: We can generalize this to any object pool (there is nothing that makes use of collections)
 */
public class CollectionPool<V extends Collection<?>> implements Supplier<V> {

    private final ArrayList<V> collections;
    private V hotspot;
    private final Supplier<? extends V> supplier;

    public CollectionPool(Supplier<? extends V> supplier, int initialCapacity) {
        collections = new ArrayList<>(initialCapacity);
        this.supplier = supplier;
    }

    public V get() {
        V collection;
        if (hotspot != null) {
            collection = hotspot;
            hotspot = null;
        } else if (collections.size() > 0) {
            final int size = collections.size();
            collection = collections.get(size - 1);
            collections.remove(size - 1);
        } else {
            collection = supplier.get();
        }
        return collection;
    }

    public void returnToPool(V collection) {
        if (hotspot == null) {
            hotspot = collection;
        } else {
            this.collections.add(collection);
        }
    }
}
