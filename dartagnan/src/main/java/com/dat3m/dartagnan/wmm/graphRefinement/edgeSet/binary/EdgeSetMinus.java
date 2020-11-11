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

public class EdgeSetMinus extends EdgeSetAbstract {
    protected EdgeSet first;
    protected EdgeSet second;

    public EdgeSetMinus(RelationData rel, EdgeSet first, EdgeSet second) {
        super(rel);
        this.first = first;
        this.second = second;
    }

    @Override
    public Set<Edge> update(EdgeSet changedSet, Set<Edge> addedEdges, int time) {
        if (changedSet == second)
            return Collections.EMPTY_SET; // This should only happen during initialization!!!
        if (changedSet != first)
            return Collections.EMPTY_SET;

        Set<Edge> updatedEdges = new HashSet<>();
        for (Edge edge : addedEdges)
            if (!second.contains(edge)) {
                if (!add(edge, time))
                    throw new RuntimeException("This should never happen"); // Just for testing
                updatedEdges.add(edge);
                /*ReasonGraph.Node node = reasonGraph.addNode(this, edge, time);
                node.addReason(reasonGraph.getNode(changedSet, edge));*/
            }
        return updatedEdges;
    }

    @Override
    public Conjunction<CoreLiteral> computeShortestReason(Edge edge) {
        if (!this.contains(edge))
            return Conjunction.FALSE;
        return first.computeShortestReason(edge);
    }
}
