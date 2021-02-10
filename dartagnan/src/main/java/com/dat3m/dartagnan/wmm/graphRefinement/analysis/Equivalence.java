package com.dat3m.dartagnan.wmm.graphRefinement.analysis;

import java.util.Collection;
import java.util.List;
import java.util.Set;

public interface Equivalence<T> {

    // CAREFUL: The returned Set shall not be modified!
    Set<T> getEquivalenceClass(T x);
    boolean areEquivalent(T a, T b);
    void makeRepresentative(T x); // Makes <x> the representative of its equivalence class
    T getRepresentative(T x);

    Collection<Set<T>> getAllEquivalenceClasses();
    Collection<T> getAllRepresentatives();
}
