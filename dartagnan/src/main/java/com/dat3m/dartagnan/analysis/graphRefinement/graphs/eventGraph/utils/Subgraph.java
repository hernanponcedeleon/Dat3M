package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.utils;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.AbstractEventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.utils.timeable.Timestamp;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.stream.Stream;


// NOT used right now! The materialized version seems to perform better
public class Subgraph extends AbstractEventGraph {


    private final EventGraph sourceGraph;
    private final Collection<EventData> events;

    public Subgraph(EventGraph source, Collection<EventData> events) {
        sourceGraph = source;
        this.events = events;
    }

    @Override
    public List<EventGraph> getDependencies() {
        return Collections.singletonList(sourceGraph);
    }

    private boolean exists(Edge e) {
        return exists(e.getFirst(), e.getSecond());
    }

    private boolean exists(EventData a, EventData b) {
        return (events.contains(a) && events.contains(b));
    }

    @Override
    public Edge get(Edge edge) {
        return exists(edge) ? sourceGraph.get(edge) : null;
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
    public Stream<Edge> edgeStream() {
        return events.stream().flatMap(e -> sourceGraph.outEdgeStream(e).filter(edge -> events.contains(edge.getSecond())));
    }

    @Override
    public Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        if (!events.contains(e)) {
            return Stream.empty();
        }
        return sourceGraph.edgeStream(e, dir).filter(edge -> events.contains(edge.getSecond()));
    }

    /*@Override
    public Iterator<Edge> edgeIterator() {
        return new SubGraphIterator();
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        return new SubGraphIterator(e, dir);
    }*/



    private class SubGraphIterator implements Iterator<Edge> {

        private final Iterator<EventData> eventIterator;
        private Iterator<Edge> edgeIterator;
        private final boolean eventIsFixed;

        private Edge next;

        public SubGraphIterator() {
            eventIsFixed = false;
            eventIterator = events.iterator();
            edgeIterator = Collections.emptyIterator();
            nextInternal();

        }

        public SubGraphIterator(EventData e, EdgeDirection dir) {
            eventIsFixed = true;
            eventIterator = Collections.emptyIterator();
            edgeIterator = events.contains(e) ? sourceGraph.edgeIterator(e, dir) : Collections.emptyIterator();
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
