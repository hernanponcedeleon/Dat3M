package com.dat3m.dartagnan.wmm.graphRefinement.edgeSet;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.graphRefinement.GraphContext;
import com.dat3m.dartagnan.wmm.graphRefinement.ReasonGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.EventData;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationData;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import java.util.Collections;
import java.util.Iterator;
import java.util.Set;

public class EdgeSetRecursive implements EdgeSet {
    protected RelationData relation;
    protected EdgeSet inner;
    protected ReasonGraph reasonGraph;
    protected GraphContext context;

    @Override
    public RelationData getRelation() {
        return relation;
    }

    public EdgeSetRecursive(RelationData relation) {
        this.relation = relation;
    }

    public void setConcreteSet(EdgeSet concrete) {
        this.inner = concrete;
    }

    @Override
    public boolean contains(Edge edge) {
        return inner.contains(edge);
    }

    @Override
    public Set<Edge> update(EdgeSet changedSet, Set<Edge> addedEdges, int time) {
        return inner.update(this, addedEdges, time);
    }

    @Override
    public Conjunction<CoreLiteral> computeShortestReason(Edge edge) {
        return inner.computeShortestReason(edge);
    }

    @Override
    public void forgetHistory(int from) {
        inner.forgetHistory(from); // Should not be needed by also should not cause any harm
    }

    @Override
    public void mergeHistory(int mergePoint) {
        inner.mergeHistory(mergePoint);
    }


    @Override
    public Set<Edge> initialize(GraphContext context) {
        this.context = context;
        this.reasonGraph = context.getReasonGraph();
        return Collections.EMPTY_SET;
    }

    @Override
    public Iterator<Edge> edgeIterator() {
        return inner.edgeIterator();
    }

    @Override
    public Iterator<Edge> inEdgeIterator(EventData e) {
        return inner.inEdgeIterator(e);
    }

    @Override
    public Iterator<Edge> outEdgeIterator(EventData e) {
        return inner.outEdgeIterator(e);
    }

    @Override
    public String toString() {
        return inner.toString();
    }
}
