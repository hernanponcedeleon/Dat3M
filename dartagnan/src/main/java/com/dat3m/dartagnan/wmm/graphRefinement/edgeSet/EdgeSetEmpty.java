package com.dat3m.dartagnan.wmm.graphRefinement.edgeSet;

import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.EventData;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationData;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;

import java.util.Collections;
import java.util.Iterator;
import java.util.Set;

public class EdgeSetEmpty implements EdgeSet {
    private RelationData relationData;

    public EdgeSetEmpty(RelationData relation) {
        this.relationData = relation;
    }

    @Override
    public RelationData getRelation() {
        return relationData;
    }

    @Override
    public boolean contains(Edge edge) {
        return false;
    }

    @Override
    public Set<Edge> update(EdgeSet changedSet, Set<Edge> addedEdges, int time) {
        return Collections.EMPTY_SET;
    }

    @Override
    public void forgetHistory(int from) {

    }

    @Override
    public void mergeHistory(int mergePoint) {

    }

    @Override
    public Conjunction<CoreLiteral> computeShortestReason(Edge edge) {
        return Conjunction.FALSE;
    }

    @Override
    public Iterator<Edge> edgeIterator() {
        return Collections.EMPTY_SET.iterator();
    }

    @Override
    public Iterator<Edge> inEdgeIterator(EventData e) {
        return Collections.EMPTY_SET.iterator();
    }

    @Override
    public Iterator<Edge> outEdgeIterator(EventData e) {
        return Collections.EMPTY_SET.iterator();
    }
}
