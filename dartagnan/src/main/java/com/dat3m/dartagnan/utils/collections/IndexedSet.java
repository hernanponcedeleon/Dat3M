package com.dat3m.dartagnan.utils.collections;

import com.google.common.collect.Iterators;

import java.util.*;
import java.util.function.Consumer;
import java.util.function.Predicate;

/// Compact subset of a collection using a bitvector.
public final class IndexedSet<E> extends AbstractSet<E> {
    private final Object[] domain;
    private final Map<Object, Integer> index;
    private final long[] member;

    public IndexedSet(IndexedSet<E> list) {
        this(list.domain, list.index, Arrays.copyOf(list.member, list.member.length));
    }

    public IndexedSet(Domain<E> domain) {
        this(domain.domain, domain.index, new long[1 + (domain.domain.length - 1) / 64]);
    }

    private IndexedSet(Object[] d, Map<Object, Integer> i, long[] m) {
        domain = d;
        index = i;
        member = m;
    }

    public Domain<E> domain() {
        return new Domain<>(domain, index);
    }

    public static final class Domain<E> {
        private final Object[] domain;
        private final Map<Object, Integer> index;
        public Domain(Collection<E> elements) {
            domain = elements.toArray();
            index = newIndex(domain);
        }
        private Domain(Object[] d, Map<Object, Integer> i) {
            domain = d;
            index = i;
        }
        public Iterator<E> iterator() {
            return new Iterator<>() {
                private int i = 0;
                @Override
                public boolean hasNext() {
                    return i < domain.length;
                }
                @Override
                public E next() {
                    return (E) domain[i++];
                }
            };
        }
        public E element(int index) {
            return (E) domain[index];
        }
        public int size() {
            return domain.length;
        }
        public int indexOf(Object key) {
            return index.getOrDefault(key, domain.length);
        }
        @Override
        public int hashCode() {
            return domain.hashCode();
        }
        @Override
        public boolean equals(Object other) {
            return other instanceof Domain<?> o && domain == o.domain;
        }
    }

    public IndexedSet<E> and(Collection<E> other) {
        final var and = new IndexedSet<>(this);
        and.retainAll(other);
        return and;
    }

    public IndexedSet<E> or(Collection<E> other) {
        final var or = new IndexedSet<>(this);
        or.addAll(other);
        return or;
    }

    /// returns `true` if the element at `index` was contained in this set.
    public boolean exchange(int index, boolean value) {
        assert 0 <= index && index < domain.length;
        final long mask = 1L << (index % 64);
        final boolean change = value == ((member[index / 64] & mask) == 0L);
        member[index / 64] ^= change ? mask : 0L;
        return change != value;
    }

    public Iterator<Integer> indexIterator() {
        return new Iterator<>() {
            private int pageindex;
            private int index;
            private long cache;
            {
                cache = member[0];
                advance();
            }
            @Override
            public boolean hasNext() {
                return pageindex < member.length;
            }
            @Override
            public Integer next() {
                final int next = pageindex * 64 + index;
                index++;
                advance();
                return next;
            }
            private void advance() {
                while (cache == 0L && ++pageindex < member.length) {
                    cache = member[pageindex];
                }
                index = Long.numberOfTrailingZeros(cache);
                cache &= ~(1L << index);
            }
        };
    }

    @Override
    public int size() {
        int size = 0;
        for (long page : member) {
            size += Long.bitCount(page);
        }
        return size;
    }

    @Override
    public boolean contains(Object o) {
        final Integer i = index.get(o);
        return i != null && (member[i / 64] & (1L << (i % 64))) != 0L;
    }

    private static boolean test(long block, int index) {
        return (block & (1L << index)) != 0L;
    }

    @Override
    public Iterator<E> iterator() {
        return Iterators.transform(indexIterator(), i -> (E) domain[i]);
    }

    @Override
    public Spliterator<E> spliterator() {
        return new Split(0, domain.length);
    }

    private final class Split implements Spliterator<E> {
        private int from;
        private int to;
        private Split(int a, int b) { from = a; to = b; }
        @Override
        public boolean tryAdvance(Consumer<? super E> action) {
            while (from < to && (member[from / 64] & (1L << (from % 64))) == 0L) {
                from++;
            }
            if (from >= to) {
                return false;
            }
            action.accept((E) domain[from]);
            from++;
            return true;
        }
        @Override
        public Spliterator<E> trySplit() {
            final int end = to;
            return new Split(to = (from + to) / 2, end);
        }
        @Override
        public long estimateSize() {
            return to - from;
        }
        @Override
        public int characteristics() {
            return DISTINCT | NONNULL | ORDERED;
        }
    }

