package com.dat3m.dartagnan.solver.onlineCaatTest.caat.misc;

import java.util.*;
import java.util.function.IntConsumer;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public class DenseIntegerSet implements Set<Integer> {

    private boolean[] elements = new boolean[0];
    int size = 0;

    public DenseIntegerSet() {
        this(20);
    }

    public DenseIntegerSet(int capacity) {
        ensureCapacity(capacity);
    }

    public void ensureCapacity(int capacity) {
        if (capacity > elements.length) {
            elements = Arrays.copyOf(elements, capacity);
        }
    }

    public int size() {
        return size;
    }
    public boolean isEmpty() {
        return size == 0;
    }

    @Override
    public boolean contains(Object o) {
        return o instanceof Integer && contains((int) o);
    }

    public boolean contains(int e) {
        return e < elements.length && elements[e];
    }

    @Override
    public Iterator<Integer> iterator() {
        return intIterator();
    }
    public PrimitiveIterator.OfInt intIterator() { return new SetIterator(elements, size); }

    @Override
    public Stream<Integer> stream() { return intStream().boxed(); }
    public IntStream intStream() { return IntStream.range(0, elements.length).filter(i -> elements[i]); }

    @Override
    public Object[] toArray() { return stream().toArray(); }

    @Override
    @SuppressWarnings("unchecked")
    public <T> T[] toArray(T[] a) { return (T[])stream().toArray(Object[]::new); }

    public boolean add(int ele) {
        boolean contains = contains(ele);
        if (!contains) {
            elements[ele] = true;
            size++;
        }
        return contains;
    }

    @Override
    public boolean add(Integer ele) {
        return add(ele.intValue());
    }

    public boolean remove(int ele) {
        boolean contains = contains(ele);
        if (contains) {
            elements[ele] = false;
            size--;
        }
        return contains;
    }

    @Override
    public boolean remove(Object o) {
        return o instanceof Integer && remove((int) o);
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
    public boolean addAll(Collection<? extends Integer> c) {
        boolean changed = false;
        for (Integer e : c) {
            changed |= add(e);
        }
        return changed;
    }

    @Override
    public boolean retainAll(Collection<?> c) {
        boolean changed = false;
        for (int i = 0; i < elements.length; i++) {
            if (elements[i] && !c.contains(i)) {
                elements[i] = false;
                size--;
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
        if (size > 0) {
            Arrays.fill(elements, false);
            size = 0;
        }
    }



    private static class SetIterator implements PrimitiveIterator.OfInt {
        final boolean[] elements;
        int index;
        int size;

        public SetIterator(boolean[] elements, int size) {
            this.elements = elements;
            this.size = size;
            index = -1;
        }


        @Override
        public boolean hasNext() {
            return size > 0;
        }

        @Override
        public int nextInt() {
            while (!elements[++index]) { }
            size--;
            return index;
        }

        @Override
        public void forEachRemaining(IntConsumer action) {
            int size = this.size;
            final boolean[] elements = this.elements;
            int i = -1;
            while (size > 0) {
                if (elements[++i]) {
                    action.accept(i);
                    size--;
                }
            }
        }

    }
}
