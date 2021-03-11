package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.iteration.EdgeIterator;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

//TODO: The iteration fails, if there exists a thread without any events!
public class ExternalGraph extends StaticEventGraph {
    private Map<Thread, List<EventData>> threadEventsMap;

    @Override
    public boolean contains(Edge edge) {
        return edge.isCrossEdge();
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return a.getThread() != b.getThread();
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return context.getEventList().size() - context.getThreadEventsMap().get(e.getThread()).size();
    }

    @Override
    public Iterator<Edge> edgeIterator() {
        return new  ExtIterator();
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        return new ExtIterator(e, dir);
    }

    @Override
    public void initialize(ExecutionModel context) {
        super.initialize(context);
        threadEventsMap = context.getThreadEventsMap();
        int totalSize = context.getEventList().size();
        for (List<EventData> threadEvents : context.getThreadEventsMap().values()) {
            int threadSize = threadEvents.size();
            size += (totalSize - threadSize) * threadSize;
        }
    }

    // Not sure if this is clever
    //TODO: Fix this mess
    private class ExtIterator extends EdgeIterator {

        // NOTE: We might want to get the threads from elsewhere, in the case that
        // some threads are not in the current context/model
        // because they were empty or something.
        List<Thread> threads = context.getThreads();
        int tailThreadId = -1, headThreadId = -1;
        List<EventData> tailEvents, headEvents;
        int iTail = -1, iHead = -1;

        public ExtIterator() {
            super(true);
            if (threads.size() > 1)
                autoInit();
        }

        public ExtIterator(EventData e, EdgeDirection dir) {
            super(e, dir);

            if (threads.size() > 1)
                autoInit();
        }

        @Override
        protected void resetFirst() {
            tailThreadId = headThreadId == 0 ? 1 : 0;
            tailEvents = threadEventsMap.get(threads.get(tailThreadId));
            first = tailEvents.get(iTail = 0);
        }

        @Override
        protected void resetSecond() {
            headThreadId = tailThreadId == 0 ? 1 : 0;
            headEvents = threadEventsMap.get(threads.get(headThreadId));
            second = headEvents.get(iHead = 0);
        }

        @Override
        protected void nextFirst() {
            if (++iTail < tailEvents.size()) {
                first = tailEvents.get(iTail);
            } else {
                if (++tailThreadId == headThreadId)
                    ++tailThreadId;
                if (tailThreadId < threads.size()) {
                    tailEvents = threadEventsMap.get(threads.get(tailThreadId));
                    first = tailEvents.get(iTail = 0);
                } else {
                    first = null;
                    if (iterateFirstThenSecond) {
                        second = null; // abort
                    }
                }
            }
        }

        @Override
        protected void nextSecond() {
            if (++iHead < headEvents.size()) {
                second = headEvents.get(iHead);
            }
            else {
                if (++headThreadId == tailThreadId) {
                    ++headThreadId;
                }
                if (headThreadId < threads.size()) {
                    headEvents = threadEventsMap.get(threads.get(headThreadId));
                    second = headEvents.get(iHead = 0);
                } else {
                    second = null;
                    if (!iterateFirstThenSecond) {
                        first = null; // abort
                    }
                }
            }
        }
    }
}
