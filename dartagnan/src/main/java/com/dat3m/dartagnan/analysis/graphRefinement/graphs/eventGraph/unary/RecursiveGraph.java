package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.unary;

import com.dat3m.dartagnan.verification.model.ModelContext;
import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.DerivedEventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.SimpleGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.utils.timeable.Timestamp;

import java.util.Collection;
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

    private EventGraph inner;
    private final SimpleGraph materializedGraph;

    public RecursiveGraph() {
        materializedGraph = new SimpleGraph();
    }

    @Override
    public List<EventGraph> getDependencies() {
        return Collections.singletonList(inner);
    }

    public EventGraph getInner() { return inner; }

    @Override
    public void initialize(ModelContext context) {
        materializedGraph.initialize(context);
        //TODO: How to properly initialize?
    }

    @Override
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {
        materializedGraph.addAll(addedEdges);
        return addedEdges;
    }

    @Override
    public int size() {
        return materializedGraph.size();
    }

    @Override
    public void backtrack() {
        materializedGraph.backtrack();
    }

    @Override
    public int getEstimatedSize() {
        return materializedGraph.getEstimatedSize();
    }

    @Override
    public int getEstimatedSize(EventData e, EdgeDirection dir) {
        return materializedGraph.getEstimatedSize(e, dir);
    }

    public void setConcreteGraph(EventGraph concreteGraph) {
        this.inner = concreteGraph;
    }

    @Override
    public boolean contains(Edge edge) {
        return materializedGraph.contains(edge);
    }

    @Override
    public Timestamp getTime(Edge edge) {
        return materializedGraph.getTime(edge);
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return materializedGraph.contains(a, b);
    }

    @Override
    public Timestamp getTime(EventData a, EventData b) {
        return materializedGraph.getTime(a, b);
    }

    @Override
    public int getMinSize() {
        return materializedGraph.getMinSize();
    }

    @Override
    public int getMaxSize() {
        return materializedGraph.getMaxSize();
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return materializedGraph.getMinSize(e, dir);
    }

    @Override
    public int getMaxSize(EventData e, EdgeDirection dir) {
        return materializedGraph.getMaxSize(e, dir);
    }

    @Override
    public Iterator<Edge> edgeIterator() {
        return materializedGraph.edgeIterator();
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        return materializedGraph.edgeIterator(e, dir);
    }

    @Override
    public Conjunction<CoreLiteral> computeReason(Edge edge) {
        //TODO
        return inner.computeReason(edge);
    }
}
