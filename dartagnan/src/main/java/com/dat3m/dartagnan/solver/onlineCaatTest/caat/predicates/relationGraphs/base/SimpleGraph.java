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
import java.util.stream.Collectors;
import java.util.stream.Stream;


/*
    This is a simple graph that allows adding edges directly.
    It is mostly used as an internal implementation for many relationgraphs.
 */
public final class SimpleGraph extends AbstractBaseGraph {
    static int count = 0;
    private int thisCount;

    public SimpleGraph() {
        super();
        thisCount = count++;
    }


    private ArrayList<DataItem> outgoing = new ArrayList<>();
    private ArrayList<DataItem> ingoing = new ArrayList<>();
    private int edgeCount = 0;

    private int maxTime = 0;
    private int numEvents = 0;

    /*private int lastLevel = 0;

    private HashMap<Integer, SimpleGraph.DataItem> outgoingOld = new HashMap<>();
    private HashMap<Integer, SimpleGraph.DataItem> ingoingOld = new HashMap<>();*/

    //private final HashMap<Edge, Edge> edgeMap = new HashMap<>(100);


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
        //lastLevel = time;
        if (maxTime <= time) {
            return;
        }

        //System.out.println("BACKTRACK graph " + thisCount + " to time " + time);

        int newMaxTime = -1;
        for (DataItem item : outgoing) {
            if (item != null) {
                int oldItemTime = item.maxTime;
                item.backtrackTo(time);
                newMaxTime = newMaxTime < 0 ? item.maxTime : Math.max(newMaxTime, item.maxTime);
            }
        }
        //maxTime = newMaxTime < 0 ? maxTime : newMaxTime;

        for (DataItem item : ingoing) {
            if (item != null) {
                item.backtrackTo(time);
            }
        }


        /*final int boundOld = numEvents;
        int newMaxTimeOld = -1;
        for (int i = 0; i < boundOld; i++) {
            SimpleGraph.DataItem item = outgoingOld.get(i);
            if (item != null) {
                int oldItemTime = item.maxTime;
                item.backtrackTo(time);
                //newMaxTime = newMaxTime < 0 ? item.maxTime : Math.max(newMaxTime, item.maxTime);
            }
        }

        final int bound2Old = numEvents;
        for (int i = 0; i < bound2Old; i++) {
            SimpleGraph.DataItem item = ingoingOld.get(i);
            if (item != null) {
                item.backtrackTo(time);
            }
        }*/

        maxTime = newMaxTime < 0 ? maxTime : newMaxTime;

