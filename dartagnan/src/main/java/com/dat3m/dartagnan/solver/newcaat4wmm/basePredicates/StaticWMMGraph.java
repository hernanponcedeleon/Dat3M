package com.dat3m.dartagnan.solver.newcaat4wmm.basePredicates;

import com.dat3m.dartagnan.solver.newcaat.domain.Domain;
import com.dat3m.dartagnan.solver.newcaat.misc.EdgeDirection;
import com.dat3m.dartagnan.solver.newcaat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.verification.model.ExecutionModel;


public abstract class StaticWMMGraph extends AbstractWMMGraph {
    protected int size;
    protected ExecutionModel model;

    @Override
    public Edge get(Edge edge) {
        return contains(edge) ? edge.with(0, 0) : null;
    }

    @Override
    public boolean contains(Edge edge) {
        return containsById(edge.getFirst(), edge.getSecond());
    }

    @Override
    public int size() {
        return size;
    }

    @Override
    public int getEstimatedSize() { return size; }

    @Override
    public void backtrackTo(int time) { }

    @Override
    public void initializeToDomain(Domain<?> domain) {
        super.initializeToDomain(domain);
        size = 0;
    }

    protected final void autoComputeSize() {
        size = 0;
        for (int i = 0; i < domain.size(); i++) {
            size += size(i, EdgeDirection.OUTGOING);
        }
    }

}
