package com.dat3m.dartagnan.wmm.graphRefinement.graphs.dataStructures;

import java.util.*;
import java.util.function.BiConsumer;
import java.util.function.BiFunction;
import java.util.function.Function;
import java.util.function.Supplier;
import java.util.stream.Collectors;

// NOTE: This class acts as a collection of the provided collectionSupplier
// at each backtrack point, but it does not act as such over all backtrack points!
// E.g. it may contain duplicates on different backtrack points, even if the underlying collection is a set
// NOTE2: This class does not allow deletion, except by backtracking. The only valid form of explicit deletion
// is <clear>
//TODO: Finish implementation
public abstract class BacktrackableMap<TKey, TValue> implements Map<TKey, TValue>, Backtrackable {
    private final Supplier<Map<TKey, TValue>> mapSupplier;
    private final ArrayList<Map<TKey, TValue>> items;
    private final ArrayList<Integer> backtrackPoints;

    protected Map<TKey, TValue> getCurrentCollection() {
        return items.get(items.size() - 1);
    }

    public BacktrackableMap(Supplier<Map<TKey, TValue>> mapSupplier) {
        items = new ArrayList<>();
        backtrackPoints = new ArrayList<>();
        this.mapSupplier = mapSupplier;

        items.add(mapSupplier.get());
        backtrackPoints.add(0);
    }

    @Override
    public void backtrack(int identifier) {
        if (identifier < 0) {
            throw new IllegalArgumentException("The backtrack point identifier must be non-negative.");
        }
        int index = Collections.binarySearch(backtrackPoints, identifier);
        if (index < 0)
            index = ~index;
        items.subList(index, items.size()).clear();
        backtrackPoints.subList(index, backtrackPoints.size()).clear();
    }

    @Override
    public boolean createBacktrackPoint(int identifier) {
        if ( identifier < 0) {
            throw new IllegalArgumentException("The backtrack point identifier must be non-negative.");
        }
        int index = Collections.binarySearch(backtrackPoints, identifier);
        if (index >= 0) {
            // backtrackpoint already exists
            return false;
        }
        index = ~index;
        items.add(index, mapSupplier.get());
        backtrackPoints.add(index, identifier);
        return true;
    }

    @Override
    public int getCurrentBacktrackPoint() {
        return backtrackPoints.get(backtrackPoints.size() - 1);
    }

    @Override
    public int size() {
        return items.stream().mapToInt(Map::size).sum();
    }

    @Override
    public boolean isEmpty() {
       return items.stream().anyMatch(x -> !x.isEmpty());
    }

    @Override
    public void clear() {
        items.clear();
        backtrackPoints.clear();

        items.add(mapSupplier.get());
        backtrackPoints.add(0);
    }


    @Override
    public void forEach(BiConsumer<? super TKey, ? super TValue> action) {
        items.stream().flatMap(x -> x.entrySet().stream()).forEach(x -> action.accept(x.getKey(), x.getValue()) );
    }

    @Override
    public void replaceAll(BiFunction<? super TKey, ? super TValue, ? extends TValue> function) {
        throw new UnsupportedOperationException();
    }

    @Override
    public boolean remove(Object key, Object value) {
        throw new UnsupportedOperationException();
    }

    @Override
    public boolean replace(TKey key, TValue oldValue, TValue newValue) {
        throw new UnsupportedOperationException();
    }

    @Override
    public TValue replace(TKey key, TValue value) {
        throw new UnsupportedOperationException();
    }

    @Override
    public TValue computeIfPresent(TKey key, BiFunction<? super TKey, ? super TValue, ? extends TValue> remappingFunction) {
        throw new UnsupportedOperationException();
    }

    @Override
    public TValue compute(TKey key, BiFunction<? super TKey, ? super TValue, ? extends TValue> remappingFunction) {
        throw new UnsupportedOperationException();
    }

    @Override
    public TValue merge(TKey key, TValue value, BiFunction<? super TValue, ? super TValue, ? extends TValue> remappingFunction) {
        throw new UnsupportedOperationException();
    }

    @Override
    public boolean containsKey(Object key) {
        return items.stream().anyMatch(x -> x.containsKey(key));
    }

    @Override
    public boolean containsValue(Object value) {
        return items.stream().anyMatch(x -> x.containsValue(value));
    }

    @Override
    public TValue get(Object key) {
        TValue item = null;
        int index = 0;
        while (item == null && index < items.size()) {
            item = items.get(index++).get(key);
        }
        return item;
    }

    @Override
    public TValue put(TKey key, TValue value) {
        TValue old = get(key);
        if (old == null) {
            getCurrentCollection().put(key, value);
        }
        return old;
    }

    @Override
    public TValue remove(Object key) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void putAll(Map<? extends TKey, ? extends TValue> m) {
        m.forEach(this::put);
    }

    @Override
    public Set<TKey> keySet() {
        return null;
    }

    @Override
    public Collection<TValue> values() {
        return null;
    }

    @Override
    public Set<Entry<TKey, TValue>> entrySet() {
        return null;
    }
}
