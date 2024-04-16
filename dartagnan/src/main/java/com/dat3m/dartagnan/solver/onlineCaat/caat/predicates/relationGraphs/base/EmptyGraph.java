package com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.relationGraphs.base;

import com.dat3m.dartagnan.solver.onlineCaat.caat.misc.EdgeDirection;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.relationGraphs.Edge;

import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.Set;
import java.util.stream.Stream;

public class EmptyGraph extends AbstractBaseGraph {

    @Override
    public void backtrackTo(int time) { }

    @Override
    public Collection<Edge> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        return Collections.emptyList();
    }

    @Override
    public Edge get(Edge edge) { return null; }

    @Override
    public Edge get(Derivable value) { return null; }

    @Override
    public int size() { return 0; }

    @Override
    public int size(int e, EdgeDirection dir) { return 0; }

    @Override
    public boolean contains(Derivable value) { return false; }

    @Override
    public boolean contains(Edge edge) { return false; }

    @Override
    public boolean containsById(int id1, int id2) { return false; }

    @Override
    public Edge getById(int id1, int id2) { return null; }

    @Override
    public Set<Edge> setView() { return Collections.emptySet(); }


    @Override
    public Iterator<Edge> edgeIterator() { return Collections.emptyIterator(); }

    @Override
    public Iterator<Edge> edgeIterator(int e, EdgeDirection dir) { return Collections.emptyIterator(); }

    @Override
    public Iterable<Edge> edges() { return Collections.emptyList(); }

    @Override
    public Iterable<Edge> edges(int e, EdgeDirection dir) { return Collections.emptyList(); }

    @Override
    public Stream<Edge> edgeStream() { return Stream.empty(); }

    @Override
    public Stream<Edge> edgeStream(int e, EdgeDirection dir) { return Stream.empty(); }
}
