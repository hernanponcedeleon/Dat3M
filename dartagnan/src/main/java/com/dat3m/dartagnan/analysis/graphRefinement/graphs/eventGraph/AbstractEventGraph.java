package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph;

import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;

public abstract class AbstractEventGraph implements EventGraph {

    protected ExecutionModel context;

    public AbstractEventGraph() {
    }

    @Override
    public void initialize(ExecutionModel context) {
        this.context = context;
    }

    @Override
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {
        addedEdges.clear();
        return addedEdges;
    }


    @Override
    public int size() {
        int i = 0;
        for (Edge e : this) {
            i++;
        }
        return i;
    }

    @Override
    public boolean isEmpty() {
        return getEstimatedSize() == 0;
    }

    @Override
    public boolean contains(Object o) {
        return (o instanceof Edge) && this.contains((Edge)o);
    }

    @Override
    public Iterator<Edge> iterator() {
        return edgeIterator();
    }

    @Override
    public Object[] toArray() {
        ArrayList<Edge> edgeList = new ArrayList<>(this.size());
        iterator().forEachRemaining(edgeList::add);
        return edgeList.toArray();
    }

    @Override
    public <T> T[] toArray(T[] a) {
        ArrayList<Edge> edgeList = new ArrayList<>(this.size());
        iterator().forEachRemaining(edgeList::add);
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
    public void clear() {

    }
}
