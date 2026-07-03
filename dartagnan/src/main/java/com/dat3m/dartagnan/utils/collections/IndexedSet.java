package com.dat3m.dartagnan.utils.collections;

import com.google.common.base.Preconditions;

import java.util.*;
import java.util.function.Consumer;
import java.util.function.Predicate;

/// Compact subset of a collection using a bitvector.
// This implementation has two forms:
// - In its <i>array form</i>,
//   it contains a bit array where the bit at position `domain.indexOf(e)` is set iff `e` is contained.
// - It can only maintain its <i>loneMember form</i>,
//   if it contains up to one element, in which case it stores its index.
// Instances can be in <i>array form</i>, even if they contain less than two elements.
// This happens e.g. after `addAll(Set.of(e1))` and `addAll(Set.of(e1,e2)); remove(e1)`.
// This is because the check would be too expensive.
public final class IndexedSet<E> extends AbstractSet<E> {
    private final IndexedDomain<E> domain;
    private final E[] elements;
    private final int[] index;
    private final boolean modifiable;
    private long[] member;

    // Used for sets with `size() <= 1` to make them even more compact.
    // This is especially useful for identity graphs.
    private int loneMember;

    // False if `member != null` and at least one bit is set in `member`.  True gives no guarantees.
    private boolean memberMayBeEmpty;

    // True if `member` is shared with another instance.
    private transient boolean copyOnWrite;

    public IndexedSet(IndexedSet<E> original) {
        this(original.domain, original.member, original.loneMember, true);
        original.copyOnWrite = this.copyOnWrite = original.member != null;
        this.memberMayBeEmpty = original.memberMayBeEmpty;
    }

    IndexedSet(IndexedDomain<E> domain, long[] member, int loneMember, boolean modifiable) {
        this.domain = domain;
        this.elements = domain.elements;
        this.index = domain.index;
        this.member = member;
        this.loneMember = loneMember;
        this.modifiable = modifiable;
    }

    public IndexedDomain<E> domain() {
        return domain;
    }

    public IndexedSet<E> toUnmodifiableCopy() {
        if (!modifiable) {
            return this;
        }
        copyOnWrite = member != null;
        return new IndexedSet<>(domain, member, loneMember, false);
    }

    public boolean test(int index) {
        return test(elements.length, member, loneMember, index);
    }

