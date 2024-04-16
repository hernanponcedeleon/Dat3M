package com.dat3m.dartagnan.solver.onlineCaat.caat.predicates;

import com.dat3m.dartagnan.solver.onlineCaat.caat.domain.Domain;
import com.google.common.base.Preconditions;

public abstract class AbstractPredicate implements CAATPredicate {

    protected String name;
    protected Domain<?> domain;

    @Override
    public String getName() { return name; }

    @Override
    public void setName(String name) {
        Preconditions.checkNotNull(name);
        this.name = name;
    }

    @Override
    public Domain<?> getDomain() { return domain; }

    @Override
    public void initializeToDomain(Domain<?> domain) {
        Preconditions.checkNotNull(domain);
        this.domain = domain;
    }

    @Override
    public int size() {
        return (int)this.valueStream().count();
    }

    @Override
    public String toString() {
        return getName();
    }
}
