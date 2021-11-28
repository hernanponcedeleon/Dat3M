package com.dat3m.dartagnan.solver.newcaat.predicates.relationGraphs;

import com.dat3m.dartagnan.solver.newcaat.predicates.AbstractPredicate;
import com.dat3m.dartagnan.solver.newcaat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.newcaat.predicates.misc.PredicateVisitor;

import java.util.Collections;
import java.util.List;

public abstract class BaseGraph extends AbstractPredicate implements RelationGraph {

    @Override
    public List<? extends CAATPredicate> getDependencies() {
        return Collections.emptyList();
    }

    @Override
    public <TRet, TData, TContext> TRet accept(PredicateVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitBaseGraph(this, data, context);
    }

    @Override
    public void repopulate() { }
}
