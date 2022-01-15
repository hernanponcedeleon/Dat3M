package com.dat3m.dartagnan.solver.caat.constraints;

import com.dat3m.dartagnan.solver.caat.domain.Domain;
import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;

public abstract class AbstractConstraint implements Constraint {

    protected Domain<?> domain;

    @Override
    public void onDomainInit(CAATPredicate predicate, Domain<?> domain) {
        this.domain = domain;
    }

    @Override
    public void onPopulation(CAATPredicate predicate) {
        onChanged(predicate, predicate.setView());
    }

}