        assert(maxTime <= time);
        //validate();
    }


    private DataItem getItem(int e, EdgeDirection dir) {
        switch (dir) {
            case OUTGOING:
                DataItem toReturn = outgoing.size() > e ? outgoing.get(e) : null;
                //validate();
                return toReturn;
            case INGOING:
                return ingoing.size() > e ? ingoing.get(e) : null;
            default:
                return null;
        }
    }

    public Collection<Edge> getEdges(int e, EdgeDirection dir) {
        DataItem item = getItem(e, dir);
        return item == null ? Collections.emptyList() : item.edgeList;
    }

    public Edge get(Edge edge) {
        int firstId = edge.getFirst();
        int secondId = edge.getSecond();
        if (outgoing.size() <= firstId || ingoing.size() <= secondId) {
            return null;
        }
        DataItem item1 = outgoing.get(firstId);
        DataItem item2 = ingoing.get(secondId);
        if (item1 == null || item2 == null) {
            return null;
        }
        if (item1.size() <= item2.size()) {
            for (Edge e : item1) {
                if (e.getSecond() == secondId) {
                    return e;
                }
            }
            return null;
        } else {
            for (Edge e : item2) {
                if (e.getFirst() == firstId) {
                    return e;
                }
            }
            return null;
        }
    }

    @Override
    public int size() {
        return edgeCount;
    }

    @Override
    public int size(int e, EdgeDirection dir) {
        DataItem item = getItem(e, dir);
        return item == null ? 0 : item.size();
    }

    public boolean contains(Edge e) {
        return get(e) != null;
    }

    public boolean add(Edge e) {
        if (contains(e)) {
            return false;
        }

        /*if (e.getTime() > lastLevel) {
            lastLevel = e.getTime();
            System.out.println("Added edge of level " + lastLevel + " in graph " + thisCount);
        }*/

        //System.out.println("***********");

        int firstId = e.getFirst();
        int secondId = e.getSecond();
        maxTime = Math.max(maxTime, e.getTime());

        if (outgoing.size() <= firstId) {
            //System.out.println("Resize OUT-GRAPH " + thisCount + " from " + outgoing.size() + " to " + (firstId+1));
            outgoing.ensureCapacity(firstId + 1);
            while (outgoing.size() <= firstId) {
                outgoing.add(null);
            }
        }
        DataItem item1;
        if (outgoing.get(firstId) == null) {
            outgoing.remove(firstId);
            item1 = new DataItem(true);
            outgoing.add(firstId, item1);
        } else {
            item1 = outgoing.get(firstId);
        }
        item1.add(e);

        if (ingoing.size() <= secondId) {
            //System.out.println("Resize IN-GRAPH " + thisCount + " from " + ingoing.size() + " to " + (secondId+1));
            ingoing.ensureCapacity(secondId + 1);
            while (ingoing.size() <= secondId) {
                ingoing.add(null);
            }
        }
        DataItem item2;
        if (ingoing.get(secondId) == null) {
            ingoing.remove(secondId);
            item2 = new DataItem(false);
            ingoing.add(secondId, item2);
        } else {
            item2 = ingoing.get(secondId);
        }
        item2.add(e);

        if (numEvents <= Math.max(firstId, secondId)) {
            numEvents = Math.max(firstId, secondId) + 1;
        }

        maxTime = Math.max(maxTime, e.getTime());
        edgeCount++;

        /*outgoingOld.putIfAbsent(firstId, new SimpleGraph.DataItem(false));
        SimpleGraph.DataItem item1Old = outgoingOld.get(firstId);
        item1Old.add(e);

        ingoingOld.putIfAbsent(secondId, new SimpleGraph.DataItem(false));
        SimpleGraph.DataItem item2Old = ingoingOld.get(secondId);
        item2Old.add(e);*/


        //validate();

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
        //edgeMap.clear();
        outgoing.clear();
        ingoing.clear();

        /*outgoingOld.clear();
        ingoingOld.clear();*/
    }

    /*@Override
    public void validate() {
        List<Edge> missingIn;
        List<Edge> wrongIn;
        List<Edge> missingOut;
        List<Edge> wrongOut;

        wrongIn = edgeInStream().filter(e -> {
            return edgeInOldStream().noneMatch(i -> e.equals(i));
        }).toList();
        wrongOut = edgeStream().filter(e -> {
            return edgeOldStream().noneMatch(i -> e.equals(i));
        }).toList();
        missingIn = edgeInOldStream().filter(e -> {
            return edgeInStream().noneMatch(i -> e.equals(i));
        }).toList();
        missingOut = edgeOldStream().filter(e -> {
            return edgeStream().noneMatch(i -> e.equals(i));
        }).toList();

        if (!wrongIn.isEmpty()) {
            int i = 5;
        }
        if (!missingIn.isEmpty()) {
            int i = 5;
        }
        if (!missingOut.isEmpty()) {
            int i = 5;
        }
        if (!wrongOut.isEmpty()) {
            int i = 5;
        }
    }*/

    public Stream<Edge> edgeInStream() {
        return ingoing.stream()
                .filter(item -> item != null && !item.isEmpty())
                .flatMap(DataItem::stream);
    }

    /*public Stream<Edge> edgeOldStream() {
        return outgoingOld.values().stream()
                .filter(item -> item != null && !item.isEmpty())
                .flatMap(DataItem::stream);
    }

    public Stream<Edge> edgeInOldStream() {
        return ingoingOld.values().stream()
                .filter(item -> item != null && !item.isEmpty())
                .flatMap(DataItem::stream);
    }*/

    @Override
    public Stream<Edge> edgeStream() {
        return outgoing.stream()
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
                //final Map<Edge, Edge> edgeMap = SimpleGraph.this.edgeMap;
                int i = edgeList.size();
                while (--i >= 0) {
                    Edge e = edgeList.get(i);
                    if (e.getTime() > time) {
                        edgeList.remove(i);
                        if (deleteFromMap) {
                            SimpleGraph.this.edgeCount--;
                            //edgeMap.remove(e);
                        }
                    } else {
                        newMaxTime = Math.max(e.getTime(), newMaxTime);
                        break;
                    }
                }
                maxTime = newMaxTime;
                /*if (maxTime > time) {
                    int k = 5;
                }*/
            }
            /*if (edgeList.stream().filter(e -> e.getTime() > time).toList().size() > 0) {
                int i = 5;
            }*/
        }

    }

    private class EdgeIterator implements Iterator<Edge> {
        Iterator<DataItem> indexIterator = outgoing.iterator();
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
