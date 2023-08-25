package com.dat3m.dartagnan.utils.collections;

import com.google.common.collect.Sets;

import java.util.*;

public class SetUtil {

    private SetUtil() { }

    public static <T> Set<T> fakeSet() {
        return new FakeSet<>();
    }

    public static <T> Set<T> identityHashSet(int capacity) {
        return Collections.newSetFromMap(new IdentityHashMap<>(capacity));
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
    public static final class GroundedSet<T> extends AbstractSet<T> {

        private final Set<? extends T> ground;
        private final Set<T> added;
        private final Set<Object> removed;

        public GroundedSet(Set<? extends T> groundSet) {
            this(groundSet, new HashSet<>());
        }

        public GroundedSet(Set<? extends T> groundSet, Set<T> addedSet) {
            this(groundSet, addedSet, new HashSet<>());
        }

        public GroundedSet(Set<? extends T> groundSet, Set<T> addedSet, Set<Object> removedSet) {
            ground = groundSet;
            added = addedSet;
            removed = removedSet;
        }

        public Set<? extends T> getGroundSet() {
            return Collections.unmodifiableSet(ground);
        }

        public Set<T> getAddedSet() {
            return Collections.unmodifiableSet(added);
        }

        public Set<Object> getRemovedSet() {
            return Collections.unmodifiableSet(removed);
        }

        @Override
        public int size() {
            return added.size() + ground.size() - removed.size();
        }

        @Override
        public Iterator<T> iterator() {
            final Iterator<T> explicitIterator = added.iterator();
            final Iterator<? extends T> implicitIterator = Sets.difference(ground, removed).iterator();
            return new Iterator<>() {

                //Removable by inserting into the set of removed elements
                private T currentElement;

                @Override
                public boolean hasNext() {
                    return explicitIterator.hasNext() || implicitIterator.hasNext();
                }

                @Override
                public T next() {
                    if (explicitIterator.hasNext()) {
                        return explicitIterator.next();
                    }
                    return currentElement = implicitIterator.next();
                }

                @Override
                public void remove() {
                    if (currentElement != null) {
                        removed.add(currentElement);
                    }
                    explicitIterator.remove();
                }
            };
        }

        @Override
        public boolean add(T t) {
            return !ground.contains(t) && added.add(t);
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
            boolean change = added.removeAll(c);
            for (final Object element : c) {
                change |= ground.contains(element) && removed.add(element);
            }
            return change;
        }

        @Override
        public boolean remove(Object o) {
            return ground.contains(o) ? removed.add(o) : added.remove(o);
        }

        @Override
        public boolean retainAll(Collection<?> c) {
            boolean change = added.retainAll(c);
            for (final T element : ground) {
                change |= !c.contains(element) && removed.add(element);
            }
            return change;
        }

        @Override
        public void clear() {
            added.clear();
            removed.addAll(ground);
        }
    }

}
