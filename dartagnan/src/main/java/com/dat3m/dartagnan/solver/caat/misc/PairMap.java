package com.dat3m.dartagnan.solver.caat.misc;

import java.util.Arrays;

/*
    An open-addressing hash map from pairs of non-negative integers to objects.
    It uses linear probing with backward-shift deletion, so it needs no tombstones.
    This is considerably faster than a HashMap with boxed keys (and avoids degenerate hashing).
 */
public final class PairMap<V> {

    private static final long EMPTY = -1L;

    private long[] keys;
    private Object[] values;
    private int size;
    private int mask;
    private int resizeThreshold;

    public PairMap() {
        this(16);
    }

    public PairMap(int expectedSize) {
        int capacity = Integer.highestOneBit(Math.max(4, (int) (expectedSize / 0.5f)) - 1) << 1;
        allocate(capacity);
    }

    private void allocate(int capacity) {
        keys = new long[capacity];
        Arrays.fill(keys, EMPTY);
        values = new Object[capacity];
        mask = capacity - 1;
        resizeThreshold = capacity >> 1;
    }

    public static long key(int a, int b) {
        return ((long) a << 32) | (b & 0xFFFFFFFFL);
    }

    private static int hash(long k) {
        // fmix64 of MurmurHash3
        k ^= k >>> 33;
        k *= 0xff51afd7ed558ccdL;
        k ^= k >>> 33;
        k *= 0xc4ceb9fe1a85ec53L;
        k ^= k >>> 33;
        return (int) k;
    }

    public int size() { return size; }
    public boolean isEmpty() { return size == 0; }

    @SuppressWarnings("unchecked")
    public V get(int a, int b) {
        final long k = key(a, b);
        int i = hash(k) & mask;
        long cur;
        while ((cur = keys[i]) != EMPTY) {
            if (cur == k) {
                return (V) values[i];
            }
            i = (i + 1) & mask;
        }
        return null;
    }

    public boolean containsKey(int a, int b) {
        return get(a, b) != null;
    }

    // Returns the existing value, or null if the value was inserted.
    @SuppressWarnings("unchecked")
    public V putIfAbsent(int a, int b, V value) {
        final long k = key(a, b);
        int i = hash(k) & mask;
        long cur;
        while ((cur = keys[i]) != EMPTY) {
            if (cur == k) {
                return (V) values[i];
            }
            i = (i + 1) & mask;
        }
        keys[i] = k;
        values[i] = value;
        if (++size > resizeThreshold) {
            rehash(keys.length << 1);
        }
        return null;
    }

    public boolean remove(int a, int b) {
        final long k = key(a, b);
        int i = hash(k) & mask;
        long cur;
        while ((cur = keys[i]) != EMPTY) {
            if (cur == k) {
                deleteAt(i);
                return true;
            }
            i = (i + 1) & mask;
        }
        return false;
    }

    private void deleteAt(int i) {
        size--;
        // Backward-shift deletion
        int gap = i;
        int j = i;
        while (true) {
            j = (j + 1) & mask;
            final long k = keys[j];
            if (k == EMPTY) {
                break;
            }
            final int home = hash(k) & mask;
            // Move entry j into the gap if its home position is not in (gap, j] (cyclically)
            if (((j - home) & mask) >= ((j - gap) & mask)) {
                keys[gap] = k;
                values[gap] = values[j];
                gap = j;
            }
        }
        keys[gap] = EMPTY;
        values[gap] = null;
    }

    public void clear() {
        if (size == 0) {
            return;
        }
        Arrays.fill(keys, EMPTY);
        Arrays.fill(values, null);
        size = 0;
    }

    private void rehash(int newCapacity) {
        final long[] oldKeys = keys;
        final Object[] oldValues = values;
        allocate(newCapacity);
        for (int i = 0; i < oldKeys.length; i++) {
            final long k = oldKeys[i];
            if (k != EMPTY) {
                int j = hash(k) & mask;
                while (keys[j] != EMPTY) {
                    j = (j + 1) & mask;
                }
                keys[j] = k;
                values[j] = oldValues[i];
            }
        }
    }
}
