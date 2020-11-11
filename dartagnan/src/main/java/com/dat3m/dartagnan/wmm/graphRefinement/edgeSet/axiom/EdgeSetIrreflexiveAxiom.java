package com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.axiom;

import com.dat3m.dartagnan.wmm.graphRefinement.ReasonGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationData;
import com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.EdgeSet;
import com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.EdgeSetAbstract;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

// All edges contained in this set are to be considered "violating"
// In other words, this set is the reflexive interior of the axioms relation.
public class EdgeSetIrreflexiveAxiom extends EdgeSetAbstract {
    protected EdgeSet inner;

    public EdgeSetIrreflexiveAxiom(RelationData relation, EdgeSet inner) {
        super(relation);
        this.inner = inner;
    }

    @Override
    public Set<Edge> update(EdgeSet changedSet, Set<Edge> addedEdges, int time) {
        if (changedSet != inner)
            return Collections.EMPTY_SET;

        Set<Edge> updatedEdges = new HashSet<>();
        for (Edge edge : addedEdges) {
            if (edge.getFirst().equals(edge.getSecond()) && add(edge, time)) {
                updatedEdges.add(edge);
                /*ReasonGraph.Node node = reasonGraph.addNode(this, edge, time);
                node.addReason(reasonGraph.getNode(inner, edge));*/
                //return updatedEdges; // TEST CODE TO RETURN THE FIRST VIOLATION
            }
        }
        return  updatedEdges;
    }

    @Override
    public Conjunction<CoreLiteral> computeShortestReason(Edge edge) {
        if (!contains(edge))
            return Conjunction.FALSE;
        return inner.computeShortestReason(edge);
    }
}