package com.dat3m.dartagnan.wmm.graphRefinement.logic;

import com.dat3m.dartagnan.wmm.graphRefinement.logic.OrderResult;

public interface PartialOrder<T> {
    OrderResult compareToPartial(T other);
}
