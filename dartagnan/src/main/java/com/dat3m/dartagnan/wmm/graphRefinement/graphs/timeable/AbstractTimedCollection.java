package com.dat3m.dartagnan.wmm.graphRefinement.graphs.timeable;

import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.EventGraph;

public abstract class AbstractTimedCollection<T extends Timeable> implements ITimedCollection<T> {

    protected Timestamp maxTime;
    protected int minSize;

    protected AbstractTimedCollection() {
        maxTime = Timestamp.ZERO;
        minSize = 0;
    }

    public int getMinSize() { return minSize; }
    public abstract int getMaxSize();

    public int getEstimatedSize() {
        return maxTime.isValid() ? getMaxSize() : (getMinSize() + getMaxSize() + 1) >> 1;
    }

    @Override
    public boolean add(T t) {
        if (t.isInvalid())
            return false;
        else if (t.isInitial())
            minSize++;
        else
            maxTime = Timestamp.max(maxTime, t.getTime());
        return true;
    }

    @Override
    public void clear() {
        minSize = 0;
        maxTime = Timestamp.ZERO;
    }
}