    public boolean exchange(int index, boolean value) {
        if (index < 0 || elements.length <= index) {
            throw new IndexOutOfBoundsException("0 <= %d < %d".formatted(index, elements.length));
        }
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
        checkCopyOnWrite();
        final long mask = 1L << (index % 64);
        final boolean change = value == ((member[index / 64] & mask) == 0L);
        member[index / 64] ^= change ? mask : 0L;
        memberMayBeEmpty = change ? !value : memberMayBeEmpty;
        return change != value;
    }

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
        if (!domain.isCompatibleWith(other.domain)) {
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
    public boolean isEmpty() {
        return member == null ? loneMember == -1 : memberMayBeEmpty && size() == 0;
    }

    @Override
    public boolean contains(Object o) {
        final int index = IndexedDomain.indexOf(elements, this.index, o);
        return index != -1 && test(elements.length, member, loneMember, index);
    }

    @Override
    public boolean containsAll(Collection<?> other) {
        if (other instanceof IndexedSet<?> o && domain.isCompatibleWith(o.domain)) {
            if (o.member == null) {
                return o.loneMember == -1 || test(elements.length, member, loneMember, o.loneMember);
            }
            if (member != null) {
                for (int pageindex = 0; pageindex < member.length; pageindex++) {
                    if (0L != (~member[pageindex] & o.member[pageindex])) {
                        return false;
                    }
                }
                return true;
            }
        }
        return super.containsAll(other);
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
                return elements[indexArray[progress++]];
            }
        };
    }

    @Override
    public Spliterator<E> spliterator() {
        if (member == null) {
            return (loneMember == -1 ? List.<E>of() : List.of(elements[loneMember])).spliterator();
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
            action.accept(elements[from]);
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
        final int index = IndexedDomain.indexOf(elements, this.index, element);
        checkObjectInDomain(index != -1, element, -1);
        return !exchange(index, true);
    }

    @Override
    public boolean remove(Object element) {
        final int index = IndexedDomain.indexOf(elements, this.index, element);
        return index != -1 && exchange(index, false);
    }

    @Override
    public boolean addAll(Collection<? extends E> other) {
        checkModifiable();
        final var otherSet = other instanceof IndexedSet<?> o && domain.isCompatibleWith(o.domain) ? o : null;
        if (otherSet != null && otherSet.member == null) {
            checkObjectInDomain(otherSet.loneMember < elements.length, otherSet.elements, otherSet.loneMember);
            return otherSet.loneMember != -1 && exchange(otherSet.loneMember, true);
        }
        final var add = otherSet != null ? otherSet.member : IndexedDomain.newBits(elements.length);
        for (Object element : otherSet != null ? Set.of() : other) {
            final int index = IndexedDomain.indexOf(elements, this.index, element);
            checkObjectInDomain(index != -1, element, -1);
            add[index / 64] |= 1L << (index % 64);
        }
        // Check if there is at least one element to add.
        boolean empty = true;
        for (long page : add) {
            if (page != 0L) {
                empty = false;
                break;
            }
        }
        if (empty) {
            return false;
        }
        if (otherSet != null && elements.length < otherSet.elements.length) {
            // Check if add contains at least one element that does not fit in elements.
            for (int pageindex = add.length - 1; pageindex >= 0; pageindex--) {
                if (add[pageindex] != 0L) {
                    int lastIndex = 64 * pageindex + 63 - Long.numberOfLeadingZeros(add[pageindex]);
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
        checkCopyOnWrite();
        boolean changed = false;
        final int length = Integer.min(member.length, add.length);
        for (int pageindex = 0; pageindex < length; pageindex++) {
            final long changes = ~member[pageindex] & add[pageindex];
            member[pageindex] ^= changes;
            changed |= changes != 0L;
        }
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
        checkCopyOnWrite();
        if (other instanceof IndexedSet<?> o && o.member != null && domain.isCompatibleWith(o.domain)) {
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
        if (other.size() < size()) {
            boolean changed = false;
            for (Object o : other) {
                changed |= remove(o);
            }
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
        checkCopyOnWrite();
        if (other instanceof IndexedSet<?> o && domain.isCompatibleWith(o.domain)) {
            if (o.member == null) {
                loneMember = o.loneMember != -1 && test(elements.length, member, -1, o.loneMember) ? o.loneMember : -1;
                final boolean changed = (loneMember == -1 ? 0 : 1) < bitCount(member);
                member = null;
                return changed;
            }
            boolean changed = false;
            final int length = Integer.min(member.length, o.member.length);
            for (int pageindex = 0; pageindex < length; pageindex++) {
                final long changes = member[pageindex] & ~o.member[pageindex];
                member[pageindex] ^= changes;
                changed |= changes != 0L;
            }
            if (domain != o.domain) {
                for (int pageindex = length; !changed && pageindex < member.length; pageindex++) {
                    changed = member[pageindex] != 0L;
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
            final boolean changed = loneMember != -1 && filter.test(elements[loneMember]);
            loneMember = changed ? -1 : loneMember;
            return changed;
        }
        checkCopyOnWrite();
        boolean changed = false;
        for (int pageindex = 0; pageindex < member.length; pageindex++) {
            long page = member[pageindex];
            if (page != 0L) {
                long changes = 0L;
                while (page != 0L) {
                    final int next = Long.numberOfTrailingZeros(page);
                    final long mask = 1L << next;
                    page &= ~mask;
                    if (filter.test(elements[64 * pageindex + next])) {
                        changes |= mask;
                    }
                }
                member[pageindex] ^= changes;
                changed |= changes != 0L;
            }
        }
        shrinkIfPossible();
        return changed;
    }

    static <E> IndexedSet<E> intersection(Collection<E> left, Collection<E> right) {
        final var indexedLeft = left instanceof IndexedSet<E> s ? s : null;
        final var indexedRight = right instanceof IndexedSet<E> s ? s : null;
        Preconditions.checkArgument(indexedLeft != null || indexedRight != null, "Missing domain for intersection.");
        final boolean useLeftDomain = indexedRight == null
                || (indexedLeft != null && indexedLeft.domain.size() < indexedRight.domain.size());
        final IndexedSet<E> intersection = new IndexedSet<>(useLeftDomain ? indexedLeft : indexedRight);
        intersection.retainAll(useLeftDomain ? right : left);
        return intersection;
    }

    private static boolean test(int size, long[] member, int loneMember, int index) {
        assert 0 <= index;
        if (size <= index) {
            return false;
        }
        return member == null ? loneMember == index : (member[index / 64] & (1L << (index % 64))) != 0L;
    }

    private void ensureMemberArray() {
        if (member == null) {
            member = IndexedDomain.newBits(elements.length);
            memberMayBeEmpty = loneMember == -1;
            member[loneMember / 64] |= loneMember == -1 ? 0L : 1L << (loneMember % 64);
            loneMember = -1;
        }
    }

    private void shrinkIfPossible() {
        if (member != null && bitCount(member) <= 1) {
            loneMember = lowestBit(member);
            loneMember = elements.length <= loneMember ? -1 : loneMember;
            member = null;
        }
        memberMayBeEmpty = false;
    }

    private static int lowestBit(long[] bits) {
        int lowestBit = 0;
        for (long page : bits) {
            if (page == 0L) {
                lowestBit += 64;
            } else {
                lowestBit += Long.numberOfTrailingZeros(page);
                break;
            }
        }
        return lowestBit;
    }

    private static int bitCount(long[] bits) {
        int count = 0;
        for (long page : bits) {
            count += Long.bitCount(page);
        }
        return count;
    }

    private void checkModifiable() {
        if (!modifiable) {
            throw new UnsupportedOperationException("This %s is unmodifiable!".formatted(getClass().getSimpleName()));
        }
    }

    private void checkCopyOnWrite() {
        if (copyOnWrite) {
            copyOnWrite = false;
            final long[] newMember = new long[member.length];
            System.arraycopy(member, 0, newMember, 0, member.length);
            member = newMember;
        }
    }

    private void checkObjectInDomain(boolean condition, Object element, int index) {
        if (!condition) {
            throw new NoSuchElementException((index == -1 ? element : ((Object[]) element)[index]).toString());
        }
    }
}
