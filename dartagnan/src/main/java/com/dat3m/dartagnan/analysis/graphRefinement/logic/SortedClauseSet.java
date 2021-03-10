package com.dat3m.dartagnan.analysis.graphRefinement.logic;

import com.dat3m.dartagnan.utils.collections.Vect;

import java.util.*;
import java.util.function.Predicate;

/*
   This class is a sorted list of clauses without duplicates.
   The sorting is done according to clause size.
   Unlike DNF, this class is mutable for performance reasons.
   Many methods modify the current instance and return it to allow chaining.
 */
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
        clauses.ensureCapacity(other.getClauseSize(), 10);
        clauses.addAll(other.clauses);
        clauses.sort(comparator);
        checkTriviality();
    }

    public void addAll(Collection<Conjunction<T>> col) {
        clauses.ensureCapacity(col.size(), 10);
        clauses.addAll(col);
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
        return clauses.binarySearch(clause, comparator) > -1;
        //return clauses.contains(clause);
    }

    public boolean remove(Conjunction<T> clause) {
        return clauses.remove(clause);
    }

    // Removes clauses which contain certain literals
    public boolean removeIf(Predicate<T> literalPredicate) {
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
        HashSet<Conjunction<T>> foundClauses = new HashSet<>(result.getTotalCapacity());
        //HashSet<CompareAdapter<Conjunction<T>>> foundClauses = new HashSet<>(result.getTotalCapacity());
        /*for (int i = 0; i < result.size(); i++) {
            //foundClauses.add(new CompareAdapter<>(result.get(i), comparator));
            foundClauses.add(result.get(i));
        }*/
        foundClauses.addAll(result);

        int to = result.size();
        int start = 0;
        do {
            for (int i = 0; i < to; i++) {
                for (int j = Math.max(start, i + 1); j < to; j++) {
                    Conjunction<T> resolvent = result.get(i).resolve(result.get(j));
                    if (!resolvent.isFalse() && foundClauses.add(resolvent)) {
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
        return retVal;
    }

    // A fast version of the above algorithm
    // It aims to compute only resolvents that cannot be further resolved (have no resolvable literal)
    //TODO: Rework this to make it work in all cases.
    public SortedClauseSet<T> computeProductiveResolvents() {
        Vect<Conjunction<T>> result = clauses.clone();
        // Delete unnecessary clauses
        deleteUnproductiveClauses(result);

        Comparator<Conjunction<T>> resComp = new ResolventClauseComparator<>();
        result.sortUnique(resComp);

        result.ensureTotalCapacity(2 * result.size());
        HashSet<Conjunction<T>> foundClauses = new HashSet<>(result.getTotalCapacity());
        foundClauses.addAll(result);

        // A custom (test) implementation that only resolves clauses where one clause
        // has a single resolvable literal (may break, if k-SAT with k>1 was used to find clauses)
        int to;
        int start = 0;
        int co1Index = 0;
        do {
            start = start + co1Index;
            to = result.size();
            result.sort(start, to, resComp);
            co1Index = 0;
            for (int i = start; i < to; i++) {
                if(result.get(i).getResolutionComplexity() < 2) {
                    co1Index++;
                } else {
                    break;
                }
            }

            for (int i = start; i < start + co1Index; i++) {
                for (int j = i + 1; j < to; j++) {
                    Conjunction<T> resolvent = result.get(i).resolve(result.get(j));
                    if (!resolvent.isFalse() && foundClauses.add(resolvent)) {
                        result.ensureCapacity(1, result.size());
                        result.appendUnsafe(resolvent);
                    }
                }
                to = result.size();
            }
        } while (co1Index != 0);

        result.sort(comparator);
        SortedClauseSet<T> retVal = new SortedClauseSet<>(false);
        retVal.clauses = result;
        retVal.comparator = comparator;
        return retVal;
    }

    // Removes all clauses that contain some resolvable literal which can not be resolved
    // with any other clause.
    private void deleteUnproductiveClauses(Vect<Conjunction<T>> vect) {
        boolean progress;
        do {
            HashSet<T> resolvableLiterals = new HashSet<>();
            for (Conjunction<T> cube : vect) {
                cube.getLiterals().stream().filter(Literal::hasOpposite).forEach(resolvableLiterals::add);
            }

            progress = vect.removeIf(x -> x.getLiterals().stream()
                    .filter(Literal::hasOpposite)
                    .anyMatch(y -> !resolvableLiterals.contains(y.getOpposite())));
        } while (progress);
    }

    public DNF<T> toDNF() {
        return new DNF<T>(clauses);
    }




    @Override
    public Iterator<Conjunction<T>> iterator() {
        return clauses.iterator();
    }



    private static class DefaultClauseComparator<Y extends Literal<Y>> implements Comparator<Conjunction<Y>> {

        @Override
        public int compare(Conjunction<Y> o1, Conjunction<Y> o2) {
            if (o1 == o2)
                return 0;
            int cmp = o1.getSize() - o2.getSize();
            return cmp != 0 ? cmp : (System.identityHashCode(o1) - System.identityHashCode(o2));
            // The second case it needed to satisfy the contract of Comparable (it gives a total ordering)
            // Violating the contract can cause exceptions!

        }
    }

    private static class ResolventClauseComparator<Y extends Literal<Y>> implements Comparator<Conjunction<Y>> {

        @Override
        public int compare(Conjunction<Y> o1, Conjunction<Y> o2) {
            if (o1 == o2)
                return 0;
            int cmp = o1.getResolutionComplexity() - o2.getResolutionComplexity();
            if (cmp == 0) {
                cmp = o1.getSize() - o2.getSize();
            }
            return cmp != 0 ? cmp : (System.identityHashCode(o1) - System.identityHashCode(o2));
            // The second case it needed to satisfy the contract of Comparable (it gives a total ordering)
            // Violating the contract can cause exceptions!

        }
    }
}
