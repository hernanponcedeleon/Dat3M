package com.dat3m.dartagnan.utils.collections;

import java.util.*;

public class SetUtil {

    private SetUtil() { }

    public static <T> Set<T> fakeSet() {
        return new FakeSet<>();
    }

    public static <T> Set<T> identityHashSet(int capacity) {
        return Collections.newSetFromMap(new IdentityHashMap<>(capacity));
    }

    /**
     * @param explicit Modifiable set for additional elements.
     * @param implicit Immutable ground content of the resulting set.
     * @return Partially-modifiable set
     */
    public static <T> Set<T> groundedSet(Set<T> explicit, Set<? extends T> implicit) {
        return new GroundedSet<>(explicit, implicit);
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

    // Manages a distinct union of a modifiable and an immutable set.
    private static final class GroundedSet<T> extends AbstractSet<T> {

        private final Set<T> explicitSet;
        private final Set<? extends T> implicitSet;

        private GroundedSet(Set<T> explicit, Set<? extends T> implicit) {
            explicitSet = explicit;
            implicitSet = implicit;
        }

        @Override
        public int size() {
            return explicitSet.size() + implicitSet.size();
        }

        @Override
        public Iterator<T> iterator() {
            final Iterator<T> explicitIterator = explicitSet.iterator();
            final Iterator<? extends T> implicitIterator = implicitSet.iterator();
            return new Iterator<>() {

                //Distinguishes the last element of explicitIterator
                private boolean progressed;

                @Override
                public boolean hasNext() {
                    return explicitIterator.hasNext() || implicitIterator.hasNext();
                }

                @Override
                public T next() {
                    progressed = progressed || !explicitIterator.hasNext();
                    return (progressed ? implicitIterator : explicitIterator).next();
                }

                @Override
                public void remove() {
                    if (progressed) {
                        throw new UnsupportedOperationException();
                    }
                    explicitIterator.remove();
                }
            };
        }

        @Override
        public boolean add(T t) {
            return !implicitSet.contains(t) && explicitSet.add(t);
        }

        @Override
        public boolean addAll(Collection<? extends T> c) {
            //return explicitSet.addAll(Sets.difference(c, implicitSet));
            boolean change = false;
            for (final T element : c) {
                change |= add(element);
            }
            return change;
        }

        @Override
        public boolean removeAll(Collection<?> c) {
            if (!Collections.disjoint(c, implicitSet)) {
                throw new UnsupportedOperationException();
            }
            return explicitSet.removeAll(c);
        }

        @Override
        public boolean remove(Object o) {
            if (implicitSet.contains(o)) {
                throw new UnsupportedOperationException();
            }
            return explicitSet.remove(o);
        }

        @Override
        public boolean retainAll(Collection<?> c) {
            if (c.containsAll(implicitSet)) {
                throw new UnsupportedOperationException();
            }
            return explicitSet.retainAll(c);
        }

        @Override
        public void clear() {
            if (!implicitSet.isEmpty()) {
                throw new UnsupportedOperationException();
            }
            explicitSet.clear();
        }
    }

}
