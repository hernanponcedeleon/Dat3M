package com.dat3m.dartagnan.utils.collections;

import java.util.*;

// Used for compact sets, see `IndexedSet`.
// This implementation contains an immutable hash table to look up an index by element.
public final class IndexedDomain<E> {

    private static final float HASH_TABLE_FILL_FACTOR = 1.5f;

    final E[] elements;
    final int[] index;
    final Map<IndexedDomain<?>, Boolean> compatibilityMap = new HashMap<>();
    final IndexedSet<E> emptySet;
    final IndexedSet<E> fullSet;

    @SuppressWarnings("unchecked")
    public IndexedDomain(Collection<E> elements) {
        this.elements = (E[]) elements.toArray();
        index = newIndex(this.elements);
        emptySet = new IndexedSet<>(this, null, -1, false);
        final long[] member = newBits(this.elements.length);
        Arrays.fill(member, ~0L);
        member[member.length - 1] &= ~0L >>> (64 - (this.elements.length % 64));
        fullSet = new IndexedSet<>(this, member, -1, false);
    }

    public int size() {
        return elements.length;
    }

    public E element(int index) {
        return elements[index];
    }

    public int indexOf(Object key) {
        return indexOf(elements, index, key);
    }

    public IndexedSet<E> emptySet() {
        return emptySet;
    }

    public IndexedSet<E> fullSet() {
        return fullSet;
    }

    public IndexedSet<E> newSet() {
        return new IndexedSet<>(this, null, -1, true);
    }

    public IndexedSet<E> newSet(Collection<? extends E> copy) {
        final IndexedSet<E> set = new IndexedSet<>(this, null, -1, true);
        set.addAll(copy);
        return set;
    }

    public boolean isCompatibleWith(IndexedDomain<?> other) {
        return this == other || compatibilityMap.computeIfAbsent(other, this::computeCompatible);
    }

    private boolean computeCompatible(IndexedDomain<?> other) {
        final int length = Integer.min(elements.length, other.elements.length);
        for (int i = 0; i < length; i++) {
            if (!elements[i].equals(other.elements[i])) {
                return false;
            }
        }
        return true;
    }

    static long[] newBits(int length) {
        return new long[1 + (length - 1) / 64];
    }

    static <E> int indexOf(E[] domain, int[] index, Object key) {
        final int hash = key.hashCode();
        int h = (hash % (index.length >> 1)) << 1;
        int fast;
        while ((fast = index[h]) != -1 && (index[h | 1] != hash || !domain[fast].equals(key))) {
            h += 2;
            h = h < index.length ? h : 0;
        }
        return fast;
    }

    private static <E> int[] newIndex(E[] domain) {
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
}
