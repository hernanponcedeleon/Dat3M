package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.binary;

import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.SimpleGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.utils.timeable.Timestamp;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.google.common.collect.Sets;

import java.util.Collection;
import java.util.Iterator;

// A materialized Intersection Graph. This seems to be more efficient than the virtualized IntersectionGraph
public class MatIntersectionGraph extends BinaryEventGraph {

    private final SimpleGraph simpleGraph = new SimpleGraph();

    public MatIntersectionGraph(EventGraph first, EventGraph second) {
        super(first, second);
    }

    @Override
    public void constructFromModel(ExecutionModel context) {
        super.constructFromModel(context);
        simpleGraph.constructFromModel(context);

        if (first.getEstimatedSize() < second.getEstimatedSize()) {
            simpleGraph.addAll(Sets.intersection(first, second));
        } else {
            simpleGraph.addAll(Sets.intersection(second, first));
        }
    }

    @Override
    public void backtrack() {
        simpleGraph.backtrack();
    }

    @Override
    public boolean contains(Edge edge) {
        return simpleGraph.contains(edge);
    }


    @Override
    public boolean contains(EventData a, EventData b) {
        return simpleGraph.contains(a, b);
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
    public int getMinSize() {
        return simpleGraph.getMinSize();
    }

    @Override
    public int getMaxSize() {
        return simpleGraph.getMaxSize();
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return simpleGraph.getMinSize(e, dir);
    }

    @Override
    public int getMaxSize(EventData e, EdgeDirection dir) {
        return simpleGraph.getMaxSize(e, dir);
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
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {
        if (changedGraph == first || changedGraph == second) {
            EventGraph other = changedGraph == first ? second : first;
            addedEdges.removeIf(x -> !other.contains(x));
            simpleGraph.addAll(addedEdges);
        } else {
            addedEdges.clear();
        }
        return addedEdges;
    }

    @Override
    public Conjunction<CoreLiteral> computeReason(Edge edge) {
        if (!contains(edge)) {
            return Conjunction.FALSE;
        }
        return first.computeReason(edge).and(second.computeReason(edge));
    }

}