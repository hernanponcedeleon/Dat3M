package com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.stat;

import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.AbstractRelationGraph;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.solver.caat.util.EdgeDirection;
import com.dat3m.dartagnan.solver.caat.util.GraphVisitor;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

public abstract class StaticRelationGraph extends AbstractRelationGraph {
    protected int size;

    @Override
    public Optional<Edge> get(Edge edge) {
        return contains(edge) ? Optional.of(edge.with(0, 0)) : Optional.empty();
    }

    @Override
    public List<RelationGraph> getDependencies() {
        return Collections.emptyList();
    }

    @Override
    public int size() {
        return size;
    }

    @Override
    public int getMinSize() { return size; }

    @Override
    public int getMaxSize() { return size; }

    @Override
    public int getEstimatedSize() { return size; }

    @Override
    public abstract int getMinSize(EventData e, EdgeDirection dir);

    @Override
    public int getMaxSize(EventData e, EdgeDirection dir) {
        return getMinSize(e, dir);
    }

    @Override
    public int getEstimatedSize(EventData e, EdgeDirection dir) {
        return getMinSize(e, dir);
    }

    @Override
    public void backtrackTo(int time) { }

    @Override
    public void constructFromModel(ExecutionModel model) {
        super.constructFromModel(model);
        this.task = model.getTask();
        size = 0;
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitBase(this, data, context);
    }


    protected final void autoComputeSize() {
        size = 0;
        for (EventData e : model.getEventList()) {
            size += getMinSize(e, EdgeDirection.OUTGOING);
        }
    }

}
