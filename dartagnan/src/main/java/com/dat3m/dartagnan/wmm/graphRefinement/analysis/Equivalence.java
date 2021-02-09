package com.dat3m.dartagnan.wmm.graphRefinement.analysis;

import com.dat3m.dartagnan.program.event.Event;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public abstract class Equivalence<T> {

    //  Maps each object <o> to its class representative
    protected Map<T, Representative> representativeMap;
    // Maps each representative <r> to its represented class class(r)
    protected Map<Representative, Set<T>> classMap;

    public void setRepresentative(T x) {
        representativeMap.get(x).setData(x);
    }
    public T getRepresentative(T x) {
        return representativeMap.get(x).getData();
    }

    public Set<T> getEquivalenceClass(T x) {
        return classMap.get(representativeMap.get(x));
    }

    public boolean areEquivalent(T x, T y) {
        return representativeMap.get(x).equals(representativeMap.get(y));
    }
    public Set<Representative> getRepresentatives() {
        return classMap.keySet();
    }

    public Equivalence() {
        representativeMap = new HashMap<>();
        classMap = new HashMap<>();
    }

    private Equivalence(int estimatedDataSize, int estimatedNumOfClasses) {
        representativeMap = new HashMap<>(estimatedDataSize);
        classMap = new HashMap<>(estimatedNumOfClasses);
    }


    // NOTE: We intentionally do NOT implement hashCode() and equals()
    // If we did, we would break the classMap when changing the representative element of a class.
    public class Representative {
        private T data;

        public T getData() { return data; }
        private void setData(T data) { this.data = data; }

        public Representative(T data) {
            this.data = data;
        }

        public Set<T> getEquivalenceClass() {
            return classMap.get(this);
        }
    }
}
