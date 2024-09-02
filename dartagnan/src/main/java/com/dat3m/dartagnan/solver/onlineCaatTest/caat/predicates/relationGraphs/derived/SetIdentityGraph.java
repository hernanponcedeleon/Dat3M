package com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.derived;

import com.dat3m.dartagnan.solver.caat.misc.EdgeDirection;
import com.dat3m.dartagnan.solver.caat.predicates.AbstractPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.caat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.solver.caat.predicates.sets.Element;
import com.dat3m.dartagnan.solver.caat.predicates.sets.SetPredicate;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class SetIdentityGraph extends AbstractPredicate implements RelationGraph {

    private final SetPredicate inner;

    public SetIdentityGraph(SetPredicate first) {
        this.inner = first;
    }

    @Override
    public List<SetPredicate> getDependencies() {
        return Collections.singletonList(inner);
    }

    @Override
    public <TRet, TData, TContext> TRet accept(PredicateVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitSetIdentity(this, data, context);
    }

    @Override
    public void repopulate() { }
    @Override
    public void backtrackTo(int time) { }

    private Edge derive(Element a) {
        return new Edge(a.getId(), a.getId(), a.getTime(), a.getDerivationLength() + 1);
    }

    @Override
    public Collection<Edge> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        return added.stream().map(e -> derive((Element) e)).collect(Collectors.toList());
    }

    @Override
    public Edge get(Edge edge) {
        if (edge.isLoop()) {
            Element e = inner.getById(edge.getFirst());
            return e != null ? derive(e) : null;
        } else {
            return null;
        }
    }

    @Override
    public boolean contains(Edge edge) {
        return containsById(edge.getFirst(), edge.getSecond());
    }

    @Override
    public boolean containsById(int id1, int id2) {
        return id1 == id2 && inner.containsById(id1);
    }

    @Override
    public int size() { return inner.size(); }
    @Override
    public int getMinSize() { return inner.getMinSize(); }
    @Override
    public int getMaxSize() { return inner.getMaxSize(); }

    @Override
    public int size(int e, EdgeDirection dir) {
        return inner.containsById(e) ? 1 : 0;
    }


    @Override
    public Stream<Edge> edgeStream() {
        return inner.elementStream().map(this::derive);
    }

    @Override
    public Stream<Edge> edgeStream(int id, EdgeDirection dir) {
        Element e = inner.getById(id);
        return e != null ? Stream.of(derive(e)) : Stream.empty();
    }
}
