package com.dat3m.dartagnan.wmm.graphRefinement.util;

import java.util.*;

public class SetUtil {

    private SetUtil() { }

    public static <T> Set<T> union(Set<T> a, Set<T> b) {
        return new SetUnion<>(a, b);
    }

    public static <T> Set<T> fakeSet() { return new FakeSet<>();}



    /*
    SetUnion is a virtual union of sets that reflects any changes to the underlying sets dynamically,
     */
    private static class SetUnion<T> extends AbstractSet<T> {
        private final Set<T> first;
        private final Set<T> second;

        public SetUnion(Set<T> first, Set<T> second) {
            if (first == null)
                first = Collections.emptySet();
            if (second == null)
                second = Collections.emptySet();
            this.first = first;
            this.second = second;
        }

        @Override
        public boolean isEmpty() {
            return first.isEmpty() && second.isEmpty();
        }

        @Override
        public boolean contains(Object o) {
            return first.contains(o) || second.contains(o);
        }

        @Override
        public boolean containsAll(Collection<?> c) {
            for (Object obj : c) {
                if (!contains(obj))
                    return false;
            }
            return true;
        }

        @Override
        public Iterator<T> iterator() {
            return new UnionIterator();
        }

        @Override
        public int size() {
            int size = first.size();
            for (T e : second) {
                if (!first.contains(e))
                    size++;
            }
            return size;
        }



        private class UnionIterator implements Iterator<T> {
            Iterator<T> firstIt = first.iterator();
            Iterator<T> secondIt = second.iterator();
            T next;

            @Override
            public boolean hasNext() {
                boolean hasNext = firstIt.hasNext();
                if (hasNext) {
                    next = firstIt.next();
                } else {
                    while ((hasNext = secondIt.hasNext()) && !first.contains(next = secondIt.next())) ;
                }
                return hasNext;
            }

            @Override
            public T next() {
                return next;
            }
        }
    }


    /*
    Like an empty set, but does silently ignore all attempts to modify it without throwing exceptions.
     */
    private static class FakeSet<T> implements Set<T> {

        @Override
        public int size() {
            return 0;
        }

        @Override
        public boolean isEmpty() {
            return true;
        }

        @Override
        public boolean contains(Object o) {
            return false;
        }

        @Override
        public Iterator<T> iterator() {
            return Collections.emptyIterator();
        }

        @Override
        public Object[] toArray() {
            return new Object[0];
        }

        @Override
        public <T1> T1[] toArray(T1[] a) {
            return Collections.emptySet().toArray(a);
        }

        @Override
        public boolean add(T t) {
            return false;
        }

        @Override
        public boolean remove(Object o) {
            return false;
        }

        @Override
        public boolean containsAll(Collection<?> c) {
            return c.isEmpty();
        }

        @Override
        public boolean addAll(Collection<? extends T> c) {
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
}
