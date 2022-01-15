package com.dat3m.dartagnan.utils.logic;


public interface Literal<T extends Literal<T>> {
    String getName();

    boolean isPositive();
    default boolean isNegative() { return !isPositive(); }

    T negated();

}
