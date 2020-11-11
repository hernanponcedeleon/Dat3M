package com.dat3m.dartagnan.wmm.graphRefinement.logic;

public interface Literal<T> {
    default boolean hasOpposite() {
        return false;
    }

    T getOpposite();
}
