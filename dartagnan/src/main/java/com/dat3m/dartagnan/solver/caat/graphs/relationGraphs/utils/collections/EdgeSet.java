package com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.utils.collections;

import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.Edge;

import java.util.*;
import java.util.stream.Stream;

/*
    This is an open addressing hashset implementation with linear probing.
    It is specialized to hold edges.
 */
public class EdgeSet implements Set<Edge> {

    private static final List<Integer> powersOfTwo;

    static {
        powersOfTwo = new ArrayList<>(32);
        for (int i = 0; i < 32; i++) {
            powersOfTwo.add(1 << i);
        }
    }

    private static final float LOADFACTOR = 0.4f;

    private Edge[] edges = new Edge[0];
    private int numElements = 0;

    public EdgeSet(int capacity) {
        resize(capacity);
    }

    public EdgeSet() {
        this(50);
    }

    private static int getHashIndex(int hashCode, int length) {
        return hashCode & (length-1);
    }

    private int findSlot(Edge key) {
        final Edge[] edges = this.edges;
        final int length = edges.length;
        int slot = getHashIndex(key.hashCode(), length);

        do {
            Edge e = edges[slot];
            if (e == null || e.equals(key)) {
                return slot;
            }
            if (++slot == length) {
                slot = 0;
            }
        } while (true);
    }

    private void resize(int newCapacity) {
        assert numElements < newCapacity;

        newCapacity = powersOfTwo.get(~Collections.binarySearch(powersOfTwo, newCapacity | 1));

        final Edge[] oldEdges = edges;
        int oldSize = numElements;
        final int oldCapacity = oldEdges.length;

        final Edge[] edges = new Edge[newCapacity];
        this.edges = edges;
        for (int i = 0; i < oldCapacity && oldSize > 0; i++) {
            Edge e = oldEdges[i];
            if (e != null) {
                edges[findSlot(e)] = e;
                oldSize--;
            }
        }
    }

    public int size() {
        return numElements;
    }

    @Override
    public boolean isEmpty() {
        return size() == 0;
    }

    @Override
    public boolean contains(Object o) {
        return (o instanceof Edge) && contains((Edge)o);
    }

    @Override
    public Iterator<Edge> iterator() {
        return new EdgeIterator();
    }

    @Override
    public Stream<Edge> stream() {
        return Arrays.stream(edges).filter(Objects::nonNull);
    }

    @Override
    public Object[] toArray() {
        //TODO: this is temporary and should get fixed, but we don't use it anyways
        // (the returned arrays contains NULL values!)
        return edges;
    }

    @Override
    public <T> T[] toArray(T[] a) {
        //TODO: this is temporary and should get fixed, but we don't use it anyways
        return Arrays.asList(edges).toArray(a);
    }

    public Edge get(Edge edge) {
        return this.edges[findSlot(edge)];
    }

    public boolean contains(Edge edge) {
        return get(edge) != null;
    }

    public boolean add(Edge edge) {
        final Edge[] edges = this.edges;
        final int slot = findSlot(edge);
        if (edges[slot] == null) {
            edges[slot] = edge;
            numElements++;
            if (edges.length * LOADFACTOR < numElements) {
                resize((int)(edges.length * 1.8f) + 5);
            }
            return true;
        } else {
            return false;
        }
    }

    @Override
    public boolean remove(Object o) {
        return o instanceof Edge && remove((Edge)o);
    }

    public boolean remove(Edge key) {
        return removeAtIndex(findSlot(key));
    }

    private boolean removeAtIndex(int i) {
        final Edge[] edges = this.edges;
        Edge e = edges[i];
        if (e == null) {
            return false;
        }
        // Edge is contained, so we remove it and replace it by other edges
        // if possible
        int j = i;
        while (true)  {
            if (++j == edges.length) {
                j = 0;
            }
            e = edges[j];
            if (e == null) {
                break;
            }
            int k = getHashIndex(e.hashCode(), edges.length);
            if ((j > i && (k <= i || k > j)) || (k <= i && k > j)) {
                edges[i] = e;
                i = j;
            }
        }
        numElements--;
        edges[i] = null;
        return true;
    }

    @Override
    public boolean containsAll(Collection<?> c) {
        for (Object o : c) {
            if (!contains(o)) {
                return false;
            }
        }
        return true;
    }

    @Override
    public boolean addAll(Collection<? extends Edge> c) {
        boolean changed = false;
        for (Edge e : c) {
            changed |= add(e);
        }
        return changed;
    }

    @Override
    public boolean retainAll(Collection<?> c) {
        Edge[] edges = this.edges;
        boolean changed = false;
        for (int i = 0; i < edges.length; i++) {
            Edge e = edges[i];
            if (e != null && !c.contains(e)) {
                removeAtIndex(i--);
                changed = true;
            }
        }
        return changed;
    }

    @Override
    public boolean removeAll(Collection<?> c) {
        boolean changed = false;
        for (Object o : c) {
            changed |= remove(o);
        }
        return changed;
    }

    @Override
    public void clear() {
        Arrays.fill(edges, null);
        numElements = 0;
    }


    private class EdgeIterator implements Iterator<Edge> {

        int index = 0;
        final Edge[] edges = EdgeSet.this.edges;
        Edge edge;

        @Override
        public boolean hasNext() {
            final Edge[] edges = this.edges;
            while (index < edges.length) {
                edge = edges[index++];
                if (edge != null) {
                    return true;
                }
            }
            return false;
        }

        @Override
        public Edge next() {
            return edge;
        }
    }


}
