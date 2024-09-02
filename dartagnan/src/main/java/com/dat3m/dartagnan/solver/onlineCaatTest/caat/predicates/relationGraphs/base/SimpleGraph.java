package com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.base;

import com.dat3m.dartagnan.solver.onlineCaatTest.caat.misc.EdgeDirection;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.misc.EdgeList;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.domain.Domain;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.base.AbstractBaseGraph;

import java.util.*;
import java.util.stream.Stream;


/*
    This is a simple graph that allows adding edges directly.
    It is mostly used as an internal implementation for many relationgraphs.
 */
public final class SimpleGraph extends AbstractBaseGraph {
    private HashMap<Integer, DataItem> outgoing = new HashMap<>();
    private HashMap<Integer, DataItem> ingoing = new HashMap<>();
    private int maxTime = 0;
    private int numEvents = 0;

    private final HashMap<Edge, Edge> edgeMap = new HashMap<>(100);


    @Override
    public List<RelationGraph> getDependencies() {
        return Collections.emptyList();
    }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Edge> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        List<Edge> changes = new ArrayList<>(added.size());
        for (Edge e : (Collection<Edge>) added) {
            if (add(e)) {
                changes.add(e);
            }
        }
        return changes;
    }

    @Override
    public void backtrackTo(int time) {
        if (maxTime <= time) {
            return;
        }
        final int bound = numEvents;
        int newMaxTime = -1;
        for (int i = 0; i < bound; i++) {
            DataItem item = outgoing.get(i);
            if (item != null) {
                int oldItemTime = item.maxTime;
                item.backtrackTo(time);
                newMaxTime = newMaxTime < 0 ? item.maxTime : Math.max(newMaxTime, item.maxTime);
            }
        }
        maxTime = newMaxTime < 0 ? maxTime : newMaxTime;

        final int bound2 = numEvents;
        for (int i = 0; i < bound2; i++) {
            DataItem item = ingoing.get(i);
            if (item != null) {
                item.backtrackTo(time);
            }
        }

        assert(maxTime <= time);
    }


    private DataItem getItem(int e, EdgeDirection dir) {
        switch (dir) {
            case OUTGOING:
               return outgoing.get(e);
            case INGOING:
                return ingoing.get(e);
            default:
                return null;
        }
    }

    public Collection<Edge> getEdges(int e, EdgeDirection dir) {
        DataItem item = getItem(e, dir);
        return item == null ? Collections.emptyList() : item.edgeList;
    }

    public Edge get(Edge edge) { return edgeMap.get(edge); }

    @Override
    public int size() {
        return edgeMap.size();
    }

    @Override
    public int size(int e, EdgeDirection dir) {
        DataItem item = getItem(e, dir);
        return item == null ? 0 : item.size();
    }

    public boolean contains(Edge e) {
        return edgeMap.containsKey(e);
    }

    public boolean add(Edge e) {
        if (edgeMap.putIfAbsent(e, e) != null) {
            return false;
        }

        int firstId = e.getFirst();
        int secondId = e.getSecond();
        maxTime = Math.max(maxTime, e.getTime());

        outgoing.putIfAbsent(firstId, new SimpleGraph.DataItem(true));
        DataItem item1 = outgoing.get(firstId);
        item1.add(e);

        ingoing.putIfAbsent(secondId, new SimpleGraph.DataItem( false));
        DataItem item2 = ingoing.get(secondId);
        item2.add(e);

        if (numEvents <= Math.max(firstId, secondId)) {
            numEvents = Math.max(firstId, secondId) + 1                                                                                                                                                                                                                 ;
        }

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
        outgoing.clear();
        ingoing.clear();
    }

    @Override
    public Stream<Edge> edgeStream() {
       return outgoing.values().stream()
                .filter(item -> item != null && !item.isEmpty())
                .flatMap(DataItem::stream);
    }

    @Override
    public Stream<Edge> edgeStream(int e, EdgeDirection dir) {
        DataItem item = getItem(e, dir);
        return item == null ? Stream.empty() : item.stream();
    }

    @Override
    public Iterator<Edge> edgeIterator(int e, EdgeDirection dir) {
        DataItem item = getItem(e, dir);
        return item == null ? Collections.emptyIterator() : item.iterator();
    }

    @Override
    public Iterator<Edge> edgeIterator() {
        return new EdgeIterator();
    }

    @Override
    public void initializeToDomain(Domain<?> domain) {
        super.initializeToDomain(domain);

        clear();

        numEvents = domain.size();
    }

    @Override
    public String toString() {
        return name != null ? name : SimpleGraph.class.getSimpleName() + ": " + size();
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
            //TODO: In case of online solving the list is no longer sorted. Can it be fixed?
            //NOTE: We use the fact that the edge list
            // should be sorted by timestamp (since edges with higher timestamp get added later)
            int newMaxTime = 0;
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
                        newMaxTime = Math.max(e.getTime(), newMaxTime);
                    }
                }
                maxTime = newMaxTime;
                if (maxTime > time) {
                    int k = 5;
                }
            }
        }

    }

    private class EdgeIterator implements Iterator<Edge> {
        Iterator<DataItem> indexIterator = outgoing.values().iterator();
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
                while (indexIterator.hasNext()) {
                    DataItem item = indexIterator.next();
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
