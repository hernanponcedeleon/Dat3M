package com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.utils;

import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.AbstractRelationGraph;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.analysis.saturation.util.EdgeDirection;
import com.dat3m.dartagnan.utils.timeable.Timeable;
import com.dat3m.dartagnan.utils.timeable.Timestamp;
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
    private int size;
    private DataItem[] outgoing;
    private DataItem[] ingoing;

    @Override
    public List<RelationGraph> getDependencies() {
        return Collections.emptyList();
    }

    @Override
    public void backtrack() {
        size = 0;
        for (DataItem item : outgoing) {
            if (item != null) {
                item.backtrack();
                size += item.size();
            }
        }

        for (DataItem item : ingoing) {
            if (item != null) {
                item.backtrack();
            }
        }
    }

    private DataItem getItem(EventData e, EdgeDirection dir) {
        DataItem item;
        switch (dir) {
            case OUTGOING:
                item = outgoing[e.getId()];
                break;
            case INGOING:
                item = ingoing[e.getId()];
                break;
            default:
                item = null;
        }
        return item;
    }

    public Collection<Edge> getEdges(EventData e, EdgeDirection dir) {
        DataItem item = getItem(e, dir);
        return item == null ? Collections.emptyList() : item.edgeMap.keySet();
    }


    public Optional<Edge> get(Edge edge) {
        DataItem item = outgoing[edge.getFirst().getId()];
        return item != null ? Optional.ofNullable(item.get(edge)) : Optional.empty();
    }

    public Timestamp getTime(Edge edge) {
        //Optional<Edge> e = get(edge);
        return get(edge).map(Edge::getTime).orElse(Timestamp.INVALID);
        //return e != null ? e.getTime() : Timestamp.INVALID;
    }

    public Timestamp getTime(EventData a, EventData b) {
        return getTime(new Edge(a, b));
    }


    @Override
    public int size() {
        return size;
    }

    public int getMinSize() {
        return size;
    }

    public int getMinSize(EventData e, EdgeDirection dir) {
        DataItem item = getItem(e, dir);
        return item == null ? 0 : item.size();
    }

    public int getMaxSize() {
        return size;
    }

    public int getMaxSize(EventData e, EdgeDirection dir) {
        DataItem item = getItem(e, dir);
        return item == null ? 0 : item.size();
    }

    public int getEstimatedSize() {
        return size;
    }

    public int getEstimatedSize(EventData e, EdgeDirection dir) {
        DataItem item = getItem(e, dir);
        return item == null ? 0 : item.size();
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
        DataItem item2 = ingoing[secondId];
        if (item1 == null) {
            outgoing[firstId] = item1 = new DataItem();
        }
        if (item2 == null) {
            ingoing[secondId] = item2 = new DataItem();
        }

        boolean added = item1.add(e) && item2.add(e);
        if (added) {
            size++;
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
        outgoing = new DataItem[model.getEventList().size()];
        ingoing = new DataItem[model.getEventList().size()];
    }


    private static final class DataItem implements Iterable<Edge> {
        final Map<Edge, Edge> edgeMap;
        final Set<Edge> edgeSet;
        Timestamp maxStamp;

        public DataItem() {
            edgeMap = new HashMap<>();
            edgeSet = edgeMap.keySet();
            maxStamp = Timestamp.ZERO;
        }

        public int size() {
            return edgeMap.size();
        }

        public boolean isEmpty() {
            return edgeMap.isEmpty();
        }

        public boolean add(Edge e) {
            if (edgeMap.putIfAbsent(e, e) == null) {
                maxStamp = Timestamp.max(maxStamp, e.getTime());
                return true;
            }
            return false;
        }

        public boolean contains(Edge e) {
            return edgeMap.containsKey(e);
        }


        public Edge get(Edge e) { return edgeMap.get(e); }


        public Iterator<Edge> iterator() {
            return edgeSet.iterator();
        }

        public Stream<Edge> stream() {
            return edgeSet.stream();
        }

        public void clear() {
            edgeMap.clear();
            maxStamp = Timestamp.ZERO;
        }

        public void backtrack() {
            if (maxStamp.isInvalid()) {
                edgeSet.removeIf(Timeable::isInvalid);
                maxStamp = edgeSet.stream().map(Edge::getTime).reduce(Timestamp.ZERO, Timestamp::max);
            }
        }

    }

}
