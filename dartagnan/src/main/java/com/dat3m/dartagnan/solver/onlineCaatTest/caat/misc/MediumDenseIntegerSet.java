package com.dat3m.dartagnan.solver.onlineCaatTest.caat.misc;

import java.util.*;
import java.util.function.IntConsumer;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public class MediumDenseIntegerSet implements Set<Integer> {

    private short[] elements = new short[0];
    int size = 0;
    short level = 1;

    public MediumDenseIntegerSet() {
        this(20);
    }

    public MediumDenseIntegerSet(int capacity) {
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

    public void increaseLevel() {
        level++;
    }

    public void resetToLevel(short newLevel) {
        for (int i = 0; i < elements.length; i++) {
            if (elements[i] > newLevel + 1) {
                elements[i] = 0;
            }
        }
        level = (short)(newLevel + 1);
    }

    @Override
    public boolean contains(Object o) {
        return o instanceof Integer && contains((int) o);
    }

    public boolean contains(int e) {
        return e < elements.length && elements[e] > 0;
    }

    @Override
    public Iterator<Integer> iterator() {
        return intIterator();
    }
    public PrimitiveIterator.OfInt intIterator() { return new SetIterator(elements, size); }

    @Override
    public Stream<Integer> stream() { return intStream().boxed(); }
    public IntStream intStream() { return IntStream.range(0, elements.length).filter(i -> elements[i] > 0); }

    @Override
    public Object[] toArray() { return stream().toArray(); }

    @Override
    @SuppressWarnings("unchecked")
    public <T> T[] toArray(T[] a) { return (T[])stream().toArray(Object[]::new); }

    public boolean add(int ele) {
        boolean contains = contains(ele);
        if (!contains) {
            elements[ele] = level;
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
            elements[ele] = 0;
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
            if (elements[i] > 0 && !c.contains(i)) {
                elements[i] = 0;
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
            Arrays.fill(elements, (short)0);
            size = 0;
        }
    }



    private static class SetIterator implements PrimitiveIterator.OfInt {
        final short[] elements;
        int index;
        int size;

        public SetIterator(short[] elements, int size) {
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
            while (elements[++index] <= 0) { }
            this.size--;
            return index;
        }

        @Override
        public void forEachRemaining(IntConsumer action) {
            int size = this.size;
            final short[] elements = this.elements;
            int i = -1;
            while (size > 0) {
                if (elements[++i] > 0) {
                    action.accept(i);
                    size--;
                }
            }
        }

    }
}
