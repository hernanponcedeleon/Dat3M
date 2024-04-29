package com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.derived;

import com.dat3m.dartagnan.solver.onlineCaatTest.caat.misc.EdgeDirection;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.AbstractPredicate;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.sets.Element;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.sets.SetPredicate;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.stream.Stream;

public class CartesianGraph extends AbstractPredicate implements RelationGraph {

    private final SetPredicate first;
    private final SetPredicate second;

    public CartesianGraph(SetPredicate first, SetPredicate second) {
        this.first = first;
        this.second = second;
    }

    @Override
    public List<SetPredicate> getDependencies() {
        return Arrays.asList(first, second);
    }

    @Override
    public <TRet, TData, TContext> TRet accept(PredicateVisitor<TRet, TData, TContext> visitor, TData tData, TContext context) {
        return visitor.visitCartesian(this, tData, context);
    }

    @Override
    public void repopulate() { }
    @Override
    public void backtrackTo(int time) { }

    private Edge derive(Element a, Element b) {
        return new Edge(a.getId(), b.getId(), Math.max(a.getTime(), b.getTime()),
                Math.max(a.getDerivationLength(), b.getDerivationLength()) + 1);
    }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Edge> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        List<Edge> addedEdges = new ArrayList<>();
        Collection<Element> addedElems = (Collection<Element>) added;
        if (changedSource == first) {
            for (Element a : addedElems) {
                for (Element b : second.elements()) {
                    addedEdges.add(derive(a, b));
                }
            }
        } else if (changedSource == second) {
            for (Element b : addedElems) {
                for (Element a : first.elements()) {
                    addedEdges.add(derive(a, b));
                }
            }
        }
        return addedEdges;
    }

    @Override
    public Edge get(Edge edge) {
        Element a = first.getById(edge.getFirst());
        Element b = second.getById(edge.getSecond());
        return (a != null && b != null) ? derive(a, b) : null;
    }

    @Override
    public boolean contains(Edge edge) {
        return containsById(edge.getFirst(), edge.getSecond());
    }

    @Override
    public boolean containsById(int id1, int id2) {
        return first.containsById(id1) && second.containsById(id2);
    }

    @Override
    public int size() { return first.size() * second.size(); }
    @Override
    public int getMinSize() { return first.getMinSize() * second.getMinSize(); }
    @Override
    public int getMaxSize() { return first.getMaxSize() * second.getMaxSize(); }

    @Override
    public int size(int e, EdgeDirection dir) {
        if (dir == EdgeDirection.INGOING) {
            return first.containsById(e) ? second.size() : 0;
        } else {
            return second.containsById(e) ? first.size() : 0;
        }
    }

    @Override
    public int getMinSize(int e, EdgeDirection dir) {
        if (dir == EdgeDirection.INGOING) {
            return first.containsById(e) ? second.getMinSize() : 0;
        } else {
            return second.containsById(e) ? first.getMinSize() : 0;
        }
    }

    @Override
    public int getMaxSize(int e, EdgeDirection dir) {
        if (dir == EdgeDirection.INGOING) {
            return first.containsById(e) ? second.getMaxSize() : 0;
        } else {
            return second.containsById(e) ? first.getMaxSize() : 0;
        }
    }


    @Override
    public Stream<Edge> edgeStream() {
        return first.elementStream().flatMap(a -> second.elementStream().map(b -> derive(a, b)));
    }

    @Override
    public Stream<Edge> edgeStream(int e, EdgeDirection dir) {
        if (dir == EdgeDirection.INGOING) {
            Element a = first.getById(e);
            return a != null ? second.elementStream().map(b -> derive(a, b)) : Stream.empty();
        } else {
            Element b = second.getById(e);
            return b != null ? first.elementStream().map(a -> derive(a, b)) : Stream.empty();
        }
    }
}
