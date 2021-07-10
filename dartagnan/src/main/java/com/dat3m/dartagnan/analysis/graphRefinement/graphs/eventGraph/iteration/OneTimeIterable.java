package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.iteration;

import java.util.Iterator;

// Only allows one-time iteration using enhanced for-loop syntax.
public final class OneTimeIterable {
    public static <V> Iterable<V> create(Iterator<V> iterator) {
        return () -> iterator;
    }
}
