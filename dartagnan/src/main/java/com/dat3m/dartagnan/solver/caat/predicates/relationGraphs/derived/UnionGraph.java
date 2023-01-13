package com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.derived;

import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.caat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.MaterializedGraph;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.RelationGraph;

import java.util.*;
import java.util.stream.Stream;

// A materialized Union Graph.
// This seems to be more efficient than the virtualized UnionGraph we used before.
public class UnionGraph extends MaterializedGraph {

    private final RelationGraph[] operands;

    @Override
    public List<RelationGraph> getDependencies() {
        return Arrays.asList(operands);
    }

    public UnionGraph(RelationGraph... o) {
        operands = o;
    }

    private Edge derive(Edge e) {
        return e.withDerivationLength(e.getDerivationLength() + 1);
    }

    @Override
    public void repopulate() {
        //TODO: Maybe try to minimize the derivation length initially
        for (RelationGraph o : operands) {
            for (Edge e : o.edges()) {
                simpleGraph.add(derive(e));
            }
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Edge> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        if (Stream.of(operands).anyMatch(g -> changedSource == g)) {
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