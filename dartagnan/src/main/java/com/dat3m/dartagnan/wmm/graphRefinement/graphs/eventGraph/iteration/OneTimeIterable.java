package com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.iteration;

import java.util.Iterator;

// Only allows one-time iteration using enhanced for-loop syntax.
public class OneTimeIterable<T> implements Iterable<T> {
    private final Iterator<T> iterator;

    public OneTimeIterable(Iterator<T> iterator) {
        this.iterator = iterator;
    }

    @Override
    public Iterator<T> iterator() {
        return iterator;
    }
}
