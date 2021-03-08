package com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.stat;

import com.dat3m.dartagnan.wmm.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.graphRefinement.ModelContext;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.EventData;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationData;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.iteration.IteratorUtils;
import com.dat3m.dartagnan.wmm.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.iteration.EdgeIterator;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelCartesian;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class CartesianGraph extends StaticEventGraph {

    private final RelationData relationData;

    private final List<EventData> firstEvents;
    private final List<EventData> secondEvents;

    private FilterAbstract first;
    private FilterAbstract second;

    //TODO: Change this to accept Filters directly
    // And add a factory method to construct this graph from a relation.
    public CartesianGraph(RelationData rel) {
        relationData = rel;
        firstEvents = new ArrayList<>();
        secondEvents = new ArrayList<>();
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return first.filter(a.getEvent()) && second.filter(b.getEvent());
    }

    @Override
    public void initialize(ModelContext context) {
        super.initialize(context);
        RelCartesian rel = (RelCartesian)relationData.getWrappedRelation();
        firstEvents.clear();
        secondEvents.clear();

        first = rel.getFirst();
        second = rel.getSecond();

        for (EventData e : context.getEventList()) {
            if (first.filter(e.getEvent()))
                firstEvents.add(e);
            if (second.filter(e.getEvent()))
                secondEvents.add(e);
        }
    }

    @Override
    public boolean contains(Edge edge) {
        return contains(edge.getFirst(), edge.getSecond());
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        if (dir == EdgeDirection.Outgoing) {
            return first.filter(e.getEvent()) ? secondEvents.size() : 0;
        } else {
            return second.filter(e.getEvent()) ? firstEvents.size() : 0;
        }
    }

    @Override
    public Iterator<Edge> edgeIterator() {
        return new CartesianIterator();
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        if (dir == EdgeDirection.Outgoing) {
            return first.filter(e.getEvent()) ? new CartesianIterator(e, dir) : IteratorUtils.empty();
        } else {
            return second.filter(e.getEvent()) ? new CartesianIterator(e, dir) : IteratorUtils.empty();
        }
    }


    private class CartesianIterator extends EdgeIterator {

        Iterator<EventData> firstIt;
        Iterator<EventData> secondIt;

        public CartesianIterator() {
            super(true);
            if (!firstEvents.isEmpty() && !secondEvents.isEmpty()) {
                autoInit();
            }
        }

        public CartesianIterator(EventData fixed, EdgeDirection dir) {
            super(fixed, dir);
            if (!firstEvents.isEmpty() && !secondEvents.isEmpty()) {
                autoInit();
            }
        }


        @Override
        protected void resetFirst() {
            firstIt = firstEvents.iterator();
            first = firstIt.next();
        }

        @Override
        protected void resetSecond() {
            secondIt = secondEvents.iterator();
            second = secondIt.next();
        }

        @Override
        protected void nextFirst() {
            first = firstIt.hasNext() ? firstIt.next() : null;
        }

        @Override
        protected void nextSecond() {
            second = secondIt.hasNext() ? secondIt.next() : null;
        }
    }
}
