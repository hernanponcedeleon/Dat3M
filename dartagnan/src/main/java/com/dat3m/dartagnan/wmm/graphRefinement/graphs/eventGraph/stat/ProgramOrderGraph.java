package com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.stat;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.wmm.graphRefinement.ModelContext;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.EventData;
import com.dat3m.dartagnan.wmm.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.iteration.EdgeIterator;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class ProgramOrderGraph extends StaticEventGraph {

    private Map<Thread, List<EventData>> threadEventsMap;

    @Override
    public boolean contains(Edge edge) {
        return edge.isForwardEdge();
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        if (dir == EdgeDirection.Outgoing) {
            return (threadEventsMap.get(e.getThread()).size() - e.getLocalId()) - 1;
        } else {
            return e.getLocalId() - 1;
        }
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return a.getThread() == b.getThread() && b.getLocalId() > a.getLocalId();
    }

    @Override
    public void initialize(ModelContext context) {
        super.initialize(context);
        this.threadEventsMap = context.getThreadEventsMap();
        size = 0;
        for (List<EventData> threadEvents : threadEventsMap.values()) {
            size += ((threadEvents.size() - 1) * threadEvents.size()) >> 1;
        }
    }

    @Override
    public Iterator<Edge> edgeIterator() {
        return new PoIterator();
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        return new PoIterator(e, dir);
    }

    private class PoIterator extends EdgeIterator {

        private List<Thread> threads;
        private int threadIndex;
        private List<EventData> eventList;
        private int i;
        private int j;

        public PoIterator() {
            super(true );
            threads = context.getThreads();
            threadIndex = -1;
            findNextThread();
        }

        public PoIterator(EventData e, EdgeDirection dir) {
            super(e, dir);
            threads = context.getThreads();
            eventList = threadEventsMap.get(e.getThread());
            if (firstIsFixed) {
                first = eventList.get(i = e.getLocalId());
            } else {
                second = eventList.get(j = e.getLocalId());
            }
            autoInit();
        }

        private void findNextThread() {
            first = second = null;
            while (++threadIndex < threads.size()) {
                eventList = threadEventsMap.get(threads.get(threadIndex));
                if (eventList.size() > 1) {
                    first = eventList.get(i = 0);
                    second = eventList.get(j = 1);
                    break;
                }
            }
        }

        // We operate under the assumption that on ResetX not both <first> and <second> are NULL.
        // This is because we do not use autoInit().
        @Override
        protected void resetFirst() {
            if (0 < j) {
                first = eventList.get(i = 0);
            }
        }

        @Override
        protected void resetSecond() {
            if(i + 1 < eventList.size()) {
                second = eventList.get(j = i + 1);
            }
        }

        @Override
        protected void nextFirst() {
            int bound = second == null ? eventList.size() : j;
            first = (++i < bound) ? eventList.get(i) : null;

            if (first == null && second == null)
                findNextThread();
        }

        @Override
        protected void nextSecond() {
            second = (++j < eventList.size()) ? eventList.get(j) : null;

            if (first == null && second == null)
                findNextThread();
        }
    }
}
