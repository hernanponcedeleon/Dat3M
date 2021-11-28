package com.dat3m.dartagnan.solver.newcaat.predicates.relationGraphs;

import com.dat3m.dartagnan.solver.newcaat.misc.EdgeDirection;
import com.dat3m.dartagnan.solver.newcaat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.newcaat.predicates.Derivable;
import com.google.common.collect.Iterators;

import java.util.*;
import java.util.stream.Stream;

public class IdentityGraph extends BaseGraph {

    private List<Edge> edges;

    @Override
    public void repopulate() {
        final int size = domain.size();
        edges = new ArrayList<>(size);
        for (int i = 0; i < size; i++) {
            edges.add(new Edge(i, i));
        }
    }

    @Override
    public void backtrackTo(int time) { }

    @Override
    public Collection<Edge> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        return Collections.emptyList();
    }

    @Override
    public Edge get(Edge edge) {
        return edge.isLoop() ? edges.get(edge.getFirst()) : null;
    }
    @Override
    public Edge getById(int id1, int id2) { return containsById(id1, id2) ? edges.get(id1) : null; }

    @Override
    public int size() { return domain.size(); }

    @Override
    public int size(int e, EdgeDirection dir) { return 1; }

    @Override
    public boolean contains(Edge edge) { return edge.isLoop(); }

    @Override
    public boolean containsById(int id1, int id2) { return id1 == id2; }


    @Override
    public Iterable<Edge> edges() { return edges; }

    @Override
    public Iterable<Edge> edges(int e, EdgeDirection dir) { return Collections.singletonList(edges.get(e)); }

    @Override
    public Stream<Edge> edgeStream() { return edges.stream(); }

    @Override
    public Stream<Edge> edgeStream(int e, EdgeDirection dir) { return Stream.of(edges.get(e)); }

    @Override
    public Iterator<Edge> edgeIterator() { return edges.iterator(); }

    @Override
    public Iterator<Edge> edgeIterator(int e, EdgeDirection dir) { return Iterators.singletonIterator(edges.get(e)); }
}
