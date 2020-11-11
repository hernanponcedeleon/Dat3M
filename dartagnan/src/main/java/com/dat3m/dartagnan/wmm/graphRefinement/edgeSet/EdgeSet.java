package com.dat3m.dartagnan.wmm.graphRefinement.edgeSet;

import com.dat3m.dartagnan.wmm.graphRefinement.GraphContext;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.EventData;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationData;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;

import java.util.Collections;
import java.util.Iterator;
import java.util.Set;

public interface EdgeSet {
    RelationData getRelation();
    boolean contains(Edge edge);
    Set<Edge> update(EdgeSet changedSet, Set<Edge> addedEdges, int time);

    void forgetHistory(int from);
    void mergeHistory(int mergePoint);

    default Set<Edge> initialize(GraphContext context) { return Collections.emptySet(); }

    Iterator<Edge> edgeIterator();
    Iterator<Edge> inEdgeIterator(EventData e);
    Iterator<Edge> outEdgeIterator(EventData e);

    Conjunction<CoreLiteral> computeShortestReason(Edge edge);

}
