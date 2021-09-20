package com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.utils;

import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.AbstractRelationGraph;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.analysis.saturation.util.EdgeDirection;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.google.common.collect.Lists;

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
    private int size;
    private DataItem[] outgoing;
    private DataItem[] ingoing;
    private int maxTime = 0;

    @Override
    public List<RelationGraph> getDependencies() {
        return Collections.emptyList();
    }

    @Override
    public void backtrackTo(int time) {
        if (maxTime <= time) {
            return;
        }
        size = 0;
        for (DataItem item : outgoing) {
            if (item != null) {
                item.backtrackTo(time);
                size += item.size();
                maxTime = Math.max(maxTime, item.maxTime);
            }
        }

        for (DataItem item : ingoing) {
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
        return item == null ? Collections.emptyList() : item.edgeMap.keySet();
    }


    public Optional<Edge> get(Edge edge) {
        DataItem item = outgoing[edge.getFirst().getId()];
        return item != null ? Optional.ofNullable(item.get(edge)) : Optional.empty();
    }


    @Override
    public int size() {
        return size;
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
        DataItem item = outgoing[e.getFirst().getId()];
        return item != null && item.contains(e);
    }

    public boolean contains(EventData a, EventData b) {
        DataItem item = outgoing[a.getId()];
        return item != null && item.contains(new Edge(a, b));
    }

    public boolean add(Edge e) {
        int firstId = e.getFirst().getId();
        int secondId = e.getSecond().getId();
        DataItem item1 = outgoing[firstId];
        if (item1 == null) {
            outgoing[firstId] = item1 = new DataItem();
        }
        DataItem item2 = ingoing[secondId];
        if (item2 == null) {
            ingoing[secondId] = item2 = new DataItem();
        }

        boolean added = item1.add(e) && item2.add(e);
        if (added) {
            size++;
            maxTime = Math.max(maxTime, e.getTime());
        }
        return added;
    }

    public boolean addAll(Collection<? extends Edge> c) {
        boolean changed = false;
        for (Edge e : c) {
            changed |= add(e);
        }
        return changed;
    }

    public void clear() {
        size = 0;
        maxTime = 0;
        for (DataItem item : outgoing) {
            item.clear();
        }

        for (DataItem item : ingoing) {
            item.clear();
        }
    }

    @Override
    public Stream<Edge> edgeStream() {
        if (outgoing == null) {
            return Stream.empty();
        }
        return Arrays.stream(outgoing)
                .filter(item -> item != null && !item.isEmpty())
                .flatMap(DataItem::stream);
    }

    @Override
    public Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        if (outgoing == null) {
            return Stream.empty();
        }
        DataItem item = getItem(e, dir);
        return item == null ? Stream.empty() : item.stream();
    }

    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        if (outgoing == null) {
            return Collections.emptyIterator();
        }
        DataItem item = getItem(e, dir);
        return item == null ? Collections.emptyIterator() : item.iterator();
    }

    @Override
    public void constructFromModel(ExecutionModel model) {
        size = 0;
        maxTime = 0;
        outgoing = new DataItem[model.getEventList().size()];
        ingoing = new DataItem[model.getEventList().size()];
    }


    private static final class DataItem implements Iterable<Edge> {
        final Map<Edge, Edge> edgeMap;
        final List<Edge> edgeList;
        int maxTime;

        public DataItem() {
            edgeMap = new HashMap<>(32);
            edgeList = new ArrayList<>(32);
            maxTime = 0;
        }

        public int size() {
            return edgeList.size();
        }

        public boolean isEmpty() {
            return edgeList.isEmpty();
        }

        public boolean add(Edge e) {
            if (edgeMap.putIfAbsent(e, e) == null) {
                edgeList.add(e);
                maxTime = Math.max(maxTime, e.getTime());
                return true;
            }
            return false;
        }

        public boolean contains(Edge e) {
            return edgeMap.containsKey(e);
        }


        public Edge get(Edge e) { return edgeMap.get(e); }


        public Iterator<Edge> iterator() {
            return edgeList.iterator();
        }

        public Stream<Edge> stream() {
            // For some reason, the reversed order seems to be more beneficial
            return Lists.reverse(edgeList).stream();
        }

        public void clear() {
            edgeMap.clear();
            edgeList.clear();;
            maxTime = 0;
        }

        public void backtrackTo(int time) {
            if (maxTime > time) {
                int i = edgeList.size();
                while (--i >= 0) {
                    Edge e = edgeList.get(i);
                    if (e.getTime() > time) {
                        edgeList.remove(i);
                        edgeMap.remove(e);
                    } else {
                        maxTime = e.getTime();
                        return;
                    }
                }
                maxTime = 0;
            }
        }

    }

}
