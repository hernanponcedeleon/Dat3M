package com.dat3m.dartagnan.solver.newcaat.predicates.relationGraphs.derived;

import com.dat3m.dartagnan.solver.newcaat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.newcaat.predicates.Derivable;
import com.dat3m.dartagnan.solver.newcaat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.newcaat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.newcaat.predicates.relationGraphs.MaterializedGraph;
import com.dat3m.dartagnan.solver.newcaat.predicates.relationGraphs.RelationGraph;

import java.util.*;

// A materialized Union Graph.
// This seems to be more efficient than the virtualized UnionGraph we used before.
public class UnionGraph extends MaterializedGraph {

    private final RelationGraph first;
    private final RelationGraph second;

    @Override
    public List<RelationGraph> getDependencies() {
        return Arrays.asList(first, second);
    }

    public RelationGraph getFirst() { return first; }
    public RelationGraph getSecond() { return second; }

    public UnionGraph(RelationGraph first, RelationGraph second) {
        this.first = first;
        this.second = second;
    }

    private Edge derive(Edge e) {
        return e.withDerivationLength(e.getDerivationLength() + 1);
    }

    @Override
    public void repopulate() {
        //TODO: Maybe try to minimize the derivation length initially
        for (Edge e : first.edges()) {
            simpleGraph.add(derive(e));
        }
        for (Edge e : second.edges()) {
            simpleGraph.add(derive(e));
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Edge> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        if (changedSource == first || changedSource == second) {
            ArrayList<Edge> newlyAdded = new ArrayList<>();
            Collection<Edge> addedEdges = (Collection<Edge>)added;
            for (Edge e : addedEdges) {
                Edge edge = derive(e);
                if (simpleGraph.add(edge)) {
                    newlyAdded.add(edge);
                }
            }
            return newlyAdded;
        } else {
            return Collections.emptyList();
        }
    }

    @Override
    public <TRet, TData, TContext> TRet accept(PredicateVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitGraphUnion(this, data, context);
    }


}