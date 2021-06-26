package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph;

import com.dat3m.dartagnan.analysis.graphRefinement.util.GraphVisitor;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Collection;
import java.util.Iterator;

public abstract class AbstractEventGraph implements EventGraph {

    protected ExecutionModel context;
    protected VerificationTask task;
    protected String name = null;

    public AbstractEventGraph() {
    }

    @Override
    public ExecutionModel getModel() {
        return context;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    @Override
    public void constructFromModel(ExecutionModel context) {
        this.context = context;
        this.task = context.getVerificationTask();
    }

    @Override
    public String toString() {
        return name != null ? name : super.toString();
    }

    @Override
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {
        addedEdges.clear();
        return addedEdges;
    }

    @Override
    public void backtrack() {
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visit(this, data, context);
    }


    @Override
    public int size() {
        int i = 0;
        for (Edge e : this) {
            i++;
        }
        return i;
    }

    @Override
    public boolean isEmpty() {
        return getEstimatedSize() == 0;
    }

    @Override
    public Iterator<Edge> iterator() {
        return edgeIterator();
    }



}
