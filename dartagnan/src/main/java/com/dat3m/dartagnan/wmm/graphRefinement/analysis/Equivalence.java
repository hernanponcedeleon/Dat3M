package com.dat3m.dartagnan.wmm.graphRefinement.analysis;

import com.dat3m.dartagnan.program.event.Event;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public abstract class Equivalence<T> {

    protected Map<T, Representative> representativeMap;
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
