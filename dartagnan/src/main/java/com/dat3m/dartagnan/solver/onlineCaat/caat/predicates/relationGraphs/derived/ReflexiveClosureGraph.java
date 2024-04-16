package com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.relationGraphs.derived;


import com.dat3m.dartagnan.solver.caat.misc.EdgeDirection;
import com.dat3m.dartagnan.solver.caat.predicates.AbstractPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.caat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.RelationGraph;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public class ReflexiveClosureGraph extends AbstractPredicate implements RelationGraph {

    private final RelationGraph inner;

    public ReflexiveClosureGraph(RelationGraph inner) {
        this.inner = inner;
    }

    @Override
    public List<RelationGraph> getDependencies() {
        return Collections.singletonList(inner);
    }

    @Override
    public Edge get(Edge edge) {
        return edge.isLoop() ? edge.with(0, 0) : inner.get(edge);
    }

    @Override
    public int size(int e, EdgeDirection dir) {
        return inner.size(e, dir) + (inner.containsById(e, e) ? 0 : 1);
    }

    @Override
    public int size() {
        int size = 0;
        for (int i = 0; i < domain.size(); i++) {
            size += size(i, EdgeDirection.OUTGOING);
        }
        return size;
    }

    @Override
    public boolean containsById(int id1, int id2) {
        return id1 == id2 || inner.containsById(id1, id2);
    }

    @Override
    public int getMinSize() {
        return Math.max(inner.getMinSize(), domain.size());
    }

    @Override
    public int getMinSize(int e, EdgeDirection dir) {
        return Math.max(inner.getMinSize(e, dir), 1);
    }

    @Override
    public int getMaxSize() {
        return inner.getMaxSize() + domain.size();
    }

    @Override
    public int getMaxSize(int e, EdgeDirection dir) {
        return inner.getMaxSize(e, dir) + 1;
    }

    private Edge derive(Edge e) {
        return e.withDerivationLength(e.getDerivationLength() + 1);
    }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Edge> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        if (changedSource == inner) {
            return ((Collection<Edge>) added).stream().filter(e -> !e.isLoop()).map(this::derive).collect(Collectors.toList());
        } else {
            return Collections.emptyList();
        }
    }

    @Override
    public <TRet, TData, TContext> TRet accept(PredicateVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitReflexiveClosure(this, data, context);
    }

    @Override
    public void backtrackTo(int time) { }
    @Override
    public void repopulate() { }

    @Override
    public Stream<Edge> edgeStream() {
        return IntStream.range(0, domain.size())
                .mapToObj(e -> edgeStream(e, EdgeDirection.OUTGOING))
                .flatMap(s -> s);
    }

    @Override
    public Stream<Edge> edgeStream(int e, EdgeDirection dir) {
        return Stream.concat(
                Stream.of(new Edge(e, e)),
                inner.edgeStream(e, dir).filter(edge -> !edge.isLoop())
        );
    }

}
