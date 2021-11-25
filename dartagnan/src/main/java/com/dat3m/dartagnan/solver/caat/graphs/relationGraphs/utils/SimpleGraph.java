package com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.utils;

import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.AbstractRelationGraph;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.utils.collections.EdgeList;
import com.dat3m.dartagnan.solver.caat.util.EdgeDirection;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.*;
import java.util.stream.Stream;


//TODO: Do not recreate all DataItem items each run but only add new ones if a larger model is found.
// If the DataItems are reused, no time is spent on the usual resizing operations.
// We shouldn't use ArrayList for this resizing, cause it may use up to twice as many entries as needed
// Also it might be reasonable to always create all DataItems to avoid checks during runtime
//TODO 2: Check if it is worth to maintain an extra array per DataItem for iteration.
// This might be relevant in particular with the first idea

/*
    This is a simple graph that allows adding edges directly.
    It is mostly used as an internal implementation for many event graphs.
 */
public final class SimpleGraph extends AbstractRelationGraph {
    private DataItem[] outgoing = new DataItem[0];
    private DataItem[] ingoing = new DataItem[0];
    private int maxTime = 0;
    private int numEvents = 0;

    private final HashMap<Edge, Edge> edgeMap = new HashMap<>();

    @Override
    public List<RelationGraph> getDependencies() {
        return Collections.emptyList();
    }

    @Override
    public void backtrackTo(int time) {
        if (maxTime <= time) {
            return;
        }
        final int bound = Math.min(numEvents, outgoing.length);
        for (int i = 0; i < bound; i++) {
            DataItem item = outgoing[i];
            if (item != null) {
                item.backtrackTo(time);
                maxTime = Math.max(maxTime, item.maxTime);
            }
        }

        final int bound2 = Math.min(numEvents, ingoing.length);
        for (int i = 0; i < bound2; i++) {
            DataItem item = ingoing[i];
            if (item != null) {
                item.backtrackTo(time);
            }
        }

    }

    private DataItem getItem(EventData e, EdgeDirection dir) {
        switch (dir) {
            case OUTGOING:
                return outgoing[e.getId()];
            case INGOING:
                return ingoing[e.getId()];
            default:
                return null;
        }
    }

    public Collection<Edge> getEdges(EventData e, EdgeDirection dir) {
        DataItem item = getItem(e, dir);
        return item == null ? Collections.emptyList() : item.edgeList;
    }


    public Optional<Edge> get(Edge edge) {
        return Optional.ofNullable(edgeMap.get(edge));
    }


    @Override
    public int size() {
        return edgeMap.size();
    }

    @Override
    public int getMinSize() {
        return size();
    }

    @Override
    public int getMaxSize() {
        return size();
    }

    @Override
    public int getEstimatedSize() {
        return size();
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        DataItem item = getItem(e, dir);
        return item == null ? 0 : item.size();
    }

    @Override
    public int getMaxSize(EventData e, EdgeDirection dir) {
        return getMinSize(e, dir);
    }

    @Override
    public int getEstimatedSize(EventData e, EdgeDirection dir) {
        return getMinSize(e, dir);
    }

    public boolean contains(Edge e) {
        return edgeMap.containsKey(e);
    }

    public boolean contains(EventData a, EventData b) {
        return contains(new Edge(a, b));
    }

    public boolean add(Edge e) {
        if (edgeMap.putIfAbsent(e, e) != null) {
            return false;
        }
        int firstId = e.getFirst().getId();
        int secondId = e.getSecond().getId();
        maxTime = Math.max(maxTime, e.getTime());
        DataItem item1 = outgoing[firstId];
        if (item1 == null) {
            outgoing[firstId] = item1 = new DataItem(true);
        }
        item1.add(e);

        DataItem item2 = ingoing[secondId];
        if (item2 == null) {
            ingoing[secondId] = item2 = new DataItem( false);
        }
        item2.add(e);

        return true;
    }

