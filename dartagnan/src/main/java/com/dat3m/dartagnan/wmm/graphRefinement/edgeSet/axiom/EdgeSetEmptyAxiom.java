package com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.axiom;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.graphRefinement.ReasonGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.EventData;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationData;
import com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.EdgeSet;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import java.util.Collections;
import java.util.Iterator;
import java.util.Set;

// Simply wraps another EdgeSet
// All edges contained in this set are to be considered "violating"
public class EdgeSetEmptyAxiom implements EdgeSet {
    protected RelationData relation;
    protected EdgeSet inner;
    protected ReasonGraph reasonGraph;

    @Override
    public RelationData getRelation() {
        return relation;
    }

    public EdgeSetEmptyAxiom(RelationData relation, EdgeSet inner) {
        this.relation = relation;
        this.inner = inner;
    }

    @Override
    public boolean contains(Edge edge) {
        return inner.contains(edge);
    }

    @Override
    public Set<Edge> update(EdgeSet changedSet, Set<Edge> addedEdges, int time) {
        if (changedSet != inner)
            return Collections.EMPTY_SET;
       /* for (Edge edge : addedEdges) {
            ReasonGraph.Node node = reasonGraph.addNode(this, edge, time);
            node.addReason(reasonGraph.getNode(inner, edge));
        }*/
        return addedEdges;
    }

    @Override
    public void forgetHistory(int from) {
        inner.forgetHistory(from); // Should not be needed but also should not cause any harm
    }

    @Override
    public void mergeHistory(int mergePoint) {
        inner.mergeHistory(mergePoint);
    }

    @Override
    public Conjunction<CoreLiteral> computeShortestReason(Edge edge) {
        return inner.computeShortestReason(edge);
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
        return  inner.toString();
    }
}
