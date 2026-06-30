package com.dat3m.dartagnan.utils.collections;

import java.util.*;

public final class IndexedMap<Key, Value> extends AbstractMap<Key, Value> {

    private final IndexedSet<Key> keySet;
    private final Value[] values;

    IndexedMap(IndexedSet<Key> k, Value[] v) {
        keySet = k;
        values = v;
    }

    public boolean addIndex(int index, Value value) {
        values[index] = value;
        return !keySet.exchange(index, true);
    }

    public boolean removeIndex(int index) {
        values[index] = null;
        return keySet.exchange(index, false);
    }

    @Override
    public Set<Entry<Key, Value>> entrySet() {
        return new EntrySet();
    }

    private final class EntrySet extends AbstractSet<Entry<Key, Value>> {
        @Override
        public int size() {
            return keySet.size();
        }
        @Override
        public Iterator<Entry<Key, Value>> iterator() {
            return new EntryIterator();
        }
        @Override
        public boolean contains(Object entry) {
            return entry instanceof Entry<?, ?> e && keySet.contains(e.getKey());
        }
        @Override
        public void clear() {
            Arrays.fill(values, null);
            keySet.clear();
        }
        @Override
        public boolean add(Entry<Key, Value> newEntry) {
            return addIndex(keySet.domain().indexOf(newEntry.getKey()), newEntry.getValue());
        }
        @Override
        public boolean remove(Object entry) {
            return entry instanceof Entry<?, ?> e && removeIndex(keySet.domain().indexOf(e.getKey()));
        }
    }

    private final class EntryIterator implements Iterator<Entry<Key, Value>> {
        private final int[] indexArray = keySet.toIndexArray();
        private int progress;
        @Override
        public boolean hasNext() {
            return progress < indexArray.length;
        }
        @Override
        public Entry<Key, Value> next() {
            return new EntryAtIndex(indexArray[progress++]);
        }
        @Override
        public void remove() {
            removeIndex(indexArray[progress-1]);
        }
    }

    private final class EntryAtIndex implements Entry<Key, Value> {
        private final int index;
        private EntryAtIndex(int i) { index = i; }
        @Override
        public Key getKey() {
            return keySet.domain().element(index);
        }
        @Override
        public Value getValue() {
            return values[index];
        }
        @Override
        public Value setValue(Value newValue) {
            final Value oldValue = values[index];
            values[index] = newValue;
            return oldValue;
        }
    }
}
