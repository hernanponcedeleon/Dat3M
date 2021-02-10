package com.dat3m.dartagnan.wmm.graphRefinement.analysis;

import java.util.*;
import java.util.stream.Collectors;

public abstract class AbstractEquivalence<T> implements Equivalence<T> {

    //  Maps each object <o> to its class representative
    protected Map<T, Representative> representativeMap;
    // Maps each representative <r> to its represented class class(r)
    protected Map<Representative, Set<T>> classMap;

    public void makeRepresentative(T x) {
        representativeMap.get(x).setRepresentative(x);
    }
    public T getRepresentative(T x) {
        return representativeMap.get(x).getRepresentative();
    }
    public Set<T> getEquivalenceClass(T x) {
        return classMap.get(representativeMap.get(x));
    }
    public boolean areEquivalent(T x, T y) {
        return representativeMap.get(x).equals(representativeMap.get(y));
    }

    @Override
    public Collection<Set<T>> getAllEquivalenceClasses() {
        return classMap.values();
    }

    @Override
    public Collection<T> getAllRepresentatives() {
        return classMap.keySet().stream().map(Representative::getRepresentative).collect(Collectors.toList());
    }

    public AbstractEquivalence() {
        representativeMap = new HashMap<>();
        classMap = new HashMap<>();
    }

    protected AbstractEquivalence(int estimatedDataSize, int estimatedNumOfClasses) {
        representativeMap = new HashMap<>(estimatedDataSize);
        classMap = new HashMap<>(estimatedNumOfClasses);
    }

    protected Representative makeNewClass(T x, int initialCapacity) {
        Representative rep = new Representative(x);
        HashSet<T> classSet = new HashSet<>(initialCapacity);
        classSet.add(x);
        representativeMap.put(x, rep);
        classMap.put(rep, classSet);
        return rep;
    }

    protected void addToClass(T x, Representative classRep) {
        Representative oldRep = representativeMap.put(x, classRep);
        if (oldRep != null) {
            // <x> was in a different class before
            classMap.get(oldRep).remove(x);
        }
        classMap.get(classRep).add(x);
    }

    protected void addAllToClass(Collection<T> col, Representative classRep) {
        for (T x : col) {
            Representative oldRep = representativeMap.put(x, classRep);
            if (oldRep != null) {
                // <x> was in a different class before
                classMap.get(oldRep).remove(x);
            }
        }
        classMap.get(classRep).addAll(col);
    }


    // NOTE: We intentionally do NOT implement hashCode() and equals()
    // If we did, we would break the classMap when changing the representative element of a class.
    protected class Representative {
        private T representative;

        public T getRepresentative() { return representative; }
        private void setRepresentative(T representative) { this.representative = representative; }

        public Representative(T representative) {
            this.representative = representative;
        }

        public Set<T> getEquivalenceClass() {
            return classMap.get(this);
        }
    }
}
