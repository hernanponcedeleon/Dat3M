package com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.utils;

import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.RelationGraph;

import java.util.Collection;
import java.util.Iterator;
import java.util.Set;
import java.util.function.Consumer;
import java.util.stream.Collectors;
import java.util.stream.Stream;

// Encapsulates a Graph into a read-only Set
public class GraphSetView implements Set<Edge> {

    private final RelationGraph graph;

    public GraphSetView(RelationGraph graph) {
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
        // We deliberately use streams to perform this task
        return this.stream().toArray(Edge[]::new);
    }

    @Override
    public <T> T[] toArray(T[] a) {
        // We deliberately use streams to perform this task
        return this.stream().collect(Collectors.toList()).toArray(a);
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
        return c.stream().allMatch(this::contains);
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
