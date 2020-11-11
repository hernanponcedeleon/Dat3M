package com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.unary;

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

public class EdgeSetInverse extends EdgeSetAbstract {
    protected EdgeSet inner;

    public EdgeSetInverse(RelationData rel, EdgeSet inner) {
        super(rel);
        this.inner = inner;
    }

    @Override
    public Set<Edge> update(EdgeSet changedSet, Set<Edge> addedEdges, int time) {
        if (changedSet != inner)
            return Collections.EMPTY_SET;

        Set<Edge> updatedEdges = new HashSet<>();
        for (Edge edge : addedEdges) {
            Edge newEdge = edge.getInverse();
            if (add(newEdge, time)) {
                updatedEdges.add(newEdge);
                /*ReasonGraph.Node node = reasonGraph.addNode(this, newEdge, time);
                node.addReason(reasonGraph.getNode(changedSet, edge));*/
            }
        }
        return updatedEdges;
    }

    @Override
    public Conjunction<CoreLiteral> computeShortestReason(Edge edge) {
        if (!this.contains(edge))
            return Conjunction.FALSE;
        return inner.computeShortestReason(edge.getInverse());
    }
}
