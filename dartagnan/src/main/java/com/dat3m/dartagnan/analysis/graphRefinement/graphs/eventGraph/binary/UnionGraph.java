package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.binary;

import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.ReasoningEngine;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.utils.timeable.Timestamp;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.Collection;
import java.util.Iterator;

public class UnionGraph extends BinaryEventGraph {

    public UnionGraph(EventGraph first, EventGraph second) {
        super(first, second);
    }

    @Override
    public boolean contains(Edge edge) {
        return first.contains(edge) || second.contains(edge);
    }


    @Override
    public boolean contains(EventData a, EventData b) {
        return first.contains(a, b) || second.contains(a, b);
    }

    @Override
    public Timestamp getTime(Edge edge) {
        Timestamp time = first.getTime(edge);
        return time.isInitial() ? Timestamp.ZERO : Timestamp.min(time, second.getTime(edge));
    }

    @Override
    public Timestamp getTime(EventData a, EventData b) {
        Timestamp time = first.getTime(a, b);
        return time.isInitial() ? Timestamp.ZERO : Timestamp.min(time, second.getTime(a, b));
    }

    @Override
    public int getMinSize() {
        return Math.min(first.getMinSize(), second.getMinSize());
    }

    @Override
    public int getMaxSize() {
        return first.getMaxSize() + second.getMaxSize();
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return Math.min(first.getMinSize(e, dir), second.getMinSize(e, dir));
    }

    @Override
    public int getMaxSize(EventData e, EdgeDirection dir) {
        return first.getMaxSize(e, dir) + second.getMaxSize(e, dir);
    }

    @Override
    public Iterator<Edge> edgeIterator() {
        return new UnionIterator();
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        return new UnionIterator(e, dir);
    }

    @Override
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {
        if (changedGraph == first || changedGraph == second) {
            EventGraph other = changedGraph == first ? second : first;
            //addedEdges.removeIf(other::contains); <---- Problem
            // NOTE: This shortcut can only be done, if R = A | B and A and B are independent.
            // This is not the case for recursive relations and will cause problems there.
        } else {
            addedEdges.clear();
        }
        return addedEdges;
    }

    @Override
    public Conjunction<CoreLiteral> computeReason(Edge edge, ReasoningEngine reasEngine) {

        Conjunction<CoreLiteral> reason = reasEngine.tryGetStaticReason(this, edge);
        if (reason != null) {
            return reason;
        }

        if (first.contains(edge))
            return first.computeReason(edge, reasEngine);
        else if (second.contains(edge))
            return second.computeReason(edge, reasEngine);
        return Conjunction.FALSE;
    }

    private class UnionIterator implements Iterator<Edge> {

        private final Iterator<Edge> firstIterator;
        private final Iterator<Edge> secondIterator;
        private final EventGraph firstSet;

        private Edge nextEdge;

        public UnionIterator() {
            if (first.getEstimatedSize() < second.getEstimatedSize()) {
                firstIterator = second.edgeIterator();
                secondIterator = first.edgeIterator();
                firstSet = second;
            } else {
                firstIterator = first.edgeIterator();
                secondIterator = second.edgeIterator();
                firstSet = first;
            }
            nextInternal();
        }

        public UnionIterator(EventData e, EdgeDirection dir) {
            if (first.getEstimatedSize(e, dir) < second.getEstimatedSize(e, dir)) {
                firstIterator = second.edgeIterator(e, dir);
                secondIterator = first.edgeIterator(e, dir);
                firstSet = second;
            } else {
                firstIterator = first.edgeIterator(e, dir);
                secondIterator = second.edgeIterator(e, dir);
                firstSet = first;
            }
            nextInternal();
        }

        private void nextInternal() {
            if (firstIterator.hasNext()) {
                nextEdge = firstIterator.next();
                // We take a look into the second set to see if
                // we can actually reduce the timestamp
                if (!nextEdge.getTime().isInitial()) {
                    Timestamp t = second.getTime(nextEdge);
                    if (t.compareTo(nextEdge.getTime()) < 0)
                        nextEdge = nextEdge.withTimestamp(t);
                }
            } else {
                nextEdge = null;
                while (nextEdge == null && secondIterator.hasNext()) {
                    nextEdge = secondIterator.next();
                    if (firstSet.contains(nextEdge))
                        nextEdge = null;
                }
            }
        }

        @Override
        public boolean hasNext() {
            return nextEdge != null;
        }

        @Override
        public Edge next() {
            Edge e = nextEdge;
            nextInternal();
            return e;
        }
    }
}