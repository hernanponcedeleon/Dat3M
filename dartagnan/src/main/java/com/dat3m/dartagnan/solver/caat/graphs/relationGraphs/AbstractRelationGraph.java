package com.dat3m.dartagnan.solver.caat.graphs.relationGraphs;

import com.dat3m.dartagnan.solver.caat.util.GraphVisitor;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;

public abstract class AbstractRelationGraph implements RelationGraph {

    protected ExecutionModel model;
    protected VerificationTask task;
    protected String name = null;

    public AbstractRelationGraph() { }

    @Override
    public ExecutionModel getModel() {
        return model;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    @Override
    public void constructFromModel(ExecutionModel model) {
        this.model = model;
        this.task = model.getTask();
    }

    @Override
    public String toString() {
        return (name != null ? name : super.toString()) + ": " + size();
    }

    @Override
    public Collection<Edge> forwardPropagate(RelationGraph changedGraph, Collection<Edge> addedEdges) {
        return Collections.emptyList();
    }

    @Override
    public void backtrackTo(int time) {
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
