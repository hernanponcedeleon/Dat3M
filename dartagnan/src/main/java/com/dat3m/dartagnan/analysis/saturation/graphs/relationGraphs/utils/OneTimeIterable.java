package com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.utils;

import java.util.Iterator;

// Only allows one-time iteration over Iterators using enhanced for-loop syntax.
public final class OneTimeIterable {
    public static <V> Iterable<V> create(Iterator<V> iterator) {
        return () -> iterator;
    }
}
