package com.dat3m.dartagnan.analysis.saturation.logic;

public interface PartialOrder<T> {
    OrderResult compareToPartial(T other);
}
