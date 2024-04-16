package com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.relationGraphs.derived;


import com.dat3m.dartagnan.solver.onlineCaat.caat.misc.EdgeDirection;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.AbstractPredicate;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.relationGraphs.RelationGraph;

import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

//TODO: This class is not up-to-date with the new derivation length.
// However, this doesn't cause any issues as we do not support differences in recursion.
public class DifferenceGraph extends AbstractPredicate implements RelationGraph {

    private final RelationGraph first;
    private final RelationGraph second;

    @Override
    public List<RelationGraph> getDependencies() {
        return Arrays.asList(first, second);
    }

    public RelationGraph getFirst() { return first; }
    public RelationGraph getSecond() { return second; }

    public DifferenceGraph(RelationGraph first, RelationGraph second) {
        this.first = first;
        this.second = second;
    }

    @Override
    public Edge get(Edge edge) {
        return second.contains(edge) ? null : first.get(edge);
    }

    @Override
    public boolean contains(Edge edge) {
        return first.contains(edge) && !second.contains(edge);
    }

    @Override
    public boolean containsById(int id1, int id2) {
        return first.containsById(id1, id2) && !second.containsById(id1, id2);
    }

    @Override
    public int size(int e, EdgeDirection dir) {
        return (int)first.edgeStream(e, dir).filter(x -> !second.contains(x)).count();
    }

    @Override
    public int getMinSize() {
        return Math.max(0, first.getMinSize() - second.getMaxSize());
    }

    @Override
    public int getMaxSize() {
        return first.getMaxSize();
    }

    @Override
    public int getMinSize(int e, EdgeDirection dir) {
        return Math.max(0, first.getMinSize(e, dir) - second.getMaxSize(e, dir));
    }

    @Override
    public int getMaxSize(int e, EdgeDirection dir) {
        return first.getMaxSize(e, dir);
    }

    @Override
    public Stream<Edge> edgeStream() {
        return first.edgeStream().filter(edge -> !second.contains(edge));
    }

    @Override
    public Stream<Edge> edgeStream(int e, EdgeDirection dir) {
        return first.edgeStream(e, dir).filter(edge -> !second.contains(edge));
    }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Edge> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        Collection<Edge> addedEdges = (Collection<Edge>) added;
        if (changedSource == first) {
            return addedEdges.stream().filter(e -> !second.contains(e)).collect(Collectors.toList());
        } else if (changedSource == second) {
            throw new IllegalStateException("Non-static relations on the right hand side of differences are invalid.");
        } else {
            return Collections.emptyList();
        }
    }

    @Override
    public void backtrackTo(int time) { }
    @Override
    public void repopulate() { }

    @Override
    public <TRet, TData, TContext> TRet accept(PredicateVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitGraphDifference(this, data, context);
    }


}
