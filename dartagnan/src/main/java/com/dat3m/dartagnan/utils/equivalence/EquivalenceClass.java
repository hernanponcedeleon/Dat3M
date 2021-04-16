package com.dat3m.dartagnan.utils.equivalence;

import java.util.Set;

public interface EquivalenceClass<T> extends Set<T> {

	Equivalence<T> getEquivalence();
    
	T getRepresentative();
    
	void setRepresentative(T rep); // Does nothing, if the <rep> is not part of the class
}
