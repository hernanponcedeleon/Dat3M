package com.dat3m.dartagnan.wmm.graphRefinement.logic;

public interface PartialOrder<T> {
    OrderResult compareToPartial(T other);
}
