package com.dat3m.dartagnan.utils.dependable;

import java.util.Collection;

public interface Dependent<T> {
    Collection<? extends T> getDependencies();

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
