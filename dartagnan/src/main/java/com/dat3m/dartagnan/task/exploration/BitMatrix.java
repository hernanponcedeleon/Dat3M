package com.dat3m.dartagnan.task.exploration;

import java.util.Arrays;
import java.util.BitSet;

/*
    A dense binary relation over {0, ..., n-1}, stored row-wise as a flat array of 64-bit words.
 */
final class BitMatrix {

    final int n;
    final int words;    // Words per row
    final long[] bits;

    BitMatrix(int n) {
        this.n = n;
        this.words = Math.max(1, (n + 63) >>> 6);
        this.bits = new long[n * words];
    }

    private BitMatrix(BitMatrix other) {
        this.n = other.n;
        this.words = other.words;
        this.bits = other.bits.clone();
    }

    BitMatrix copy() {
        return new BitMatrix(this);
    }

    void set(int i, int j) {
        bits[i * words + (j >>> 6)] |= 1L << j;
    }

    boolean get(int i, int j) {
        return (bits[i * words + (j >>> 6)] & (1L << j)) != 0;
    }

    boolean isRowEmpty(int i) {
        final int base = i * words;
        for (int w = 0; w < words; w++) {
            if (bits[base + w] != 0) {
                return false;
            }
        }
        return true;
    }

    boolean isEmpty() {
        for (long b : bits) {
            if (b != 0) {
                return false;
            }
        }
        return true;
    }

    // this |= other
    void or(BitMatrix other) {
        for (int k = 0; k < bits.length; k++) {
            bits[k] |= other.bits[k];
        }
    }

    // this &= other
    void and(BitMatrix other) {
        for (int k = 0; k < bits.length; k++) {
            bits[k] &= other.bits[k];
        }
    }

    // this &= ~other
    void andNot(BitMatrix other) {
        for (int k = 0; k < bits.length; k++) {
            bits[k] &= ~other.bits[k];
        }
    }

    // row(i) |= mask, where mask is a word array of length "words"
    void orRow(int i, long[] mask) {
        final int dst = i * words;
        for (int w = 0; w < words; w++) {
            bits[dst + w] |= mask[w];
        }
    }

    // Returns an empty word array with the row layout of this matrix.
    long[] newRowMask() {
        return new long[words];
    }

    static void setBit(long[] mask, int j) {
        mask[j >>> 6] |= 1L << j;
    }

    // row(i) |= row(j) of other
    private void orRow(int i, BitMatrix other, int j) {
        final int dst = i * words;
        final int src = j * other.words;
        for (int w = 0; w < words; w++) {
            bits[dst + w] |= other.bits[src + w];
        }
    }

    BitMatrix compose(BitMatrix right) {
        final BitMatrix result = new BitMatrix(n);
        for (int i = 0; i < n; i++) {
            final int base = i * words;
            for (int w = 0; w < words; w++) {
                long word = bits[base + w];
                while (word != 0) {
                    final int k = (w << 6) + Long.numberOfTrailingZeros(word);
                    word &= word - 1;
                    result.orRow(i, right, k);
                }
            }
        }
        return result;
    }

    // Keeps only the rows in the given set.
    BitMatrix restrictRows(BitSet rows) {
        final BitMatrix result = new BitMatrix(n);
        for (int i = rows.nextSetBit(0); i >= 0 && i < n; i = rows.nextSetBit(i + 1)) {
            System.arraycopy(bits, i * words, result.bits, i * words, words);
        }
        return result;
    }

    // Keeps only the columns in the given set.
    BitMatrix restrictColumns(BitSet columns) {
        final long[] mask = new long[words];
        final long[] colWords = columns.toLongArray();
        System.arraycopy(colWords, 0, mask, 0, Math.min(colWords.length, words));
        final BitMatrix result = copy();
        for (int i = 0; i < n; i++) {
            final int base = i * words;
            for (int w = 0; w < words; w++) {
                result.bits[base + w] &= mask[w];
            }
        }
        return result;
    }

    BitMatrix inverse() {
        final BitMatrix result = new BitMatrix(n);
        forEach((i, j) -> result.set(j, i));
        return result;
    }

    // Transitive closure (Warshall's algorithm on bit rows).
    BitMatrix transitiveClosure() {
        final BitMatrix result = copy();
        for (int k = 0; k < n; k++) {
            if (result.isRowEmpty(k)) {
                continue; // Nothing to propagate through k
            }
            final int kWord = k >>> 6;
            final long kMask = 1L << k;
            for (int i = 0; i < n; i++) {
                if ((result.bits[i * words + kWord] & kMask) != 0) {
                    result.orRow(i, result, k);
                }
            }
        }
        return result;
    }

    boolean isIrreflexive() {
        for (int i = 0; i < n; i++) {
            if (get(i, i)) {
                return false;
            }
        }
        return true;
    }

    boolean isAcyclic() {
        // Kahn's algorithm
        final int[] inDegree = new int[n];
        forEach((i, j) -> inDegree[j]++);
        final int[] queue = new int[n];
        int head = 0;
        int tail = 0;
        for (int i = 0; i < n; i++) {
            if (inDegree[i] == 0) {
                queue[tail++] = i;
            }
        }
        while (head < tail) {
            final int i = queue[head++];
            final int base = i * words;
            for (int w = 0; w < words; w++) {
                long word = bits[base + w];
                while (word != 0) {
                    final int j = (w << 6) + Long.numberOfTrailingZeros(word);
                    word &= word - 1;
                    if (--inDegree[j] == 0) {
                        queue[tail++] = j;
                    }
                }
            }
        }
        return tail == n;
    }

    // Domain (dimension = rows with an edge) or range (columns with an edge).
    BitSet domain() {
        final BitSet result = new BitSet(n);
        for (int i = 0; i < n; i++) {
            if (!isRowEmpty(i)) {
                result.set(i);
            }
        }
        return result;
    }

    BitSet range() {
        final BitSet result = new BitSet(n);
        forEach((i, j) -> result.set(j));
        return result;
    }

    interface PairConsumer {
        void accept(int i, int j);
    }

    void forEach(PairConsumer consumer) {
        for (int i = 0; i < n; i++) {
            final int base = i * words;
            for (int w = 0; w < words; w++) {
                long word = bits[base + w];
                while (word != 0) {
                    final int j = (w << 6) + Long.numberOfTrailingZeros(word);
                    word &= word - 1;
                    consumer.accept(i, j);
                }
            }
        }
    }

    @Override
    public boolean equals(Object o) {
        return o instanceof BitMatrix other && other.n == n && Arrays.equals(bits, other.bits);
    }

    @Override
    public int hashCode() {
        return Arrays.hashCode(bits);
    }
}
