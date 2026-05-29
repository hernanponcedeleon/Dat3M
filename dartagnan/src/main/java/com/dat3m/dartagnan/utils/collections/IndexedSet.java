package com.dat3m.dartagnan.utils.collections;

import com.google.common.collect.Iterators;

import java.util.*;
import java.util.function.Consumer;
import java.util.function.Predicate;

/// Compact subset of a collection using a bitvector.
public final class IndexedSet<E> extends AbstractSet<E> {
    // assert Arrays.stream(domain).allMatch(o -> o instanceof E)
    private final IndexedDomain<E> domain;
    private final Object[] elements;
    private final int[] index;
    private long[] member;
    // assert 0 <= loneMember && loneMember <= domain.length
    private int loneMember;

    public IndexedSet(IndexedSet<E> list) {
        this(list.domain, nullableCopy(list.member), list.loneMember);
    }

    public IndexedSet(IndexedDomain<E> elements) {
        this(elements, null, elements.elements.length);
    }

    private IndexedSet(IndexedDomain<E> d, long[] m, int l) {
        domain = d;
        elements = d.elements;
        index = d.index;
        member = m;
        loneMember = l;
    }

    /// Returns the domain associated with this subset.
    public IndexedDomain<E> domain() {
        return domain;
    }

    /// Returns a life view on this set.
    public Set<E> unmodifiableView() {
        return new Immutable<>(this);
    }

    /// Returns `true` if the element at `index` was contained in this set.
    public boolean exchange(int index, boolean value) {
        assert 0 <= index && index < elements.length;
        if (member == null) {
            if (loneMember == index) {
                loneMember = value ? loneMember : elements.length;
                return true;
            }
            if (value && loneMember == elements.length) {
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
        //shrinkIfPossible(); // This would be too costly.
        return change != value;
    }

    public Iterator<Integer> indexIterator() {
        if (member == null) {
            return (loneMember == elements.length ? List.<Integer>of() : List.of(loneMember)).iterator();
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
        return member == null ? loneMember == elements.length ? 0 : 1 : bitCount(member);
    }

    @Override
    public boolean contains(Object o) {
        final int i = IndexedDomain.indexOf(elements, index, o);
        return i != -1 && test(member, loneMember, i);
    }

    @Override
    public boolean containsAll(Collection<?> other) {
        if (unwrap(other) instanceof IndexedSet<?> o && domain == o.domain) {
            if (o.member == null) {
                return o.loneMember == elements.length || test(member, loneMember, o.loneMember);
            }
            if (member != null) {
                for (int i = 0; i < member.length; i++) {
                    if (0L != (~member[i] & o.member[i])) {
                        return false;
                    }
                }
                return true;
            }
        }
        return super.containsAll(other);
    }

    private static boolean test(long[] member, int loneMember, int index) {
        return member == null ? loneMember == index : (member[index / 64] & (1L << (index % 64))) != 0L;
    }

    @Override
    public Iterator<E> iterator() {
        return Iterators.transform(indexIterator(), i -> (E) elements[i]);
    }

    @Override
    public Spliterator<E> spliterator() {
        if (member == null) {
            return (loneMember == elements.length ? List.<E>of() : List.of((E) elements[loneMember])).spliterator();
        }
        return new Split(0, elements.length);
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
            action.accept((E) elements[from]);
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
        loneMember = elements.length;
    }

    @Override
    public boolean add(E element) {
        final int i = IndexedDomain.indexOf(elements, index, element);
        if (i == -1) {
            throw new ObjectOutOfDomainException(element);
        }
        return !exchange(i, true);
    }

    @Override
    public boolean remove(Object element) {
        final int i = IndexedDomain.indexOf(elements, index, element);
        return i != -1 && exchange(i, false);
    }

    @Override
    public boolean addAll(Collection<? extends E> other) {
        if (other.isEmpty()) {
            return false;
        }
        final var otherSet = unwrap(other) instanceof IndexedSet<?> o && domain == o.domain ? o : null;
        if (otherSet != null && otherSet.member == null) {
            return otherSet.loneMember != -1 && exchange(otherSet.loneMember, true);
        }
        final var add = otherSet != null ? otherSet.member : newBits(elements.length);
        for (Object element : otherSet != null ? Set.of() : other) {
            final int i = IndexedDomain.indexOf(elements, index, element);
            if (i == -1) {
                throw new ObjectOutOfDomainException(element);
            }
            add[i / 64] |= 1L << (i % 64);
        }
        if (member == null) {
            final boolean otherMissesLoneMember = loneMember != elements.length
                    && (add[loneMember / 64] & (1L << (loneMember % 64))) == 0L;
            final int size = bitCount(add) + (otherMissesLoneMember ? 1 : 0);
            if (size == 0 || size == 1 && loneMember != elements.length) {
                return false;
            }
            if (size == 1) {
                final int newLoneMember = lowestBit(add);
                assert newLoneMember < elements.length;
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
            final boolean changed = loneMember != elements.length && other.contains(elements[loneMember]);
            loneMember = changed ? elements.length : loneMember;
            return changed;
        }
        if (unwrap(other) instanceof IndexedSet<?> o && o.member != null && domain == o.domain) {
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
            final boolean changed = loneMember != elements.length && !other.contains(elements[loneMember]);
            loneMember = changed ? elements.length : loneMember;
            return changed;
        }
        if (unwrap(other) instanceof IndexedSet<?> o && o.member != null && domain == o.domain) {
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
            final boolean changed = loneMember != elements.length && filter.test((E) elements[loneMember]);
            loneMember = changed ? elements.length : loneMember;
            return changed;
        }
        boolean changed = false;
        for (int blockindex = 0; blockindex < member.length; blockindex++) {
            long cache = member[blockindex];
            if (cache != 0L) {
                long changes = 0L;
                final long finalMask = blockindex != member.length - 1 ? 0L : 2L << ((63 + elements.length) % 64);
                int i = blockindex * 64;
                for (long mask = 1L; mask != finalMask; mask <<= 1) {
                    if ((cache & mask) != 0L && filter.test((E) elements[i])) {
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
            member = newBits(elements.length);
            if (loneMember != elements.length) {
                member[loneMember / 64] |= 1L << (loneMember % 64);
            }
            loneMember = elements.length;
        }
    }

    private void shrinkIfPossible() {
        if (member != null && bitCount(member) <= 1) {
            loneMember = Integer.min(lowestBit(member), elements.length);
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

    private static long[] nullableCopy(long[] array) {
        return array == null ? null : Arrays.copyOf(array, array.length);
    }

    private static <E> Collection<E> unwrap(Collection<E> collection) {
        return collection instanceof Immutable<E> i ? i.wrapped : collection;
    }

    private static final class Immutable<E> extends AbstractSet<E> {
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
        private ObjectOutOfDomainException(Object element) { super(element.toString()); }
    }
}
