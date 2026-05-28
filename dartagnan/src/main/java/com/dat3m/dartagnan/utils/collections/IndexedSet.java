package com.dat3m.dartagnan.utils.collections;

import com.google.common.collect.Iterators;

import java.util.*;
import java.util.function.Consumer;
import java.util.function.Predicate;

/// Compact subset of a collection using a bitvector.
public final class IndexedSet<E> extends AbstractSet<E> {
    // assert Arrays.stream(domain).allMatch(o -> o instanceof E)
    private final Object[] domain;
    private final int[] index;
    private long[] member;
    // assert 0 <= loneMember && loneMember <= domain.length
    private int loneMember;

    public IndexedSet(IndexedSet<E> list) {
        this(list.domain, list.index, list.member == null ? null : Arrays.copyOf(list.member, list.member.length), list.loneMember);
    }

    public IndexedSet(Domain<E> domain) {
        this(domain.domain, domain.index, null, domain.domain.length);
    }

    private IndexedSet(Object[] d, int[] i, long[] m, int l) {
        domain = d;
        index = i;
        member = m;
        loneMember = l;
    }

    public Domain<E> domain() {
        return new Domain<>(domain, index);
    }

    public static final class Domain<E> {
        private final Object[] domain;
        private final int[] index;
        public Domain(Collection<E> elements) {
            domain = elements.toArray();
            index = newIndex(domain);
        }
        private Domain(Object[] d, int[] i) {
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
            return IndexedSet.indexOf(domain, index, key);
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
        if (member == null) {
            if (loneMember == index) {
                loneMember = value ? loneMember : domain.length;
                return true;
            }
            if (value && loneMember == domain.length) {
                loneMember = index;
                return false;
            }
            if (!value) {
                return false;
            }
        }
        ensureMemberArray();
        final long mask = 1L << (index % 64);
        final boolean change = value == ((member[index / 64] & mask) == 0L);
        member[index / 64] ^= change ? mask : 0L;
        shrinkIfPossible();
        return change != value;
    }

    public Iterator<Integer> indexIterator() {
        if (member == null) {
            return (loneMember == domain.length ? List.<Integer>of() : List.of(loneMember)).iterator();
        }
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
        return member == null ? loneMember == domain.length ? 0 : 1 : bitCount(member);
    }

    @Override
    public boolean contains(Object o) {
        final int i = indexOf(domain, index, o);
        return i != -1 && (member == null ? loneMember == i : (member[i / 64] & (1L << (i % 64))) != 0L);
    }

    @Override
    public Iterator<E> iterator() {
        return Iterators.transform(indexIterator(), i -> (E) domain[i]);
    }

    @Override
    public Spliterator<E> spliterator() {
        return member == null ? loneMember == domain.length ? List.<E>of().spliterator() : List.of((E) domain[loneMember]).spliterator() : new Split(0, domain.length);
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
        member = null;
        loneMember = domain.length;
    }

    @Override
    public boolean add(E element) {
        final int i = indexOf(domain, index, element);
        if (i == -1) {
            throw new ObjectOutOfDomainException();
        }
        return !exchange(i, true);
    }

    @Override
    public boolean remove(Object element) {
        final int i = indexOf(domain, index, element);
        return i != -1 && exchange(i, false);
    }

    @Override
    public boolean addAll(Collection<? extends E> other) {
        if (other.isEmpty()) {
            return false;
        }
        final var otherSet = unwrap(other) instanceof IndexedSet<?> o ? o : null;
        final var add = otherSet != null && otherSet.member != null && index == otherSet.index ? otherSet.member : newBits(domain.length);
        for (Object element : otherSet != null && add == otherSet.member ? Set.of() : other) {
            final int i = indexOf(domain, index, element);
            if (i == -1) {
                throw new ObjectOutOfDomainException();
            }
            add[i / 64] |= 1L << (i % 64);
        }
        if (member == null) {
            final boolean otherMissesLoneMember = loneMember != domain.length
                    && (add[loneMember / 64] & (1L << (loneMember % 64))) == 0L;
            final int size = bitCount(add) + (otherMissesLoneMember ? 1 : 0);
            if (size == 0 || size == 1 && loneMember != domain.length) {
                return false;
            }
            if (size == 1) {
                final int newLoneMember = lowestBit(add);
                assert newLoneMember < domain.length;
                loneMember = newLoneMember;
                return true;
            }
        }
        ensureMemberArray();
        boolean changed = false;
        for (int pageindex = 0; pageindex < member.length; pageindex++) {
            final long changes = ~member[pageindex] & add[pageindex];
            member[pageindex] ^= changes;
            changed |= changes != 0L;
        }
        shrinkIfPossible();
        return changed;
    }

