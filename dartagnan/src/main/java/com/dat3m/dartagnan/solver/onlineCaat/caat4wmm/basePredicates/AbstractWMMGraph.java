package com.dat3m.dartagnan.solver.onlineCaat.caat4wmm.basePredicates;

import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.caat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.RelationGraph;

import java.util.Collection;
import java.util.Collections;
import java.util.List;

public abstract class AbstractWMMGraph extends AbstractWMMPredicate implements RelationGraph {

    @Override
    public List<RelationGraph> getDependencies() {
        return Collections.emptyList();
    }

    @Override
    public <TRet, TData, TContext> TRet accept(PredicateVisitor<TRet, TData, TContext> visitor, TData tData, TContext context) {
        return visitor.visitBaseGraph(this, tData, context);
    }

    @Override
    public Collection<Edge> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        return Collections.emptyList();
    }
}
