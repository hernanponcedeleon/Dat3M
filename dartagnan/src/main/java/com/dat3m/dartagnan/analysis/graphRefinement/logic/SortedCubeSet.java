package com.dat3m.dartagnan.analysis.graphRefinement.logic;

import com.dat3m.dartagnan.utils.collections.Vect;

import java.util.*;
import java.util.function.Predicate;

/*
   This class is a sorted list of cubes without duplicates.
   The sorting is done according to cube size.
   Unlike DNF, this class is mutable for performance reasons.
   Many methods modify the current instance and return it to allow chaining.
 */
public class SortedCubeSet<T extends Literal<T>> implements Iterable<Conjunction<T>> {

    private static final int INITIALCAPACITY = 10;

    private static final SortedCubeSet FALSE = new SortedCubeSet(0);
    private static final SortedCubeSet TRUE = new SortedCubeSet(1);

    static {
        TRUE.cubes.append(Conjunction.TRUE());
    }

    
    protected Vect<Conjunction<T>> cubes;
    protected Comparator<Conjunction<T>> comparator;

    public List<Conjunction<T>> getCubes() {
        return Collections.unmodifiableList(cubes);
    }

    public boolean isFalse() {
        return cubes.isEmpty();
    }

    public boolean isTrue() {
        return !cubes.isEmpty() && cubes.getFirstUnsafe().isTrue();
    }

    public int getLiteralSize() {
        return cubes.stream().mapToInt(Conjunction::getSize).sum();
    }

    public Conjunction<T> get(int index) {
        if ( index < 0 || index >= cubes.size()) {
            return Conjunction.FALSE();
        }
        return cubes.getUnsafe(index);
    }

    public void clear() {
        cubes.clear();
    }

    public int getCubeSize() {
        return cubes.size();
    }
    
    public SortedCubeSet() {
        this(new DefaultCubeComparator<>());
    }

    public SortedCubeSet(int capacity){
        this(capacity, new DefaultCubeComparator<>());
    }
    public SortedCubeSet(Comparator<Conjunction<T>> comparator){
        this(INITIALCAPACITY, comparator);
    }
    
    public SortedCubeSet(int initialCapacity, Comparator<Conjunction<T>> comparator) {
        cubes = new Vect<>(initialCapacity);
        this.comparator = comparator;
    }

    private void checkTriviality() {
        if (cubes.isEmpty()) {
            return;
        }
        
        int i = 0;
        while (i < cubes.size() && cubes.get(i).isFalse()) {
            i++;
        }
        cubes.removeBulkUnsafe(0, i);
        if (!cubes.isEmpty() && cubes.getFirst().isTrue()) {
            cubes.clear();
            cubes.appendUnsafe(Conjunction.TRUE());
        }
    }


    public boolean add(Conjunction<T> clause) {
        if (clause.isFalse()) {
            return false;
        } else if (clause.isTrue()) {
            cubes.clear();
            cubes.appendUnsafe(Conjunction.TRUE());
            return true;
        }
        cubes.ensureCapacity(1, 3);
        cubes.insertSortedUniqueUnsafe(clause, comparator);
        return true;
    }

    public void addAll(SortedCubeSet<T> other) {
        cubes.ensureCapacity(other.getCubeSize(), 10);
        cubes.addAll(other.cubes);
        cubes.sort(comparator);
        checkTriviality();
    }

    public void addAll(Collection<Conjunction<T>> col) {
        cubes.ensureCapacity(col.size(), 10);
        cubes.addAll(col);
        cubes.sort(comparator);
        checkTriviality();
    }

    // Performs simple simplification to remove dominated clauses.
    // Should be highly performant
    // Assumes that clauses are ordered such that dominated clauses appear later (e.g. by sorting by size)
    public void simplify() {
        for (int i = 0; i < cubes.size(); i++){
            Conjunction<T> cube1 = cubes.get(i);
            cubes.removeIf(i, cubes.size(), cube1::isProperSubclauseOf);
        }
    }

    public boolean contains(Conjunction<T> clause) {
        return cubes.binarySearch(clause, comparator) > -1;
    }

    public boolean remove(Conjunction<T> clause) {
        return cubes.remove(clause);
    }

    // Removes clauses which contain certain literals
    public boolean removeIf(Predicate<T> literalPredicate) {
        return cubes.removeIf(x -> x.getLiterals().stream().anyMatch(literalPredicate));
    }

    public SortedCubeSet<T> or(SortedCubeSet<T> other) {
        if (this.isTrue() || other.isFalse() || this == other) {
            return this;
        } else if (this.isFalse()) {
            this.cubes = other.cubes.clone();
        } else if (other.isTrue()) {
            this.cubes = TRUE.cubes.clone();
        } else {
            this.cubes.ensureCapacity(other.cubes.size());
            if (other.comparator.equals(this.comparator)) {
                this.cubes.mergeUnsafe(other.cubes, comparator);
            } else {
                this.cubes.addAll(other.cubes);
                this.cubes.sort(comparator);
            }
        }
        return this;
    }

    public SortedCubeSet<T> and(SortedCubeSet<T> other) {
        if (this.isFalse() || other.isTrue()) {
            return this;
        } else if (this.isTrue()) {
            cubes = other.cubes.clone();
        } else if (other.isFalse()) {
            cubes.clear();
        } else {
            Vect<Conjunction<T>> result = new Vect<>(this.cubes.size() * other.cubes.size());
            for (int i = 0; i < this.cubes.size(); i++) {
                for (int j = 0; j < other.cubes.size(); j++) {
                    result.appendUnsafe(cubes.get(i).and(other.cubes.get(j)));
                }
            }
            cubes = result;
            cubes.sort(comparator);
        }
        return this;
    }

    public DNF<T> toDNF() {
        return new DNF<T>(cubes);
    }

    @Override
    public Iterator<Conjunction<T>> iterator() {
        return cubes.iterator();
    }


    // Mainly compares by size.
    private static class DefaultCubeComparator<Y extends Literal<Y>> implements Comparator<Conjunction<Y>> {

        @Override
        public int compare(Conjunction<Y> o1, Conjunction<Y> o2) {
            if (o1.equals(o2)) {
                return 0;
            }
            int cmp = o1.getSize() - o2.getSize();
            return cmp != 0 ? cmp : (System.identityHashCode(o1) - System.identityHashCode(o2));
            // The second case it needed to satisfy the contract of Comparable (it gives a total ordering)
            // Violating the contract can cause exceptions!

        }
    }
}
