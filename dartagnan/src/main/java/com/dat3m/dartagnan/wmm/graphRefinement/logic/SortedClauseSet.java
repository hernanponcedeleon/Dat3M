package com.dat3m.dartagnan.wmm.graphRefinement.logic;

import com.dat3m.dartagnan.wmm.graphRefinement.dataStructures.Vect;
import com.dat3m.dartagnan.wmm.graphRefinement.util.CompareAdapter;

import java.util.*;
import java.util.function.Predicate;

public class SortedClauseSet<T extends Literal<T>> implements Iterable<Conjunction<T>> {

    private static final int INITIALCAPACITY = 10;

    public static final SortedClauseSet FALSE = new SortedClauseSet(0);
    public static final SortedClauseSet TRUE = new SortedClauseSet(1);

    static {
        TRUE.clauses.append(Conjunction.TRUE);
    }

    
    protected Vect<Conjunction<T>> clauses;
    protected Comparator<Conjunction<T>> comparator;

    public List<Conjunction<T>> getClauses() {
        return Collections.unmodifiableList(clauses);
    }

    public boolean isFalse() {
        return clauses.isEmpty();
    }

    public boolean isTrue() {
        return !clauses.isEmpty() && clauses.getFirstUnsafe().isTrue();
    }

    public int getLiteralSize() {
        int size = 0;
        for (Conjunction<T> cube : clauses)
            size += cube.getSize();
        return size;
    }

    public Conjunction<T> get(int index) {
        if ( index < 0 || index >= clauses.size())
            return Conjunction.FALSE;
        return clauses.getUnsafe(index);
    }

    public void clear() {
        clauses.clear();
    }

    public int getClauseSize() {
        return clauses.size();
    }
    
    public SortedClauseSet() {
        this(new DefaultClauseComparator<>());
    }

    public SortedClauseSet(int capacity){
        this(capacity, new DefaultClauseComparator<>());
    }
    public SortedClauseSet(Comparator<Conjunction<T>> comparator){
        this(INITIALCAPACITY, comparator);
    }
    
    public SortedClauseSet(int initialCapacity, Comparator<Conjunction<T>> comparator) {
        clauses = new Vect<>(initialCapacity);
        this.comparator = comparator;
    }


    private SortedClauseSet(boolean init) {

    }

    private void checkTriviality() {
        if (clauses.isEmpty())
            return;
        
        int i = 0;
        while (i < clauses.size() && clauses.get(i).isFalse()) {
            i++;
        }
        clauses.removeBulkUnsafe(0, i);
        if (!clauses.isEmpty() && clauses.getFirst().isTrue())
        {
            clauses.clear();
            clauses.appendUnsafe(Conjunction.TRUE);
        }
    }


    public boolean add(Conjunction<T> clause) {
        if (clause.isFalse())
            return false;
        else if (clause.isTrue()) {
            clauses.clear();
            clauses.appendUnsafe(Conjunction.TRUE);
            return true;
        }
        clauses.ensureCapacity(1, 3);
        clauses.insertSortedUniqueUnsafe(clause, comparator);
        return true;
    }

    public void addAll(SortedClauseSet<T> other) {
        clauses.addAll(other.clauses);
        clauses.sort(comparator);
        checkTriviality();
    }

    // Performs simple simplification to remove dominated clauses.
    // Should be highly performant
    // Assumes that clauses are ordered such that dominated clauses appear later (e.g. by sorting by size)
    public void simplify() {
        for (int i = 0; i < clauses.size(); i++){
            Conjunction<T> cube1 = clauses.get(i);
            clauses.removeIf(i, clauses.size(), cube1::isProperSubclauseOf);
        }
    }

    public boolean contains(Conjunction<T> clause) {
        return clauses.binarySearch(clause) > -1;
        //return clauses.contains(clause);
    }

    public boolean remove(Conjunction<T> clause) {
        return clauses.remove(clause);
    }

    public boolean removeWhere(Predicate<T> literalPredicate) {
        return clauses.removeIf(x -> x.getLiterals().stream().anyMatch(literalPredicate));
    }

    public SortedClauseSet<T> or(SortedClauseSet<T> other) {
        if (this.isTrue() || other.isFalse() || this == other)
            return this;
        else if (this.isFalse()) {
            this.clauses = other.clauses.clone();
        } else if (other.isTrue()) {
            this.clauses = TRUE.clauses.clone();
        } else {
            this.clauses.ensureCapacity(other.clauses.size());
            if (other.comparator.equals(this.comparator))
                this.clauses.mergeUnsafe(other.clauses, comparator);
            else {
                this.clauses.addAll(other.clauses);
                this.clauses.sort(comparator);
            }
        }
        return this;
    }

    public SortedClauseSet<T> and(SortedClauseSet<T> other) {
        if (this.isFalse() || other.isTrue())
            return this;
        else if (this.isTrue())
            clauses = other.clauses.clone();
        else if (other.isFalse())
            clauses.clear();
        else {
            Vect<Conjunction<T>> result = new Vect<>(this.clauses.size() * other.clauses.size());
            for (int i = 0; i < this.clauses.size(); i++) {
                for (int j = 0; j < other.clauses.size(); j++) {
                    result.appendUnsafe(clauses.get(i).and(other.clauses.get(j)));
                }
            }
            clauses = result;
            clauses.sort(comparator);
        }
        return this;
    }

    public SortedClauseSet<T> computeAllResolvents() {
        Vect<Conjunction<T>> result = clauses.clone();
        result.ensureTotalCapacity(2 * clauses.size());
        HashSet<CompareAdapter<Conjunction<T>>> foundClauses = new HashSet<>(result.getTotalCapacity());
        for (int i = 0; i < result.size(); i++) {
            foundClauses.add(new CompareAdapter<>(result.get(i), comparator));
        }

        int to = result.size();
        int start = 0;
        do {
            for (int i = 0; i < to; i++) {
                for (int j = Math.max(start, i + 1); j < to; j++) {
                    Conjunction<T> resolvent = result.get(i).resolve(result.get(j));
                    if (!resolvent.isFalse() && foundClauses.add(new CompareAdapter<>(resolvent, comparator))) {
                        result.ensureCapacity(1, result.size());
                        result.appendUnsafe(resolvent);
                    }
                }
            }
            start = to;
            to = result.size();
        } while (start != to);
        result.sort(comparator);
        SortedClauseSet<T> retVal = new SortedClauseSet<>(false);
        retVal.clauses = result;
        retVal.comparator = comparator;
        //retVal.simplify(); Not needed since we delete
        return retVal;
    }


    @Override
    public Iterator<Conjunction<T>> iterator() {
        return clauses.iterator();
    }


    private static class DefaultClauseComparator<Y extends Literal<Y>> implements Comparator<Conjunction<Y>> {

        @Override
        public int compare(Conjunction<Y> o1, Conjunction<Y> o2) {
            int cmp = o1.getSize() - o2.getSize();
            if (cmp == 0) {
                cmp = o1.hashCode() - o2.hashCode();
                if (cmp == 0) {
                    return cmp;
                    // This implementation is not valid.
                    // We need to change conjunctions from sets to lists and perform lexicographic
                    // comparisons
                    //throw new UnsupportedOperationException();
                }
            }
            return cmp;

        }
    }
}
