package com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.relationGraphs.derived;


import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.relationGraphs.MaterializedGraph;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.relationGraphs.RelationGraph;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

public class RecursiveGraph extends MaterializedGraph {

    private RelationGraph inner;

    @Override
    public List<RelationGraph> getDependencies() {
        return Collections.singletonList(inner);
    }

    public void setConcreteGraph(RelationGraph concreteGraph) {
        this.inner = concreteGraph;
    }

    public RelationGraph getInner() { return inner; }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Edge> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        if (changedSource == inner) {
            return ((Collection<Edge>) added).stream().filter(simpleGraph::add).collect(Collectors.toList());
        } else {
            return Collections.emptyList();
        }
    }

    @Override
    public <TRet, TData, TContext> TRet accept(PredicateVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitRecursiveGraph(this, data, context);
    }

    @Override
    public void repopulate() { }


}
