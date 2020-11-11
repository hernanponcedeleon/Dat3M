package com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.binary;


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

public class EdgeSetUnion extends EdgeSetAbstract {
    protected EdgeSet first;
    protected EdgeSet second;

    public EdgeSetUnion(RelationData rel, EdgeSet first, EdgeSet second) {
        super(rel);
        this.first = first;
        this.second = second;
    }

    @Override
    public Set<Edge> update(EdgeSet changedSet, Set<Edge> addedEdges, int time) {
        if (changedSet != first && changedSet != second)
            return Collections.EMPTY_SET;

        Set<Edge> updatedEdges = new HashSet<>();
        for (Edge edge : addedEdges) {
            if (this.add(edge, time))
                updatedEdges.add(edge);
            // Add reasons even if the added edge was already there
            /*ReasonGraph.Node node = reasonGraph.addNode(this, edge, time);
            node.addReason(reasonGraph.getNode(changedSet, edge));*/
        }
        return updatedEdges;
    }

    @Override
    public Conjunction<CoreLiteral> computeShortestReason(Edge edge) {
        if (!this.contains(edge))
            return Conjunction.FALSE;
        if (first.contains(edge))
            return first.computeShortestReason(edge);
        return second.computeShortestReason(edge);
    }
}
