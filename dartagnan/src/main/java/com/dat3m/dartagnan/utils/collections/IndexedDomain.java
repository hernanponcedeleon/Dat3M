package com.dat3m.dartagnan.utils.collections;

import java.util.Arrays;
import java.util.Collection;

/// Used for compact sets, see `IndexedSet`.
public final class IndexedDomain<E> {

    private static final float HASH_TABLE_FILL_FACTOR = 1.5f;

    final Object[] elements;
    final int[] index;

    public IndexedDomain(Collection<E> elements) {
        this.elements = elements.toArray();
        index = newIndex(this.elements);
    }

    public E element(int index) {
        return (E) elements[index];
    }

    public int size() {
        return elements.length;
    }

    public int indexOf(Object key) {
        return indexOf(elements, index, key);
    }

    @Override
    public int hashCode() {
        return elements.hashCode();
    }

    @Override
    public boolean equals(Object other) {
        return other instanceof IndexedDomain<?> o && elements == o.elements;
    }

    static int indexOf(Object[] domain, int[] index, Object key) {
        final int hash = key.hashCode();
        int h = (hash % (index.length >> 1)) << 1;
        int fast;
        while ((fast = index[h]) != -1 && (index[h | 1] != hash || !domain[fast].equals(key))) {
            h += 2;
            h = h < index.length ? h : 0;
        }
        return fast;
    }

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
}
