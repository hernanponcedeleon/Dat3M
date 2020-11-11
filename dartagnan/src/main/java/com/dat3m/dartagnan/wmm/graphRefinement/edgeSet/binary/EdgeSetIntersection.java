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

public class EdgeSetIntersection extends EdgeSetAbstract {
    protected EdgeSet first;
    protected EdgeSet second;

    public EdgeSetIntersection(RelationData rel, EdgeSet first, EdgeSet second) {
        super(rel);
        this.first = first;
        this.second = second;
    }

    @Override
    public Set<Edge> update(EdgeSet changedSet, Set<Edge> addedEdges, int time) {
        if (changedSet != first && changedSet != second)
            return Collections.EMPTY_SET;
        EdgeSet other = changedSet == first ? second : first;
        Set<Edge> updatedEdges = new HashSet<>(addedEdges.size());

        for (Edge edge : addedEdges)
            if (other.contains(edge)) {
                if (add(edge, time)) {
                    updatedEdges.add(edge);
                    /*ReasonGraph.Node node = reasonGraph.addNode(this, edge, time);
                    node.addReason(reasonGraph.getNode(first, edge), reasonGraph.getNode(second, edge));*/
                }
            }
        return updatedEdges;
    }

    @Override
    public Conjunction<CoreLiteral> computeShortestReason(Edge edge) {
        if (!this.contains(edge))
            return Conjunction.FALSE;
        return first.computeShortestReason(edge).and(second.computeShortestReason(edge));
    }
}
