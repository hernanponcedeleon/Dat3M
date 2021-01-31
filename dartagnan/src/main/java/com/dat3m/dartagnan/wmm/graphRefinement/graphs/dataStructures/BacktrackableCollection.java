package com.dat3m.dartagnan.wmm.graphRefinement.graphs.dataStructures;

import java.sql.Array;
import java.util.*;
import java.util.function.Supplier;
import java.util.stream.Collectors;

// NOTE: This class acts as a collection of the provided collectionSupplier
// at each backtrack point, but it does not act as such over all backtrack points!
// E.g. it may contain duplicates on different backtrack points, even if the underlying collection is a set
// NOTE2: This class does not allow deletion, except by backtracking. The only valid form of explicit deletion
// is <clear>
// Problems: Since this class manages a hierarchy of collections, containment queries
// have a least runtime of O(m), where m is the number of backtracking points.
// This holds even in the case of set-based implementations
// On the other hand, backtracking is a fast O(log(m)) operation,.
// Similar problems apply to other operations such as size.
public abstract class BacktrackableCollection<T> implements Collection<T>, Backtrackable{
    private final Supplier<Collection<T>> collectionSupplier;
    private final ArrayList<Collection<T>> items;
    private final ArrayList<Integer> backtrackPoints;

    protected Collection<T> getCurrentCollection() {
        return items.get(items.size() - 1);
    }

    public BacktrackableCollection(Supplier<Collection<T>> collectionSupplier) {
        items = new ArrayList<>();
        backtrackPoints = new ArrayList<>();
        this.collectionSupplier = collectionSupplier;

        items.add(collectionSupplier.get());
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
        items.add(index, collectionSupplier.get());
        backtrackPoints.add(index, identifier);
        return true;
    }

    @Override
    public int getCurrentBacktrackPoint() {
        return backtrackPoints.get(backtrackPoints.size() - 1);
    }

    @Override
    public int size() {
        return items.stream().mapToInt(Collection::size).sum();
    }

    @Override
    public boolean isEmpty() {
       return items.stream().anyMatch(x -> !x.isEmpty());
    }

    @Override
    public boolean contains(Object o) {
        return items.stream().anyMatch(x -> x.contains(o));
    }

    @Override
    public Iterator<T> iterator() {
        return items.stream().flatMap(Collection::stream).iterator();
    }

    @Override
    public Object[] toArray() {
        return items.stream().flatMap(Collection::stream).toArray();
    }

    @Override
    public <T1> T1[] toArray(T1[] a) {
        return items.stream().flatMap(Collection::stream).collect(Collectors.toList()).toArray(a);
    }

    @Override
    public boolean add(T t) {
        return getCurrentCollection().add(t);
    }

    @Override
    public boolean remove(Object o) {
        throw new UnsupportedOperationException();
    }



    @Override
    public boolean containsAll(Collection<?> c) {
        return c.stream().allMatch(this::contains);
    }

    @Override
    public boolean addAll(Collection<? extends T> c) {
        boolean changed = false;
        for (T o : c)
            changed |= add(o);
        return changed;
    }

    @Override
    public boolean removeAll(Collection<?> c) {
        throw new UnsupportedOperationException();
    }

    @Override
    public boolean retainAll(Collection<?> c) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void clear() {
        items.clear();
        backtrackPoints.clear();

        items.add(collectionSupplier.get());
        backtrackPoints.add(0);
    }
}
