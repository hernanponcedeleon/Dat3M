package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.utils;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.AbstractEventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.utils.timeable.Timestamp;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Iterator;
import java.util.stream.Stream;

/*
    A meterialized graph simply encapsulates a SimpleGraph and delegates all its methods
    to the underlying SimpleGraph.
 */
public abstract class MaterializedGraph extends AbstractEventGraph {

    protected final SimpleGraph simpleGraph;

    protected MaterializedGraph() {
        this.simpleGraph = new SimpleGraph();
    }

    @Override
    public Edge get(Edge edge) {
        return simpleGraph.get(edge);
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return simpleGraph.contains(a, b);
    }

    @Override
    public boolean contains(Edge edge) {
        return simpleGraph.contains(edge);
    }

    @Override
    public Timestamp getTime(EventData a, EventData b) {
        return simpleGraph.getTime(a, b);
    }

    @Override
    public Timestamp getTime(Edge edge) {
        return simpleGraph.getTime(edge);
    }

    @Override
    public void backtrack() {
        simpleGraph.backtrack();
    }

    @Override
    public void constructFromModel(ExecutionModel model) {
        super.constructFromModel(model);
        simpleGraph.constructFromModel(model);
    }

    @Override
    public int getEstimatedSize() {
        return simpleGraph.getEstimatedSize();
    }

    @Override
    public int getEstimatedSize(EventData e, EdgeDirection dir) {
        return simpleGraph.getEstimatedSize(e, dir);
    }

    @Override
    public int getMinSize() {
        return simpleGraph.getMinSize();
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return simpleGraph.getMinSize(e, dir);
    }

    @Override
    public int getMaxSize() {
        return simpleGraph.getMaxSize();
    }

    @Override
    public int getMaxSize(EventData e, EdgeDirection dir) {
        return simpleGraph.getMaxSize(e, dir);
    }

    @Override
    public Stream<Edge> edgeStream() {
        return simpleGraph.edgeStream();
    }

    @Override
    public Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        return simpleGraph.edgeStream(e, dir);
    }

    @Override
    public Iterator<Edge> edgeIterator() {
        return simpleGraph.edgeIterator();
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        return simpleGraph.edgeIterator(e, dir);
    }

    @Override
    public int size() {
        return simpleGraph.size();
    }

    @Override
    public boolean isEmpty() {
        return simpleGraph.isEmpty();
    }

    @Override
    public Iterator<Edge> iterator() {
        return simpleGraph.iterator();
    }
}
