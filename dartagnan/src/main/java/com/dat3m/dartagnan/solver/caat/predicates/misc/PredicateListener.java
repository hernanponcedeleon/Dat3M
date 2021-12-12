package com.dat3m.dartagnan.solver.caat.predicates.misc;

import com.dat3m.dartagnan.solver.caat.domain.Domain;
import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.Derivable;

import java.util.Collection;

public interface PredicateListener {
    void onDomainInit(CAATPredicate predicate, Domain<?> domain);
    void onPopulation(CAATPredicate predicate);
    void onChanged(CAATPredicate predicate, Collection<? extends Derivable> added);
    void onBacktrack(CAATPredicate predicate, int time);
}
