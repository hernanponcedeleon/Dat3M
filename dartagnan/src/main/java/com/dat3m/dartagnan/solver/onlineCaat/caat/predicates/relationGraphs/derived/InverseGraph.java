package com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.relationGraphs.derived;

import com.dat3m.dartagnan.solver.onlineCaat.caat.misc.EdgeDirection;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.AbstractPredicate;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.relationGraphs.RelationGraph;
import com.google.common.collect.Iterators;

import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class InverseGraph extends AbstractPredicate implements RelationGraph {

    protected final RelationGraph inner;

    public InverseGraph(RelationGraph inner) {
        this.inner = inner;
    }

    @Override
    public List<RelationGraph> getDependencies() {
        return Collections.singletonList(inner);
    }

    @Override
    public Edge get(Edge edge) {
        Edge e = inner.get(edge.inverse());
        return e == null ? null : derive(e);
    }

    @Override
    public int size(int e, EdgeDirection dir) {
        return 0;
    }

    @Override
    public boolean contains(Edge edge) {
        return inner.contains(edge.inverse());
    }

    @Override
    public boolean containsById(int id1, int id2) {
        return inner.containsById(id2, id1);
    }

    @Override
    public int getMinSize() {
        return inner.getMinSize();
    }

    @Override
    public int getMaxSize() {
        return inner.getMaxSize();
    }

    @Override
    public int getEstimatedSize() {
        return inner.getEstimatedSize();
    }

    @Override
    public int getEstimatedSize(int e, EdgeDirection dir) {
        return inner.getEstimatedSize(e, dir.flip());
    }

    @Override
    public int getMinSize(int e, EdgeDirection dir) {
        return inner.getMinSize(e, dir.flip());
    }

    @Override
    public int getMaxSize(int e, EdgeDirection dir) {
        return inner.getMaxSize(e, dir.flip());
    }


    private Edge derive(Edge e) {
        return new Edge(e.getSecond(), e.getFirst(), e.getTime(), e.getDerivationLength() + 1);
    }

    @Override
    public Stream<Edge> edgeStream() {
        return inner.edgeStream().map(this::derive);
    }

    @Override
    public Stream<Edge> edgeStream(int e, EdgeDirection dir) {
        return inner.edgeStream(e, dir.flip()).map(this::derive);
    }

    @Override
    public Iterator<Edge> edgeIterator() {
        return Iterators.transform(inner.edgeIterator(), this::derive);
    }

    @Override
    public Iterator<Edge> edgeIterator(int e, EdgeDirection dir) {
        return Iterators.transform(inner.edgeIterator(e, dir.flip()), this::derive);
    }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Edge> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        if (changedSource == inner) {
            return ((Collection<Edge>) added).stream().map(this::derive).collect(Collectors.toList());
        } else {
            return Collections.emptyList();
        }
    }


    @Override
    public <TRet, TData, TContext> TRet accept(PredicateVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitInverse(this, data, context);
    }

    @Override
    public void repopulate() { }

    @Override
    public void backtrackTo(int time) { }
}
