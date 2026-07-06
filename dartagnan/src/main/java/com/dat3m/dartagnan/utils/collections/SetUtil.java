package com.dat3m.dartagnan.utils.collections;

import java.util.*;
import java.util.function.Predicate;

public class SetUtil {

    private SetUtil() { }

    public static <T> Set<T> fakeSet() {
        return new FakeSet<>();
    }

    public static <T> Set<T> identityHashSet(int capacity) {
        return Collections.newSetFromMap(new IdentityHashMap<>(capacity));
    }

    public static boolean disjoint(Collection<?> left, Collection<?> right) {
        if (left instanceof IndexedSet<?> l && right instanceof IndexedSet<?> r) {
            return l.disjoint(r);
        }
        return Collections.disjoint(left, right);
    }

    public static <T> Set<T> union(Collection<T> left, Collection<T> right) {
        if (left instanceof IndexedSet<T> l && right instanceof IndexedSet<T> r
                && l.domain().isCompatibleWith(r.domain())) {
            final boolean useLeft = r.domain().size() < l.domain().size();
            final Set<T> union = new IndexedSet<>(useLeft ? l : r);
            union.addAll(useLeft ? r : l);
            return union;
        }
        final boolean useLeft = right.size() < left.size();
        final Set<T> union = new HashSet<>(useLeft ? left : right);
        union.addAll(useLeft ? right : left);
        return union;
    }

    public static <T> Set<T> intersection(Collection<T> left, Collection<T> right) {
        if (left instanceof IndexedSet<T> || right instanceof IndexedSet<T>) {
            return IndexedSet.intersection(left, right);
        }
        final Set<T> intersection = new HashSet<>();
        final Collection<T> filter = left.size() < right.size() ? right : left;
        final Collection<T> iterator = filter == right ? left : right;
        for (T element : iterator) {
            if (filter.contains(element)) {
                intersection.add(element);
            }
        }
        return intersection;
    }

    public static <T> Set<T> difference(Collection<T> minuend, Collection<?> subtrahend) {
        if (minuend instanceof IndexedSet<T> m) {
            final Set<T> difference = new IndexedSet<>(m);
            difference.removeAll(subtrahend);
            return difference;
        }
        final Set<T> difference = new HashSet<>();
        for (T element : minuend) {
            if (!subtrahend.contains(element)) {
                difference.add(element);
            }
        }
        return difference;
    }

    public static <T> Set<T> filter(Collection<T> base, Predicate<? super T> keepInSet) {
        if (base instanceof IndexedSet<T> b) {
            final Set<T> filter = new IndexedSet<>(b);
            filter.removeIf(keepInSet.negate());
            return filter;
        }
        final Set<T> filter = new HashSet<>();
        for (T element : base) {
            if (keepInSet.test(element)) {
                filter.add(element);
            }
        }
        return filter;
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
