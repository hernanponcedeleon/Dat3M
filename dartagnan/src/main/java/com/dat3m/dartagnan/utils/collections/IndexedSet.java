package com.dat3m.dartagnan.utils.collections;

import java.util.*;
import java.util.function.Consumer;
import java.util.function.Predicate;

/// Compact subset of a collection using a bitvector.
public final class IndexedSet<E> extends AbstractSet<E> {
    // assert Arrays.stream(domain).allMatch(o -> o instanceof E)
    private final IndexedDomain<E> domain;
    private final Object[] elements;
    private final int[] index;
    private final boolean modifiable;
    private long[] member;
    // assert -1 <= loneMember && loneMember < domain.length
    private int loneMember;

    public IndexedSet(IndexedSet<E> list) {
        this(list.domain, nullableCopy(list.member), list.loneMember, true);
    }

    public IndexedSet(IndexedDomain<E> elements) {
        this(elements, null, -1, true);
    }

    private IndexedSet(IndexedDomain<E> d, long[] m, int l, boolean f) {
        domain = d;
        elements = d.elements;
        index = d.index;
        member = m;
        loneMember = l;
        modifiable = f;
    }

    /// Returns the domain associated with this subset.
    public IndexedDomain<E> domain() {
        return domain;
    }

    /// Returns a shallow copy of this set that rejects modifications.
    public IndexedSet<E> toUnmodifiableView() {
        return new IndexedSet<>(domain, member, loneMember, false);
    }

