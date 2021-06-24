package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph;

import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.ReasoningEngine;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.utils.timeable.Timestamp;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

public class MatSubgraph extends AbstractEventGraph {

    private final EventGraph sourceGraph;
    private final Collection<EventData> events;
    private final SimpleGraph simpleGraph;

    public MatSubgraph(EventGraph source, Collection<EventData> events) {
        sourceGraph = source;
        this.events = events;
        simpleGraph = new SimpleGraph();
        simpleGraph.constructFromModel(sourceGraph.getModel());

        for (EventData e : events) {
            for (Edge edge : sourceGraph.outEdges(e)) {
                if (events.contains(edge.getSecond())) {
                    simpleGraph.add(edge);
                }
            }
        }

    }

    private boolean exists(Edge e) {
        return exists(e.getFirst(), e.getSecond());
    }

    private boolean exists(EventData a, EventData b) {
        return events.contains(a) && events.contains(b);
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
    public Timestamp getTime(Edge edge) {
        return simpleGraph.getTime(edge);
    }


    @Override
    public Timestamp getTime(EventData a, EventData b) {
        return simpleGraph.getTime(a, b);
    }

    @Override
    public void backtrack() {

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
        return events.contains(e) ? simpleGraph.getMaxSize(e, dir) : 0;
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
    public Conjunction<CoreLiteral> computeReason(Edge edge, ReasoningEngine reasEngine) {
        return contains(edge) ? sourceGraph.computeReason(edge, reasEngine) : Conjunction.FALSE;
    }

    @Override
    public List<EventGraph> getDependencies() {
        return Collections.singletonList(sourceGraph);
    }

}
