package com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.utils.iteration;

import java.util.Collection;
import java.util.Iterator;

/*
    TODO: This iterator should ideally be used via try-finally to guarantee a return to the IteratorPool.
 */
public abstract class ReusableIterator<T, V extends Collection<T>> implements Iterator<T>, AutoCloseable {
    protected final IteratorPool<T, V> pool;
    protected boolean isInUse;

    public ReusableIterator(IteratorPool<T,V> pool) {
        this.pool = pool;
        this.isInUse = false;
    }

    public abstract void reuseFor(V collection);

    @Override
    public void close() {
        pool.returnToPool(this);
    }
}