    /// Returns `true` if the element at `index` was contained in this set.
    public boolean exchange(int index, boolean value) {
        assert 0 <= index && index < elements.length;
        checkModifiable();
        if (member == null) {
            if (loneMember == index) {
                loneMember = value ? loneMember : -1;
                return true;
            }
            if (value && loneMember == -1) {
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

    /// Returns the domain indexes of the elements contained by this set, in ascending order.
    public int[] toIndexArray() {
        if (member == null) {
            return loneMember == -1 ? new int[0] : new int[]{loneMember};
        }
        final var buffer = new int[elements.length];
        int bufferpointer = 0;
        for (int pageindex = 0; pageindex < member.length; pageindex++) {
            long page = member[pageindex];
            while (page != 0L) {
                int next = Long.numberOfTrailingZeros(page);
                page &= ~(1L << next);
                buffer[bufferpointer++] = 64 * pageindex + next;
            }
        }
        final var array = new int[bufferpointer];
        System.arraycopy(buffer, 0, array, 0, bufferpointer);
        return array;
    }

    public boolean disjoint(IndexedSet<?> other) {
        if (!domain.isCompatible(other.domain)) {
            return Collections.disjoint(this, other);
        }
        if (member == null) {
            return loneMember == -1 || !test(other.elements.length, other.member, other.loneMember, loneMember);
        }
        if (other.member == null) {
            return other.loneMember == -1 || !test(elements.length, member, loneMember, other.loneMember);
        }
        int length = Integer.min(member.length, other.member.length);
        for (int pageindex = 0; pageindex < length; pageindex++) {
            if ((member[pageindex] & other.member[pageindex]) != 0L) {
                return false;
            }
        }
        return true;
    }

    @Override
    public int size() {
        return member == null ? loneMember == -1 ? 0 : 1 : bitCount(member);
    }

    @Override
    public boolean contains(Object o) {
        final int i = IndexedDomain.indexOf(elements, index, o);
        return i != -1 && test(elements.length, member, loneMember, i);
    }

    @Override
    public boolean containsAll(Collection<?> other) {
        if (other instanceof IndexedSet<?> o && domain.isCompatible(o.domain)) {
            if (o.member == null) {
                return o.loneMember == -1 || test(elements.length, member, loneMember, o.loneMember);
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

    private static boolean test(int size, long[] member, int loneMember, int index) {
        assert 0 <= index;
        if (size <= index) {
            return false;
        }
        return member == null ? loneMember == index : (member[index / 64] & (1L << (index % 64))) != 0L;
    }

    @Override
    public Iterator<E> iterator() {
        return new Iterator<>() {
            private final int[] indexArray = toIndexArray();
            private int progress;
            @Override
            public boolean hasNext() {
                return progress < indexArray.length;
            }
            @Override
            public E next() {
                return (E) elements[indexArray[progress++]];
            }
        };
    }

    @Override
    public Spliterator<E> spliterator() {
        if (member == null) {
            return (loneMember == -1 ? List.<E>of() : List.of((E) elements[loneMember])).spliterator();
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
        checkModifiable();
        member = null;
        loneMember = -1;
    }

    @Override
    public boolean add(E element) {
        final int i = IndexedDomain.indexOf(elements, index, element);
        checkObjectInDomain(i != -1, element, -1);
        return !exchange(i, true);
    }

    @Override
    public boolean remove(Object element) {
        final int i = IndexedDomain.indexOf(elements, index, element);
        return i != -1 && exchange(i, false);
    }

    @Override
    public boolean addAll(Collection<? extends E> other) {
        checkModifiable();
        final var otherSet = other instanceof IndexedSet<?> o && domain.isCompatible(o.domain) ? o : null;
        if (otherSet != null && otherSet.member == null) {
            checkObjectInDomain(otherSet.loneMember < elements.length, otherSet.elements, otherSet.loneMember);
            return otherSet.loneMember != -1 && exchange(otherSet.loneMember, true);
        }
        final var add = otherSet != null ? otherSet.member : newBits(elements.length);
        for (Object element : otherSet != null ? Set.of() : other) {
            final int i = IndexedDomain.indexOf(elements, index, element);
            checkObjectInDomain(i != -1, element, -1);
            add[i / 64] |= 1L << (i % 64);
        }
        // Check if there is at least one element to add.
        boolean empty = true;
        for (long block : add) {
            if (block != 0L) {
                empty = false;
                break;
            }
        }
        if (empty) {
            return false;
        }
        if (otherSet != null && elements.length < otherSet.elements.length) {
            // Check if add contains at least one element that does not fit in elements.
            for (int i = add.length - 1; i >= 0; i--) {
                if (add[i] != 0L) {
                    int lastIndex = 64 * i + 63 - Long.numberOfLeadingZeros(add[i]);
                    checkObjectInDomain(lastIndex < elements.length, otherSet.elements, lastIndex);
                    break;
                }
            }
        }
        if (member == null) {
            final boolean otherMissesLoneMember = loneMember != -1
                    && (add.length <= loneMember / 64 || (add[loneMember / 64] & (1L << (loneMember % 64))) == 0L);
            final int size = bitCount(add) + (otherMissesLoneMember ? 1 : 0);
            if (size == 0 || size == 1 && loneMember != -1) {
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
        final int length = Integer.min(member.length, add.length);
        for (int pageindex = 0; pageindex < length; pageindex++) {
            final long changes = ~member[pageindex] & add[pageindex];
            member[pageindex] ^= changes;
            changed |= changes != 0L;
        }
        //shrinkIfPossible();
        return changed;
    }

    @Override
    public boolean removeAll(Collection<?> other) {
        checkModifiable();
        if (member == null) {
            final boolean changed = loneMember != -1 && other.contains(elements[loneMember]);
            loneMember = changed ? -1 : loneMember;
            return changed;
        }
        if (other instanceof IndexedSet<?> o && o.member != null && domain.isCompatible(o.domain)) {
            boolean changed = false;
            final int length = Integer.min(member.length, o.member.length);
            for (int pageindex = 0; pageindex < length; pageindex++) {
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
        checkModifiable();
        if (member == null) {
            final boolean changed = loneMember != -1 && !other.contains(elements[loneMember]);
            loneMember = changed ? -1 : loneMember;
            return changed;
        }
        if (unwrap(other) instanceof IndexedSet<?> o && o.member != null && domain.isCompatible(o.domain)) {
            boolean changed = false;
            final int length = Integer.min(member.length, o.member.length);
            for (int pageindex = 0; pageindex < length; pageindex++) {
                final long changes = member[pageindex] & ~o.member[pageindex];
                member[pageindex] ^= changes;
                changed |= changes != 0L;
            }
            if (domain != o.domain) {
                for (int i = length; !changed && i < member.length; i++) {
                    changed = member[i] != 0L;
                }
                Arrays.fill(member, length, member.length, 0L);
            }
            shrinkIfPossible();
            return changed;
        }
        return removeIf(Predicate.not(other::contains));
    }

    @Override
    public boolean removeIf(Predicate<? super E> filter) {
        checkModifiable();
        if (member == null) {
            final boolean changed = loneMember != -1 && filter.test((E) elements[loneMember]);
            loneMember = changed ? -1 : loneMember;
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
            if (loneMember != -1) {
                member[loneMember / 64] |= 1L << (loneMember % 64);
            }
            loneMember = -1;
        }
    }

    private void shrinkIfPossible() {
        if (member != null && bitCount(member) <= 1) {
            loneMember = lowestBit(member);
            loneMember = elements.length <= loneMember ? -1 : loneMember;
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

    private void checkModifiable() {
        if (!modifiable) {
            throw new UnsupportedOperationException("This %s is unmodifiable!".formatted(getClass().getSimpleName()));
        }
    }

    private void checkObjectInDomain(boolean condition, Object element, int index) {
        if (!condition) {
            throw new NoSuchElementException((index == -1 ? element : ((Object[]) element)[index]).toString());
        }
    }
}
