package com.dat3m.dartagnan.analysis.graphRefinement.logic;

public interface Literal<T> {
    default boolean hasOpposite() {
        return false;
    }

    T getOpposite();
}
