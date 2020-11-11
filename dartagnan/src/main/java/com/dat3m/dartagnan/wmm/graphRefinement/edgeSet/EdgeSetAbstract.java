package com.dat3m.dartagnan.wmm.graphRefinement.edgeSet;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.graphRefinement.GraphContext;
import com.dat3m.dartagnan.wmm.graphRefinement.ReasonGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.EventData;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationData;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import java.util.*;

public abstract class EdgeSetAbstract implements EdgeSet {
    protected RelationData relation;
    protected SortedMap<Integer, Entry> history;
    protected ReasonGraph reasonGraph;
    protected GraphContext context;

    public RelationData getRelation() {
        return this.relation;
    }

    public EdgeSetAbstract(RelationData rel) {
        relation = rel;
        history = new TreeMap<>();
        history.put(0, new Entry(0));
    }

    protected boolean add(Edge edge, int time) {
        if (this.contains(edge))
            return false;

        if (!history.containsKey(time))
            history.put(time, new Entry(time));
        return history.get(time).add(edge);
    }

    protected Set<Edge> addAll(Set<Edge> edges, int time) {
        if (!history.containsKey(time))
            history.put(time, new Entry(time));
        Entry entry = history.get(time);
        Set<Edge> addedEdges = new HashSet<>(edges.size());

        for (Edge edge : edges)
            if (!this.contains(edge)) {
                entry.add(edge);
                addedEdges.add(edge);
            }
        return addedEdges;
    }

    // Notifies this edge set that another edge set has changed
    // returns the set of updated edges
    public Set<Edge> update(EdgeSet changedSet, Set<Edge> addedEdges, int time) {
        return Collections.EMPTY_SET;
    }

    public int getTime(Edge edge) {
        for (Entry entry : history.values()) {
            if (entry.edges.contains(edge))
                return entry.time;
        }
        return -1;
    }

    public boolean contains(Edge edge) {
        return getTime(edge) > -1;
    }

    public void forgetHistory(int from) {
        history.tailMap(from + 1).clear();
    }

    public void mergeHistory(int mergePoint) {
        if (!history.containsKey(mergePoint))
            history.put(mergePoint, new Entry(mergePoint));
        Entry mergeEntry = history.get(mergePoint);

        SortedMap<Integer, Entry> future = history.tailMap(mergePoint + 1);
        for (Entry entry : future.values())
            mergeEntry.mergeWith(entry);
        future.clear();
    }

    @Override
    public Set<Edge> initialize(GraphContext context) {
        history.clear();
        history.put(0, new Entry(0));
        this.reasonGraph = context.getReasonGraph();
        this.context = context;
        return Collections.EMPTY_SET;
    }

    public abstract Conjunction<CoreLiteral> computeShortestReason(Edge edge);

    public Iterator<Edge> edgeIterator() {
        return new EdgeIterator();
    }

    public Iterator<Edge> inEdgeIterator(EventData e) {
        return new InEdgeIterator(e);
    }

    public Iterator<Edge> outEdgeIterator(EventData e) {
        return new OutEdgeIterator(e);
    }

    protected static class Entry {
        public int time;
        public Set<Edge> edges;
        public Map<EventData, Set<Edge>> inEdges;
        public Map<EventData, Set<Edge>> outEdges;

        public Entry(int time) {
            this.time = time;
            edges = new HashSet<>();
            inEdges = new HashMap<>();
            outEdges = new HashMap<>();
        }

        public boolean add(Edge edge) {
            if(!edges.add(edge))
                return false;
            if (!inEdges.containsKey(edge.getSecond()))
                inEdges.put(edge.getSecond(), new HashSet<>());
            if (!outEdges.containsKey(edge.getFirst()))
                outEdges.put(edge.getFirst(), new HashSet<>());
            inEdges.get(edge.getSecond()).add(edge);
            outEdges.get(edge.getFirst()).add(edge);
            return true;
        }

        public boolean addAll(Collection<Edge> edges) {
            boolean changed = false;
            for (Edge edge : edges)
                changed |= add(edge);
            return changed;
        }

        public void mergeWith(Entry other) {
            this.edges.addAll(other.edges);

            for (EventData e : other.inEdges.keySet()) {
                if (!inEdges.containsKey(e))
                    inEdges.put(e, other.inEdges.get(e));
                else
                    inEdges.get(e).addAll(other.inEdges.get(e));
            }

            for (EventData e : other.outEdges.keySet()) {
                if (!outEdges.containsKey(e))
                    outEdges.put(e, other.outEdges.get(e));
                else
                    outEdges.get(e).addAll(other.outEdges.get(e));
            }
        }

        @Override
        public String toString() {
            return "{" + edges + "}";
        }
    }

    @Override
    public String toString() {
        return history.toString();
    }

    protected class EdgeIterator implements Iterator<Edge> {
        Iterator<Entry> outerIterator;
        Iterator<Edge> innerIterator;

        public EdgeIterator() {
            outerIterator = history.values().iterator();
        }

        @Override
        public boolean hasNext() {
            while ((innerIterator == null || !innerIterator.hasNext()) && outerIterator.hasNext())
                innerIterator = outerIterator.next().edges.iterator();
            return (innerIterator != null && innerIterator.hasNext());
        }

        @Override
        public Edge next() {
            return innerIterator.next();
        }
    }

    protected class InEdgeIterator implements Iterator<Edge> {
        Iterator<Entry> outerIterator;
        Iterator<Edge> innerIterator;
        EventData e;

        public InEdgeIterator(EventData e) {
            outerIterator = history.values().iterator();
            this.e = e;
        }

        @Override
        public boolean hasNext() {
            while ((innerIterator == null || !innerIterator.hasNext()) && outerIterator.hasNext()) {
                Entry entry = outerIterator.next();
                innerIterator = entry.inEdges.containsKey(e) ? entry.inEdges.get(e).iterator() : null;
            }
            return (innerIterator != null && innerIterator.hasNext());
        }

        @Override
        public Edge next() {
            return innerIterator.next();
        }
    }

    protected class OutEdgeIterator implements Iterator<Edge> {
        Iterator<Entry> outerIterator;
        Iterator<Edge> innerIterator;
        EventData e;

        public OutEdgeIterator(EventData e) {
            outerIterator = history.values().iterator();
            this.e = e;
        }

        @Override
        public boolean hasNext() {
            while ((innerIterator == null || !innerIterator.hasNext()) && outerIterator.hasNext()) {
                Entry entry = outerIterator.next();
                innerIterator = entry.outEdges.containsKey(e) ? entry.outEdges.get(e).iterator() : null;
            }
            return (innerIterator != null && innerIterator.hasNext());
        }

        @Override
        public Edge next() {
            return innerIterator.next();
        }
    }
}