    public boolean addAll(Collection<? extends Edge> c) {
        boolean changed = false;
        for (Edge e : c) {
            changed |= add(e);
        }
        return changed;
    }

    public void clear() {
        maxTime = 0;
        edgeMap.clear();

        final int bound = Math.min(numEvents, outgoing.length);
        for (int i = 0; i < bound; i++) {
            DataItem item = outgoing[i];
            if (item != null) {
                item.clear();
            }
        }

        final int bound2 = Math.min(numEvents, ingoing.length);
        for (int i = 0; i < bound2; i++) {
            DataItem item = ingoing[i];
            if (item != null) {
                item.clear();
            }
        }
    }

    @Override
    public Stream<Edge> edgeStream() {
        return Arrays.stream(outgoing, 0, Math.min(numEvents, outgoing.length))
                .filter(item -> item != null && !item.isEmpty())
                .flatMap(DataItem::stream);
    }

    @Override
    public Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        DataItem item = getItem(e, dir);
        return item == null ? Stream.empty() : item.stream();
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        DataItem item = getItem(e, dir);
        return item == null ? Collections.emptyIterator() : item.iterator();
    }

    @Override
    public Iterator<Edge> edgeIterator() {
        return new EdgeIterator();
    }

    @Override
    public void constructFromModel(ExecutionModel model) {
        numEvents = model.getEventList().size();
        if (numEvents > outgoing.length) {
            final int newCapacity = numEvents + 20; // We give a buffer of 20 extra events
            outgoing = Arrays.copyOf(outgoing, newCapacity);
            ingoing = Arrays.copyOf(ingoing, newCapacity);
        }
        clear();
    }


    private final class DataItem implements Iterable<Edge> {
        final List<Edge> edgeList;
        final boolean deleteFromMap;
        int maxTime;

        public DataItem(boolean deleteFromMap) {
            edgeList = new EdgeList(20);
            this.deleteFromMap = deleteFromMap;
            maxTime = 0;
        }

        public int size() {
            return edgeList.size();
        }

        public boolean isEmpty() {
            return edgeList.isEmpty();
        }

        public boolean add(Edge e) {
            edgeList.add(e);
            maxTime = Math.max(maxTime, e.getTime());
            return true;
        }


        public Iterator<Edge> iterator() {
            return edgeList.iterator();
        }

        public Stream<Edge> stream() {
            return edgeList.stream();
        }

        public void clear() {
            edgeList.clear();
            maxTime = 0;
        }

        public void backtrackTo(int time) {
            //NOTE: We use the fact that the edge list
            // should be sorted by timestamp (since edges with higher timestamp get added later)
            if (maxTime > time) {
                final List<Edge> edgeList = this.edgeList;
                final Map<Edge, Edge> edgeMap = SimpleGraph.this.edgeMap;
                int i = edgeList.size();
                while (--i >= 0) {
                    Edge e = edgeList.get(i);
                    if (e.getTime() > time) {
                        edgeList.remove(i);
                        if (deleteFromMap) {
                            edgeMap.remove(e);
                        }
                    } else {
                        maxTime = e.getTime();
                        return;
                    }
                }
                maxTime = 0;
            }
        }

    }

    private class EdgeIterator implements Iterator<Edge> {

        int index = -1;
        List<Edge> innerList = Collections.emptyList();
        int innerIndex = 0;
        Edge edge = null;

        public EdgeIterator() {
            findNext();
        }

        private void findNext() {
            edge = null;
            if (++innerIndex >= innerList.size()) {
                innerIndex = 0;
                while (++index < numEvents) {
                    DataItem item = outgoing[index];
                    if (item != null && !item.isEmpty()) {
                        innerList = item.edgeList;
                        edge = innerList.get(0);
                        return;
                    }
                }
            } else {
                edge = innerList.get(innerIndex);
            }
        }

        @Override
        public boolean hasNext() {
            return edge != null;
        }

        @Override
        public Edge next() {
            Edge e = edge;
            findNext();
            return e;
        }
    }

}
