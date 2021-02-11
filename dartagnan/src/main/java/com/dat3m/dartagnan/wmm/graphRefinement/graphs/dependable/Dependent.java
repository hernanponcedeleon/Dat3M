package com.dat3m.dartagnan.wmm.graphRefinement.graphs.dependable;

import java.util.Collection;
import java.util.Collections;
import java.util.List;

public interface Dependent<T> {
    Collection<T> getDependencies();


    default boolean isStatic() {
        return getDependencies().size() == 0;
    }
    default boolean isUnary() {
        return getDependencies().size() == 1;
    }
    default boolean isBinary() {
        return getDependencies().size() == 2;
    }
}