    @Override
    public void clear() {
        Arrays.fill(member, 0L);
    }

    @Override
    public boolean add(E element) {
        final Integer i = index.get(element);
        if (i == null) {
            throw new ObjectOutOfDomainException();
        }
        final long value = member[i / 64];
        final long mask = 1L << (i % 64);
        member[i / 64] |= mask;
        return (value & mask) == 0L;
    }

    @Override
    public boolean remove(Object element) {
        final Integer i = index.get(element);
        if (i == null) {
            return false;
        }
        final long value = member[i / 64];
        final long mask = 1L << (i % 64);
        member[i / 64] &= ~mask;
        return (value & mask) != 0L;
    }

    @Override
    public boolean addAll(Collection<? extends E> other) {
        if (other.isEmpty()) {
            return false;
        }
        final var otherSet = unwrap(other) instanceof IndexedSet<?> o ? o : null;
        final var add = otherSet != null && index == otherSet.index ? otherSet.member : new long[member.length];
        for (Object element : otherSet != null ? Set.of() : other) {
            final Integer i = index.get(element);
            if (i == null) {
                throw new ObjectOutOfDomainException();
            }
            add[i / 64] |= 1L << (i % 64);
        }
        boolean changed = false;
        for (int pageindex = 0; pageindex < member.length; pageindex++) {
            final long changes = ~member[pageindex] & add[pageindex];
            member[pageindex] ^= changes;
            changed |= changes != 0L;
        }
        return changed;
    }

    @Override
    public boolean removeAll(Collection<?> other) {
        if (unwrap(other) instanceof IndexedSet<?> o && index == o.index) {
            assert member.length == o.member.length;
            boolean changed = false;
            for (int pageindex = 0; pageindex < member.length; pageindex++) {
                final long changes = member[pageindex] & o.member[pageindex];
                member[pageindex] ^= changes;
                changed |= changes != 0L;
            }
            return changed;
        }
        return removeIf(other::contains);
    }

    @Override
    public boolean retainAll(Collection<?> other) {
        if (unwrap(other) instanceof IndexedSet<?> o && index == o.index) {
            assert member.length == o.member.length;
            boolean changed = false;
            for (int pageindex = 0; pageindex < member.length; pageindex++) {
                final long changes = member[pageindex] & ~o.member[pageindex];
                member[pageindex] ^= changes;
                changed |= changes != 0L;
            }
            return changed;
        }
        return removeIf(Predicate.not(other::contains));
    }

    @Override
    public boolean removeIf(Predicate<? super E> filter) {
        boolean changed = false;
        for (int blockindex = 0; blockindex < member.length; blockindex++) {
            long cache = member[blockindex];
            if (cache != 0L) {
                long changes = 0L;
                final long finalMask = blockindex != member.length - 1 ? 0L : 2L << ((63 + domain.length) % 64);
                int i = blockindex * 64;
                for (long mask = 1L; mask != finalMask; mask <<= 1) {
                    if ((cache & mask) != 0L && filter.test((E) domain[i])) {
                        changes |= mask;
                    }
                    i++;
                }
                member[blockindex] ^= changes;
                changed |= changes != 0L;
            }
        }
        return changed;
    }

    private static Map<Object, Integer> newIndex(Object[] domain) {
        final var map = new HashMap<Object, Integer>();
        for (Object element : domain) {
            final Object old = map.put(element, map.size());
            assert old == null : "Trying to create an index for a non-set collection.";
        }
        return Map.copyOf(map);
    }

    private static <E> Collection<E> unwrap(Collection<E> collection) {
        return collection instanceof Immutable<E> i ? i.wrapped : collection;
    }

    public static final class Immutable<E> extends AbstractSet<E> {
        private final IndexedSet<E> wrapped;
        public Immutable(IndexedSet<E> w) { wrapped = w; }
        @Override
        public int size() { return wrapped.size(); }
        @Override
        public Iterator<E> iterator() { return wrapped.iterator(); }
        @Override
        public Spliterator<E> spliterator() { return wrapped.spliterator(); }
        @Override
        public boolean contains(Object key) { return wrapped.contains(key); }
        @Override
        public boolean isEmpty() { return wrapped.isEmpty(); }
    }

    public static final class ObjectOutOfDomainException extends IllegalArgumentException {
        private ObjectOutOfDomainException() {}
    }
}
