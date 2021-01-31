package com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.unary;

import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.EventData;
import com.dat3m.dartagnan.wmm.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.DerivedEventGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.timeable.Timestamp;

import java.util.Collections;
import java.util.Iterator;
import java.util.List;

//TODO:
// (1) Implement.
// (2)We surely need to materialize this set
// There is probably no reasonable way to do it virtually
// Maybe by temporarily storing all queries during calls to getTime/contains
// But how about iteration?
//
public class RecursiveGraph extends DerivedEventGraph {

    @Override
    public List<EventGraph> getDependencies() {
        return Collections.singletonList(inner);
    }

    private EventGraph inner;

    public EventGraph getInner() { return inner; }

    public void setConcreteGraph(EventGraph concreteGraph) {
        this.inner = concreteGraph;
    }

    @Override
    public boolean contains(Edge edge) {
        return inner.contains(edge);
    }

    @Override
    public Timestamp getTime(Edge edge) {
        return inner.getTime(edge);
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return inner.contains(a, b);
    }

    @Override
    public Timestamp getTime(EventData a, EventData b) {
        return inner.getTime(a, b);
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
    public int getMinSize(EventData e, EdgeDirection dir) {
        return inner.getMinSize(e, dir);
    }

    @Override
    public int getMaxSize(EventData e, EdgeDirection dir) {
        return inner.getMaxSize(e, dir);
    }

    @Override
    public Iterator<Edge> edgeIterator() {
        return inner.edgeIterator();
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        return inner.edgeIterator(e, dir);
    }

    @Override
    public Conjunction<CoreLiteral> computeReason(Edge edge) {
        return inner.computeReason(edge);
    }
}
