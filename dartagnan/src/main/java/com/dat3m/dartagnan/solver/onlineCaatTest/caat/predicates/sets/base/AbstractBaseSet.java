package com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.sets.base;

import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.AbstractPredicate;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.sets.SetPredicate;

import java.util.Collections;
import java.util.List;

public abstract class AbstractBaseSet extends AbstractPredicate implements SetPredicate {

    @Override
    public List<SetPredicate> getDependencies() {
        return Collections.emptyList();
    }

    @Override
    public <TRet, TData, TContext> TRet accept(PredicateVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitBaseSet(this, data, context);
    }

    @Override
    public void repopulate() { }
}
