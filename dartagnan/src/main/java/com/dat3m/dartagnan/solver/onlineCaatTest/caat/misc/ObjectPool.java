package com.dat3m.dartagnan.solver.onlineCaatTest.caat.misc;

import java.util.ArrayList;
import java.util.function.Supplier;

public class ObjectPool<V> implements Supplier<V> {

    private final ArrayList<V> collections;
    private final Supplier<? extends V> supplier;

    public ObjectPool(Supplier<? extends V> supplier, int initialCapacity) {
        collections = new ArrayList<>(initialCapacity);
        this.supplier = supplier;
    }

    public V get() {
        final int size = collections.size();
        return size > 0 ? collections.remove(size - 1) : supplier.get();
    }

    public void returnToPool(V collection) {
        this.collections.add(collection);
    }
}
