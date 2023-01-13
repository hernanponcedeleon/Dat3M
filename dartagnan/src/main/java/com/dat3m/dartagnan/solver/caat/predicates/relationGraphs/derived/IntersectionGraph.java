package com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.derived;


import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.caat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.MaterializedGraph;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.RelationGraph;

import java.util.*;
import java.util.stream.Stream;

import static java.util.Comparator.comparingInt;

// A materialized Intersection Graph.
// This seems to be more efficient than the virtualized IntersectionGraph we used before.
public class IntersectionGraph extends MaterializedGraph {

    private final RelationGraph[] operands;

    @Override
    public List<RelationGraph> getDependencies() {
        return Arrays.asList(operands);
    }

    public IntersectionGraph(RelationGraph... o) {
        operands = o;
    }

    @Override
    public void repopulate() {
        RelationGraph first = Stream.of(operands).min(comparingInt(RelationGraph::getEstimatedSize)).orElseThrow();
        RelationGraph[] others = Stream.of(operands).filter(x -> first != x).toArray(RelationGraph[]::new);
        for (Edge e1 : first.edges()) {
            Edge e = derive(e1, others);
            if (e != null) {
                simpleGraph.add(e);
            }
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Edge> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        if (Stream.of(operands).anyMatch(g -> changedSource == g)) {
            RelationGraph[] others = Stream.of(operands).filter(g -> g != changedSource).toArray(RelationGraph[]::new);
            Collection<Edge> addedEdges = (Collection<Edge>)added;
            List<Edge> newlyAdded = new ArrayList<>();
            for (Edge e1 : addedEdges) {
                Edge e = derive(e1, others);
                if (e != null) {
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

    // Note: The derived edge has the timestamp of edge
    private Edge derive(Edge edge, RelationGraph[] operands) {
        int time = edge.getTime();
        int length = edge.getDerivationLength();
        for (RelationGraph g : operands) {
            Edge e = g.get(edge);
            if (e == null) {
                return null;
            }
            time = Math.max(time, e.getTime());
            length = Math.max(length, e.getDerivationLength());
        }
        return edge.with(time, length);
    }
}