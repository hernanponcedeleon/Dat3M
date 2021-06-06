package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat;

import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.iteration.EdgeIterator;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelFencerel;
import com.dat3m.dartagnan.program.Thread;

import java.util.*;

public class FenceGraph extends StaticEventGraph {

    private final String fenceName;
    private Map<Thread, List<EventData>> threadFencesMap;

    public FenceGraph(RelFencerel fencerel) {
        this(fencerel.getFenceName());
    }

    public FenceGraph(String fenceName) {
        this.fenceName = fenceName;
    }

    //TODO: We might want to employ binary search instead of linear search
    @Override
    public boolean contains(EventData a, EventData b) {
        if (a.getThread() != b.getThread() || a.getLocalId() >= b.getLocalId())
            return false;
        for (EventData fence : threadFencesMap.get(a.getThread())) {
            if (a.getLocalId() < fence.getLocalId() && fence.getLocalId() < b.getLocalId()) {
                return true;
            }
        }
        return false;
    }

    @Override
    public void constructFromModel(ExecutionModel context) {
        super.constructFromModel(context);

        threadFencesMap = new HashMap<>();
        for (Thread t : context.getThreads()) {
            threadFencesMap.put(t, new ArrayList<>());
        }
        Set<EventData> fenceEvents = context.getFenceMap().get(fenceName);
        if (fenceEvents == null) {
            return;
        }

        for (EventData fence : fenceEvents) {
            threadFencesMap.get(fence.getThread()).add(fence);
        }
        for (List<EventData> fenceList : threadFencesMap.values()) {
            fenceList.sort(Comparator.comparingInt(EventData::getLocalId));
        }
        autoComputeSize();
    }

    @Override
    public Iterator<Edge> edgeIterator() {
        return new FenceIterator();
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        return new FenceIterator(e, dir);
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        int size = 0;
        if (dir == EdgeDirection.Outgoing) {
            EventData closestFence = getNextFence(e);
            size = closestFence == null ? 0 :
                    context.getThreadEventsMap().get(e.getThread()).size() - (closestFence.getLocalId() + 1);
        } else if (dir == EdgeDirection.Ingoing) {
            EventData closestFence = getPreviousFence(e);
            size = closestFence == null ? 0 : closestFence.getLocalId();
        }
        return size;
    }

    private EventData getNextFence(EventData e) {
        List<EventData> fences = threadFencesMap.get(e.getThread());
        if (fences.isEmpty()) {
            return null;
        }
        EventData closestFence = fences.get(fences.size() - 1);
        if (closestFence.getLocalId() <= e.getLocalId()) {
            return null;
        }

        for (int i = fences.size() - 2; i >= 0; i--) {
            EventData fence = fences.get(i);
            if (fence.getLocalId() > e.getLocalId()) {
                closestFence = fence;
            } else {
                break;
            }
        }
        return closestFence;
    }

    private EventData getPreviousFence(EventData e) {
        List<EventData> fences = threadFencesMap.get(e.getThread());
        if (fences.isEmpty()) {
            return null;
        }
        EventData closestFence = fences.get(0);
        if (closestFence.getLocalId() >= e.getLocalId()) {
            return null;
        }
        for (int i = 1; i < fences.size(); i++) {
            EventData fence = fences.get(i);
            if (fence.getLocalId() < e.getLocalId()) {
                closestFence = fence;
            } else {
                break;
            }
        }
        return closestFence;
    }


    private class FenceIterator extends EdgeIterator {

        Iterator<Thread> threadIterator;
        Thread curThread = null;
        List<EventData> threadEvents;
        List<EventData> fenceEvents;
        int lastFenceId;

        public FenceIterator() {
            super(true);
            threadIterator = context.getThreads().listIterator();
            nextThread();
        }

        public FenceIterator(EventData fixed, EdgeDirection dir) {
            super(fixed, dir);
            curThread = fixed.getThread();
            initThreadData();
            if (!fenceEvents.isEmpty()) {
                autoInit();
            }

        }

        private boolean areSeparatedByFence(EventData a, EventData b) {
            for (EventData fence : threadFencesMap.get(curThread)) {
                if (a.getLocalId() < fence.getLocalId() && fence.getLocalId() < b.getLocalId()) {
                    return true;
                }
            }
            return false;
        }

        private void initThreadData() {
            threadEvents = context.getThreadEventsMap().get(curThread);
            fenceEvents = threadFencesMap.get(curThread);
            lastFenceId = fenceEvents.isEmpty() ? -1 : fenceEvents.get(fenceEvents.size() - 1).getLocalId();
        }

        private void nextThread() {
            curThread = null;
            first = second = null;
            while (threadIterator.hasNext()) {
                curThread = threadIterator.next();
                initThreadData();
                if (fenceEvents.isEmpty()) {
                    curThread = null;
                } else {
                    resetFirst();
                    resetSecond();
                    if (first != null && second != null) {
                        break;
                    }
                }
            }
        }

        @Override
        protected void resetFirst() {
            first = threadEvents.get(0);
            if (fenceEvents.get(fenceEvents.size() - 1) == first || (second != null && !areSeparatedByFence(first, second))) {
                first = null;
            }

            if (first == null && second == null) {
                nextThread();
            }
        }

        @Override
        protected void resetSecond() {
            if (first == null) {
                int index = fenceEvents.get(0).getLocalId() + 1;
                if (index < threadEvents.size())
                    second = threadEvents.get(index);
            } else {
                Optional<EventData> e = fenceEvents.stream()
                        .filter(x -> x.getLocalId() > first.getLocalId()).findFirst();
                if (e.isPresent()) {
                    int index = e.get().getLocalId() + 1;
                    if (index < threadEvents.size()) {
                        second = threadEvents.get(index);
                    }
                }
            }

            if (first == null && second == null) {
                nextThread();
            }
        }

        @Override
        protected void nextFirst() {
            int nextIndex = first.getLocalId() + 1;
            first = null;
            if (nextIndex < lastFenceId) {
                EventData next = threadEvents.get(nextIndex);
                if (second == null || !next.isFence() || !next.getEvent().toString().equals(fenceName)
                        || areSeparatedByFence(next, second)) {
                    first = next;
                }
            }

            if (first == null && second == null) {
                nextThread();
            }
        }

        @Override
        protected void nextSecond() {
            int nextIndex = second.getLocalId() + 1;
            second = null;
            if (nextIndex < threadEvents.size()) {
                second = threadEvents.get(nextIndex);
            }

            if (first == null && second == null) {
                nextThread();
            }
        }
    }
}
