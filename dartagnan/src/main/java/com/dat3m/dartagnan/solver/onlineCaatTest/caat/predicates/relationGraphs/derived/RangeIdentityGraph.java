package com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.derived;

import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.MaterializedGraph;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.RelationGraph;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

public class RangeIdentityGraph extends MaterializedGraph {

    private final RelationGraph inner;

    @Override
    public List<RelationGraph> getDependencies() {
        return List.of(inner);
    }

    public RangeIdentityGraph(RelationGraph inner) {
        this.inner = inner;
    }

    private Edge derive(Edge e) {
        return new Edge(e.getSecond(), e.getSecond(), e.getTime(), e.getDerivationLength() + 1);
    }

    @Override
    public void repopulate() {
        inner.edgeStream().forEach(e -> simpleGraph.add(derive(e)));
    }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Edge> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        if (changedSource == inner) {
            Collection<Edge> addedEdges = (Collection<Edge>) added;
            return addedEdges.stream()
                    .map(this::derive)
                    .filter(simpleGraph::add)
                    .collect(Collectors.toList());
        } else {
            return Collections.emptyList();
        }
    }

    @Override
    public <TRet, TData, TContext> TRet accept(PredicateVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitRangeIdentity(this, data, context);
    }

}
