package com.dat3m.dartagnan.analysis.saturation.logic;

public interface Literal<T> {
    default boolean hasOpposite() {
        return false;
    }

    T getOpposite();
}
