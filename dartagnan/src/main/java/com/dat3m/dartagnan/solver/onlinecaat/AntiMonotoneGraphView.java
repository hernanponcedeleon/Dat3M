package com.dat3m.dartagnan.solver.onlinecaat;

import com.dat3m.dartagnan.solver.caat.misc.EdgeDirection;
import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.base.AbstractBaseGraph;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.stream.Stream;

/*
    View of a dynamic base relation that is used on the right-hand side of a difference.
    It contains all pairs that are NOT known to be absent, i.e., it over-approximates the relation.
    Hence, the difference "a \ b" computed with this view under-approximates the true difference,
    which is what we need for sound partial reasoning.

    Its "added" elements are those pairs that just became known to be absent (atom assigned to false).
    The DifferenceGraph uses them to add new edges.
 */
public final class AntiMonotoneGraphView extends AbstractBaseGraph {

    final OnlineBaseGraph base;
    private final OnlineCAATPropagator theory;

    AntiMonotoneGraphView(OnlineCAATPropagator theory, OnlineBaseGraph base) {
        this.theory = theory;
        this.base = base;
    }

    void collectOnAtomFalse(int p, int time, List<Edge> out) {
        out.add(new Edge(base.src[p], base.dst[p], time, 0));
    }

    @Override
    public Edge get(Edge edge) {
        final int p = base.lookup(edge.getFirst(), edge.getSecond());
        if (p < 0) {
            return null;
        }
        final int a = base.atom[p];
        return (a < 0 || theory.atomValue(a) >= 0) ? new Edge(edge.getFirst(), edge.getSecond()) : null;
    }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Edge> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        return new ArrayList<>((Collection<Edge>) added);
    }

    @Override
    public void backtrackTo(int time) { }

    @Override
    public int size(int e, EdgeDirection dir) { return 0; }

    @Override
    public int size() { return 0; }

    @Override
    public Stream<Edge> edgeStream() {
        throw new UnsupportedOperationException("Cannot enumerate the edges of " + getName());
    }

    @Override
    public Stream<Edge> edgeStream(int e, EdgeDirection dir) {
        throw new UnsupportedOperationException("Cannot enumerate the edges of " + getName());
    }

    @Override
    public String toString() { return getName(); }
}
