package com.dat3m.dartagnan.utils.logic;

public interface PartialOrder<T> {
    OrderResult compareToPartial(T other);
}
