package com.dat3m.dartagnan.wmm.graphRefinement.graphs.timeable;

public interface Timeable {
    Timestamp getTime();

    default boolean isValid() { return getTime().isValid();}
    default boolean isInvalid() { return getTime().isInvalid();}
    default boolean isInitial() { return getTime().isInitial();}
}
