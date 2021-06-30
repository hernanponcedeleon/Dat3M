package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph;

import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.utils.timeable.Timeable;
import com.dat3m.dartagnan.utils.timeable.Timestamp;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.*;
import java.util.stream.Stream;


//TODO: Do not recreate all DataItem items each run but only add new ones if a larger model is found.
// If the DataItems are reused, no time is spent on the usual resizing operations.
// We shouldn't use ArrayList for this resizing, cause it may use up to twice as many entries as needed
// Also it might be reasonable to always create all DataItems to avoid checks during runtime
public final class SimpleGraph extends AbstractEventGraph {
    private int size;
    private DataItem[] outgoing;
    private DataItem[] ingoing;

    @Override
    public List<EventGraph> getDependencies() {
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

    private DataItem get(EventData e, EdgeDirection dir) {
        DataItem item;
        switch (dir) {
            case Outgoing:
                item = outgoing[e.getId()];
                break;
            case Ingoing:
                item = ingoing[e.getId()];
                break;
            default:
                item = null;
        }
        return item;
    }

    public Collection<Edge> getEdges(EventData e, EdgeDirection dir) {
        DataItem item = get(e, dir);
        return item == null ? Collections.emptyList() : item.edgeArray;
    }


    public Edge get(Edge edge) {
        DataItem item = outgoing[edge.getFirst().getId()];
        if (item == null)
            return null;
        Timestamp t = item.edgeMap.get(edge.getSecond());
        return t == null ? null : edge.withTimestamp(t);
    }

    public Timestamp getTime(Edge edge) {
        return getTime(edge.getFirst(), edge.getSecond());
    }

    public Timestamp getTime(EventData a, EventData b) {
        DataItem item = outgoing[a.getId()];
        if (item == null)
            return Timestamp.INVALID;
        return item.edgeMap.getOrDefault(b, Timestamp.INVALID);
    }


    @Override
    public int size() {
        return size;
    }

    public int getMinSize() {
        return size;
    }

    public int getMinSize(EventData e, EdgeDirection dir) {
        DataItem item = get(e, dir);
        return item == null ? 0 : item.size();
    }

    public int getMaxSize() {
        return size;
    }

    public int getMaxSize(EventData e, EdgeDirection dir) {
        DataItem item = get(e, dir);
        return item == null ? 0 : item.size();
    }

    public int getEstimatedSize() {
        return size;
    }

    public int getEstimatedSize(EventData e, EdgeDirection dir) {
        DataItem item = get(e, dir);
        return item == null ? 0 : item.size();
    }

    public boolean contains(Edge e) {
        return contains(e.getFirst(), e.getSecond());
    }

    public boolean contains(EventData a, EventData b) {
        DataItem item = outgoing[a.getId()];
        return item != null && item.contains(b);
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
        boolean added = item1.add(e, EdgeDirection.Outgoing) && item2.add(e, EdgeDirection.Ingoing);
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
                .filter(item -> item != null && !item.edgeArray.isEmpty())
                .flatMap(item -> item.edgeArray.stream());
    }

    @Override
    public Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        if (outgoing == null) {
            return Stream.empty();
        }
        DataItem item = get(e, dir);
        return item == null ? Stream.empty() : item.stream();
    }

    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        if (outgoing == null) {
            return Collections.emptyIterator();
        }
        DataItem item = get(e, dir);
        return item == null ? Collections.emptyIterator() : item.iterator();
    }

    @Override
    public void constructFromModel(ExecutionModel context) {
        size = 0;
        outgoing = new DataItem[context.getEventList().size()];
        ingoing = new DataItem[context.getEventList().size()];
    }


    private static final class DataItem implements Iterable<Edge> {
        final ArrayList<Edge> edgeArray;
        final Map<EventData, Timestamp> edgeMap;
        Timestamp maxStamp;

        public DataItem() {
            edgeArray = new ArrayList<>();
            edgeMap = new HashMap<>();
            //edgeMap = Maps.newIdentityHashMap();
            maxStamp = Timestamp.ZERO;
        }

        public int size() {
            return edgeArray.size();
        }

        public boolean add(Edge e, EdgeDirection dir) {
            Timestamp t = e.getTime();
            switch (dir) {
                case Outgoing:
                    if (edgeMap.putIfAbsent(e.getSecond(), t) == null) {
                        edgeArray.add(e);
                        maxStamp = Timestamp.max(maxStamp, t);
                        return true;
                    }
                    break;
                case Ingoing:
                    if (edgeMap.putIfAbsent(e.getFirst(), t) == null) {
                        edgeArray.add(e);
                        maxStamp = Timestamp.max(maxStamp, t);
                        return true;
                    }
                    break;
            }
            return false;

        }

        public boolean contains(EventData e) {
            return edgeMap.containsKey(e);
        }

        public Iterator<Edge> iterator() {
            return edgeArray.iterator();
        }

        public Stream<Edge> stream() {
            return edgeArray.stream();
        }

        public void clear() {
            edgeArray.clear();
            edgeMap.clear();
            maxStamp = Timestamp.ZERO;
        }

        public void backtrack() {
            if (maxStamp.isInvalid()) {
                edgeArray.removeIf(Timeable::isInvalid);
                edgeMap.values().removeIf(Timestamp::isInvalid);
                Timestamp newMax = Timestamp.ZERO;
                for (Edge e : edgeArray) {
                    newMax  = Timestamp.max(e.getTime(), newMax);
                }
                maxStamp = newMax;
            }
        }

    }

}