    @Override
    public boolean removeAll(Collection<?> other) {
        if (member == null) {
            final boolean changed = loneMember != domain.length && other.contains(domain[loneMember]);
            loneMember = changed ? domain.length : loneMember;
            return changed;
        }
        if (unwrap(other) instanceof IndexedSet<?> o && o.member != null && index == o.index) {
            assert member.length == o.member.length;
            boolean changed = false;
            for (int pageindex = 0; pageindex < member.length; pageindex++) {
                final long changes = member[pageindex] & o.member[pageindex];
                member[pageindex] ^= changes;
                changed |= changes != 0L;
            }
            shrinkIfPossible();
            return changed;
        }
        return removeIf(other::contains);
    }

    @Override
    public boolean retainAll(Collection<?> other) {
        if (member == null) {
            final boolean changed = loneMember != domain.length && !other.contains(domain[loneMember]);
            loneMember = changed ? domain.length : loneMember;
            return changed;
        }
        if (unwrap(other) instanceof IndexedSet<?> o && o.member != null && index == o.index) {
            assert member.length == o.member.length;
            boolean changed = false;
            for (int pageindex = 0; pageindex < member.length; pageindex++) {
                final long changes = member[pageindex] & ~o.member[pageindex];
                member[pageindex] ^= changes;
                changed |= changes != 0L;
            }
            shrinkIfPossible();
            return changed;
        }
        return removeIf(Predicate.not(other::contains));
    }

    @Override
    public boolean removeIf(Predicate<? super E> filter) {
        if (member == null) {
            final boolean changed = loneMember != domain.length && filter.test((E) domain[loneMember]);
            loneMember = changed ? domain.length : loneMember;
            return changed;
        }
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
        shrinkIfPossible();
        return changed;
    }

    private void ensureMemberArray() {
        if (member == null) {
            member = newBits(domain.length);
            if (loneMember != domain.length) {
                member[loneMember / 64] |= 1L << (loneMember % 64);
            }
            loneMember = domain.length;
        }
    }

    private void shrinkIfPossible() {
        if (member != null && bitCount(member) <= 1) {
            loneMember = Integer.min(lowestBit(member), domain.length);
            member = null;
        }
    }

    private static long[] newBits(int length) {
        return new long[1 + (length - 1) / 64];
    }

    private static int lowestBit(long[] bits) {
        int lowestBit = 0;
        for (long block : bits) {
            if (block == 0L) {
                lowestBit += 64;
            } else {
                lowestBit += Long.numberOfTrailingZeros(block);
                break;
            }
        }
        return lowestBit;
    }

    private static int bitCount(long[] bits) {
        int count = 0;
        for (long block : bits) {
            count += Long.bitCount(block);
        }
        return count;
    }

    private static final float HASH_TABLE_FILL_FACTOR = 1.5f;

    private static int[] newIndex(Object[] domain) {
        final int[] index = new int[(int) (domain.length * HASH_TABLE_FILL_FACTOR) << 1];
        Arrays.fill(index, -1);
        // Try to insert all elements at their bucket's front.
        for (int i = 0; i < domain.length; i++) {
            final int hash = domain[i].hashCode();
            int h = hash % (index.length >> 1) << 1;
            if (index[h] == -1) {
                index[h] = i;
                index[h | 1] = hash;
            }
        }
        // Insert all elements with birthday problem.
        for (int i = 0; i < domain.length; i++) {
            final int hash = domain[i].hashCode();
            int h = (hash % (index.length >> 1)) << 1;
            if (index[h] != i) {
                do {
                    if (index[h | 1] == hash && domain[i].equals(domain[index[h]])) {
                        throw new IllegalArgumentException("Trying to create an index for a non-set collection.");
                    }
                    h += 2;
                    h = h < index.length ? h : 0;
                } while (index[h] != -1);
                index[h] = i;
                index[h | 1] = hash;
            }
        }
        return index;
    }

    private static int indexOf(Object[] domain, int[] index, Object key) {
        final int hash = key.hashCode();
        int h = (hash % (index.length >> 1)) << 1;
        int fast;
        while ((fast = index[h]) != -1 && (index[h | 1] != hash || !domain[fast].equals(key))) {
            h += 2;
            h = h < index.length ? h : 0;
        }
        return fast;
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
