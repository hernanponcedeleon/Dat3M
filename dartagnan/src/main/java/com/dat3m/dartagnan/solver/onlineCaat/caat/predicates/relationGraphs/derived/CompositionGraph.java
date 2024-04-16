package com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.relationGraphs.derived;


import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.relationGraphs.MaterializedGraph;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.utils.collections.SetUtil;

import java.util.*;

public class CompositionGraph extends MaterializedGraph {

    private final RelationGraph first;
    private final RelationGraph second;

    @Override
    public List<RelationGraph> getDependencies() {
        return Arrays.asList(first, second);
    }

    public RelationGraph getFirst() { return first; }
    public RelationGraph getSecond() { return second; }

    public CompositionGraph(RelationGraph first, RelationGraph second) {
        this.first = first;
        this.second = second;
    }


    @Override
    public <TRet, TData, TContext> TRet accept(PredicateVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitGraphComposition(this, data, context);
    }

    @Override
    public void repopulate() {
        Set<Edge> fakeSet = SetUtil.fakeSet();
        if (first.getEstimatedSize() <= second.getEstimatedSize()) {
            for (Edge a : first.edges()) {
                updateFirst(a, fakeSet);
            }
        } else {
            for (Edge a : second.edges()) {
                updateSecond(a, fakeSet);
            }
        }
    }

    private Edge combine(Edge a, Edge b, int time) {
        return new Edge(a.getFirst(), b.getSecond(), time,
                Math.max(a.getDerivationLength(), b.getDerivationLength()) + 1);
    }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Edge> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        ArrayList<Edge> newEdges = new ArrayList<>();
        Collection<Edge> addedEdges = (Collection<Edge>) added;
        if (changedSource == first) {
            // (A+R);B = A;B + R;B
            for (Edge e : addedEdges) {
                updateFirst(e, newEdges);
            }
        }
        if (changedSource == second) {
            // A;(B+R) = A;B + A;R
            for (Edge e : addedEdges) {
                updateSecond(e, newEdges);
            }
        }
        // For A;A, we have the following:
        // (A+R);(A+R) = A;A + A;R + R;A + R;R = A;A + (A+R);R + R;(A+R)
        // So we add (A+R);R and R;(A+R), which is done by doing both of the above update procedures
        return newEdges;
    }

    private void updateFirst(Edge a, Collection<Edge> addedEdges) {
        for (Edge b : second.outEdges(a.getSecond())) {
            Edge c = combine(a, b, a.getTime());
            if (simpleGraph.add(c)) {
                addedEdges.add(c);
            }
        }
    }

    private void updateSecond(Edge b, Collection<Edge> addedEdges) {
        for (Edge a : first.inEdges(b.getFirst())) {
            Edge c = combine(a, b, b.getTime());
            if (simpleGraph.add(c)) {
                addedEdges.add(c);
            }
        }
    }


}
