package com.dat3m.dartagnan.analysis.graphRefinement.logic;

public interface PartialOrder<T> {
    OrderResult compareToPartial(T other);
}
