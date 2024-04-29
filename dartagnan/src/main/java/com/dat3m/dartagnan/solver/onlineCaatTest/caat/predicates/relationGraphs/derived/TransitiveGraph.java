package com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.derived;

import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.MaterializedGraph;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.utils.collections.SetUtil;

import java.util.*;

public class TransitiveGraph extends MaterializedGraph {

    private final RelationGraph inner;

    @Override
    public List<RelationGraph> getDependencies() {
        return Collections.singletonList(inner);
    }

    public TransitiveGraph(RelationGraph inner) {
        this.inner = inner;
    }

    private Edge derive(Edge e) {
        return e.withDerivationLength(e.getDerivationLength() + 1);
    }

    private Edge combine(Edge a, Edge b, int time) {
        return new Edge(a.getFirst(), b.getSecond(), time,
                Math.max(a.getDerivationLength(), b.getDerivationLength()) + 1);
    }

    @Override
    public void repopulate() {
        //TODO: This is inefficient for many edges (the likely default case!)
        // Initially, we can probably use some non-incremental approach
        Set<Edge> fakeSet = SetUtil.fakeSet();
        for (Edge e : inner.edges()) {
            updateEdge(derive(e), fakeSet);
        }
    }

    // Every (transitive) edge that gets added by adding <edge> is collected into <addedEdged>
    private void updateEdge(Edge edge, Collection<Edge> addedEdges) {
        if (!simpleGraph.add(edge)) {
            return;
        }
        addedEdges.add(edge);
        final int time = edge.getTime();

        for (Edge inEdge : inEdges(edge.getFirst())) {
            Edge newEdge = combine(inEdge, edge, time);
            if (simpleGraph.add(newEdge)) {
                addedEdges.add(newEdge);
                for (Edge outEdge : outEdges(edge.getSecond())) {
                    Edge combined = combine(newEdge, outEdge, time);
                    if (simpleGraph.add(combined)) {
                        addedEdges.add(combined);
                    }
                }
            }
        }

        for (Edge outEdge : outEdges(edge.getSecond())) {
            Edge newEdge = combine(edge, outEdge, time);
            if (simpleGraph.add(newEdge)) {
                addedEdges.add(newEdge);
            }
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Edge> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        if (changedSource == inner) {
            List<Edge> newEdges = new ArrayList<>();
            for (Edge e : (Collection<Edge>)added) {
                updateEdge(derive(e), newEdges);
            }
            return newEdges;
        } else {
            return Collections.emptyList();
        }
    }

    @Override
    public <TRet, TData, TContext> TRet accept(PredicateVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitTransitiveClosure(this, data, context);
    }

}
