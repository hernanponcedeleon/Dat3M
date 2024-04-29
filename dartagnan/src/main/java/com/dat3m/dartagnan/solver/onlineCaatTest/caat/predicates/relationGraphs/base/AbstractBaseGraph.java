package com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.base;

import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.AbstractPredicate;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.RelationGraph;

import java.util.Collections;
import java.util.List;

public abstract class AbstractBaseGraph extends AbstractPredicate implements RelationGraph {

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
