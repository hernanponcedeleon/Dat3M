package com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.utils;

import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.Edge;

import java.util.*;
import java.util.stream.Stream;

/*
    This is an open addressing hashset implementation with linear probing.
    It is specialized to hold edges.
 */
public class EdgeSet implements Set<Edge> {

    // A list of primes to use as capacities
    // Note: We assume that we don't have any edgeSet with more than 1151 edges
    // TODO: Extend this list and prune most primes numbers (we don't need primes with minor differences)
    private static final List<Integer> PRIMES = Arrays.asList(
            2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97,
            101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199,
            211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293,
            307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397,
            401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499,
            503, 509, 521, 523, 541, 547, 557, 563, 569, 571, 577, 587, 593, 599,
            601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 659, 661, 673, 677, 683, 691,
            701, 709, 719, 727, 733, 739, 743, 751, 757, 761, 769, 773, 787, 797,
            809, 811, 821, 823, 827, 829, 839, 853, 857, 859, 863, 877, 881, 883, 887,
            907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977, 983, 991, 997,
            1009, 1013, 1019, 1021, 1031, 1033, 1039, 1049, 1051, 1061, 1063, 1069,
            1087, 1091, 1093, 1097, 1103, 1109, 1117, 1123, 1129, 1151
    );

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
        //final int result = hashCode % length;
        //return result < 0 ? result + length : result;
        //return Math.floorMod(hashCode, length);
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

        // Find next prime number
        // Little trick to force this number to be even so binary search is guaranteed to give us a negative index
        /*if (newCapacity < PRIMES.get(PRIMES.size() - 1)) {
            newCapacity = newCapacity & (~1);
            final int nextPrimeIndex = (~Collections.binarySearch(PRIMES, newCapacity));
            newCapacity = PRIMES.get(nextPrimeIndex);
        } else {
            newCapacity |= 1;
        }*/

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
