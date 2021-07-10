package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.utils;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.verification.model.Edge;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.Set;
import java.util.function.Consumer;
import java.util.stream.Stream;

// Encapsulates a Graph into a read-only Set
public class GraphSetView implements Set<Edge> {

    private final EventGraph graph;

    public GraphSetView(EventGraph graph) {
        this.graph = graph;
    }

    @Override
    public int size() {
        return graph.size();
    }

    @Override
    public boolean isEmpty() {
        return graph.isEmpty();
    }

    @Override
    public boolean contains(Object o) {
        if (!(o instanceof Edge)) {
            return false;
        }
        return graph.contains((Edge)o);
    }

    @Override
    public Iterator<Edge> iterator() {
        return graph.edgeIterator();
    }

    @Override
    public Stream<Edge> stream() {
        return graph.edgeStream();
    }

    @Override
    public void forEach(Consumer<? super Edge> action) {
        stream().forEach(action);
    }

    @Override
    public Object[] toArray() {
        ArrayList<Edge> edgeList = new ArrayList<>(graph.getEstimatedSize());
        stream().forEach(edgeList::add); // It is important that we do NOT perform edgeList.addAll(this)
        return edgeList.toArray();
    }

    @Override
    public <T> T[] toArray(T[] a) {
        ArrayList<Edge> edgeList = new ArrayList<>(graph.getEstimatedSize());
        stream().forEach(edgeList::add); // It is important that we do NOT perform edgeList.addAll(this)
        return edgeList.toArray(a);
    }

    @Override
    public boolean add(Edge edge) {
        return false;
    }

    @Override
    public boolean remove(Object o) {
        return false;
    }

    @Override
    public boolean containsAll(Collection<?> c) {
        for (Object e : c) {
            if (!contains(e))
                return false;
        }
        return true;
    }

    @Override
    public boolean addAll(Collection<? extends Edge> c) {
        return false;
    }

    @Override
    public boolean retainAll(Collection<?> c) {
        return false;
    }

    @Override
    public boolean removeAll(Collection<?> c) {
        return false;
    }

    @Override
    public void clear() { }
}
