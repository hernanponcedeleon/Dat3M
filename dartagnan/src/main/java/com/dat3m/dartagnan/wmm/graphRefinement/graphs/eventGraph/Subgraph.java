package com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph;

import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.EventData;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.iteration.IteratorUtils;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.timeable.Timestamp;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.wmm.graphRefinement.util.EdgeDirection;

import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

public class Subgraph extends AbstractEventGraph {

    private final EventGraph sourceGraph;
    private final Collection<EventData> events;

    public Subgraph(EventGraph source, Collection<EventData> events) {
        sourceGraph = source;
        this.events = events;
    }

    private boolean exists(Edge e) {
        return exists(e.getFirst(), e.getSecond());
    }

    private boolean exists(EventData a, EventData b) {
        return (events.contains(a) && events.contains(b));
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return exists(a, b) && sourceGraph.contains(a, b);
    }

    @Override
    public Timestamp getTime(EventData a, EventData b) {
        return exists(a, b) ? sourceGraph.getTime(a, b) : Timestamp.INVALID;
    }

    @Override
    public void backtrack() {

    }

    @Override
    public int getMinSize() {
        return 0;
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return 0;
    }

    @Override
    public int getMaxSize() {
        return sourceGraph.getMaxSize();
    }

    @Override
    public int getMaxSize(EventData e, EdgeDirection dir) {
        return events.contains(e) ? sourceGraph.getMaxSize(e, dir) : 0;
    }

    @Override
    public Iterator<Edge> edgeIterator() {
        return new SubGraphIterator();
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        return new SubGraphIterator(e, dir);
    }

    @Override
    public Conjunction<CoreLiteral> computeReason(Edge edge) {
        return exists(edge) ? sourceGraph.computeReason(edge) : Conjunction.FALSE;
    }

    @Override
    public List<EventGraph> getDependencies() {
        return Collections.singletonList(sourceGraph);
    }


    private class SubGraphIterator implements Iterator<Edge> {

        private final Iterator<EventData> eventIterator;
        private Iterator<Edge> edgeIterator;
        private final boolean eventIsFixed;

        private Edge next;

        public SubGraphIterator() {
            eventIsFixed = false;
            eventIterator = events.iterator();
            edgeIterator = IteratorUtils.empty();
            nextInternal();

        }

        public SubGraphIterator(EventData e, EdgeDirection dir) {
            eventIsFixed = true;
            eventIterator = IteratorUtils.empty();
            edgeIterator = events.contains(e) ? sourceGraph.edgeIterator(e, dir) : IteratorUtils.empty();
            nextInternal();
        }

        private void nextInternal() {
            next = null;
            Edge edge;

            while ((edgeIterator.hasNext() || (!eventIsFixed && eventIterator.hasNext())) && next == null) {
                if (edgeIterator.hasNext()) {
                    edge = edgeIterator.next();
                    if (events.contains(edge.getFirst()) && events.contains(edge.getSecond())) {
                        next = edge;
                    }
                } else {
                    EventData e = eventIterator.next();
                    if (events.contains(e)) {
                        edgeIterator = sourceGraph.edgeIterator(e, EdgeDirection.Outgoing);
                    }
                }
            }
        }

        @Override
        public boolean hasNext() {
            return next != null;
        }

        @Override
        public Edge next() {
            Edge e = next;
            nextInternal();
            return e;
        }
    }

}
