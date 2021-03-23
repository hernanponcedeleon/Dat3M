package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat;

import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.iteration.EdgeIterator;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.iteration.IteratorUtils;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;

import java.util.*;

public class LocationGraph extends StaticEventGraph {

    private Map<Long, Set<EventData>> addrEventsMap;

    @Override
    public boolean contains(Edge edge) {
        return edge.isLocEdge();
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return a.getAccessedAddress() == b.getAccessedAddress();
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        if (!e.isMemoryEvent())
            return 0;
        return context.getAddressWritesMap().get(e.getAccessedAddress()).size()
                + context.getAddressReadsMap().get(e.getAccessedAddress()).size() - 1;
    }


    @Override
    public void constructFromModel(ExecutionModel context) {
        super.constructFromModel(context);
        addrEventsMap = new HashMap<>(context.getAddressReadsMap().size());
        for (Long addr : context.getAddressReadsMap().keySet()) {
            Set<EventData> events = new HashSet<>(context.getAddressReadsMap().get(addr));
            events.addAll(context.getAddressWritesMap().get(addr));
            size += events.size() * events.size();
            addrEventsMap.put(addr, events);
        }
    }

    @Override
    public Iterator<Edge> edgeIterator() {
        return new LocIterator();
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        return  e.isMemoryEvent() ? new LocIterator(e, dir) : IteratorUtils.empty();
    }

    private class LocIterator extends EdgeIterator {

        private Iterator<Long> addressIterator;
        private Long curAddress;
        private Iterator<EventData> firstIterator;
        private Iterator<EventData> secondIterator;

        public LocIterator() {
            super(true);
            addressIterator = addrEventsMap.keySet().iterator();
            if (addressIterator.hasNext())
                curAddress = addressIterator.next();
        }

        public LocIterator(EventData fixed, EdgeDirection dir) {
            super(fixed, dir);
            curAddress = fixed.getAccessedAddress();
            if(dir == EdgeDirection.Ingoing) {
                resetFirst();
            } else {
                resetSecond();
            }
        }

        private void nextAddress() {
            if (addressIterator.hasNext()) {
                curAddress = addressIterator.next();
                resetFirst();
                resetSecond();
            } else {
                first = second = null;
            }

        }

        @Override
        protected void resetFirst() {
            firstIterator = addrEventsMap.get(curAddress).iterator();
            first = firstIterator.next(); // We can do this because every address has at least one event
        }

        @Override
        protected void resetSecond() {
            secondIterator = addrEventsMap.get(curAddress).iterator();
            second = secondIterator.next();
        }

        @Override
        protected void nextFirst() {
            first = firstIterator.hasNext() ? firstIterator.next() : null;
            if (first == null && second == null)
                nextAddress();
        }

        @Override
        protected void nextSecond() {
            second = secondIterator.hasNext() ? secondIterator.next() : null;
            if (first == null && second == null)
                nextAddress();
        }
    }

}
