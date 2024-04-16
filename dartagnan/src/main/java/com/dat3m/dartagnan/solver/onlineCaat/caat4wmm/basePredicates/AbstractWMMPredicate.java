package com.dat3m.dartagnan.solver.onlineCaat.caat4wmm.basePredicates;

import com.dat3m.dartagnan.solver.caat.domain.Domain;
import com.dat3m.dartagnan.solver.caat.predicates.AbstractPredicate;
import com.dat3m.dartagnan.solver.onlineCaat.caat4wmm.EventDomain;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.google.common.base.Preconditions;


public abstract class AbstractWMMPredicate extends AbstractPredicate {

    protected ExecutionModel model;

    @Override
    public EventDomain getDomain() {
        return (EventDomain)domain;
    }

    @Override
    public void initializeToDomain(Domain<?> domain) {
        Preconditions.checkArgument(domain instanceof EventDomain,
                "Incompatible domain. Expected " + EventDomain.class.getSimpleName());
        super.initializeToDomain(domain);
        model = ((EventDomain)domain).getExecution();
    }

    protected EventData getEvent(int id) {
        return getDomain().getObjectById(id);
    }

}
