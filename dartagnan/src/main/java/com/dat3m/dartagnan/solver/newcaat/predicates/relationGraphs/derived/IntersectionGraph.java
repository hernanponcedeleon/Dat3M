package com.dat3m.dartagnan.solver.newcaat.predicates.relationGraphs.derived;


import com.dat3m.dartagnan.solver.newcaat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.newcaat.predicates.Derivable;
import com.dat3m.dartagnan.solver.newcaat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.newcaat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.newcaat.predicates.relationGraphs.MaterializedGraph;
import com.dat3m.dartagnan.solver.newcaat.predicates.relationGraphs.RelationGraph;

import java.util.*;

// A materialized Intersection Graph.
// This seems to be more efficient than the virtualized IntersectionGraph we used before.
public class IntersectionGraph extends MaterializedGraph {

    private final RelationGraph first;
    private final RelationGraph second;

    @Override
    public List<RelationGraph> getDependencies() {
        return Arrays.asList(first, second);
    }

    public RelationGraph getFirst() { return first; }
    public RelationGraph getSecond() { return second; }

    public IntersectionGraph(RelationGraph first, RelationGraph second) {
        this.first = first;
        this.second = second;
    }

    // Note: The derived edge has the timestamp of edge <a>
    private Edge derive(Edge a, Edge b) {
        return a.with(Math.max(a.getTime(), b.getTime()),
                Math.max(a.getDerivationLength(), b.getDerivationLength()) + 1);
    }

    @Override
    public void repopulate() {
        if (first.getEstimatedSize() < second.getEstimatedSize()) {
            for (Edge e1 : first.edges()) {
                Edge e2 = second.get(e1);
                if (e2 != null) {
                    simpleGraph.add(derive(e1, e2));
                }
            }
        } else {
            for (Edge e2 : second.edges()) {
                Edge e1 = first.get(e2);
                if (e1 != null) {
                    simpleGraph.add(derive(e1, e2));
                }
            }
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Edge> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        if (changedSource == first || changedSource == second) {
            RelationGraph other = (changedSource == first) ? second : first;
            Collection<Edge> addedEdges = (Collection<Edge>)added;
            List<Edge> newlyAdded = new ArrayList<>();
            for (Edge e1 : addedEdges) {
                Edge e2 = other.get(e1);
                if (e2 != null) {
                    Edge e = derive(e1, e2);
                    simpleGraph.add(e);
                    newlyAdded.add(e);
                }
            }
            return newlyAdded;
        } else {
            return Collections.emptyList();
        }
    }



    @Override
    public <TRet, TData, TContext> TRet accept(PredicateVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitGraphIntersection(this, data, context);
    }

}