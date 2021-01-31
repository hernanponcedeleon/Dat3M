package com.dat3m.dartagnan.wmm.graphRefinement.graphs.dataStructures;

import java.util.HashSet;
import java.util.function.Supplier;

public class BacktrackableSet<T> extends BacktrackableCollection<T> {
    public BacktrackableSet() {
        super(HashSet::new);
    }

    @Override
    public boolean add(T o) {
        return !contains(o) && add(o);
    }
}
