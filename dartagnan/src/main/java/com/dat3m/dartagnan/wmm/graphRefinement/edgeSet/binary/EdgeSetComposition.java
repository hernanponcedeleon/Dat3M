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

public class EdgeSetComposition extends EdgeSetAbstract {
    protected EdgeSet first;
    protected EdgeSet second;

    public EdgeSetComposition(RelationData rel, EdgeSet first, EdgeSet second) {
        super(rel);
        this.first = first;
        this.second = second;
    }

    @Override
    public Set<Edge> update(EdgeSet changedSet, Set<Edge> addedEdges, int time) {
        if (changedSet != first && changedSet != second)
            return Collections.EMPTY_SET;

        if (changedSet == first && changedSet != second)
            return updateFirst(addedEdges, time);
        if (changedSet == second && changedSet != first)
            return updateSecond(addedEdges, time);

        /* TODO: Make sure that this case is correct
        // TODO: There seems to be a mistake in the reason computation. We fix this later
        right now we add "addedEdges;addedEdges" twice*/
        Set<Edge> updatedEdges = updateFirst(addedEdges, time);
        updatedEdges.addAll(updateSecond(addedEdges, time));
        return updatedEdges;
    }

    private Set<Edge> updateFirst(Set<Edge> addedEdges, int time) {
        Set<Edge> updatedEdges = new HashSet<>();
        for (Edge edge : addedEdges) {
            Iterator<Edge> outEdges = second.outEdgeIterator(edge.getSecond());
            while (outEdges.hasNext()) {
                Edge outEdge = outEdges.next();
                Edge newEdge = new Edge(edge.getFirst(), outEdge.getSecond());
                if (add(newEdge, time))
                    updatedEdges.add(newEdge);
                /*ReasonGraph.Node node = reasonGraph.addNode(this, newEdge, time);
                node.addReason(reasonGraph.getNode(first, edge), reasonGraph.getNode(second, outEdge));*/
            }
        }
        return updatedEdges;
    }

    private Set<Edge> updateSecond(Set<Edge> addedEdges, int time) {
        Set<Edge> updatedEdges = new HashSet<>();
        for (Edge edge : addedEdges) {
            Iterator<Edge> inEdges = first.inEdgeIterator(edge.getFirst());
            while (inEdges.hasNext()) {
                Edge inEdge = inEdges.next();
                Edge newEdge = new Edge(inEdge.getFirst(), edge.getSecond());
                if (add(newEdge, time))
                    updatedEdges.add(newEdge);
                /*ReasonGraph.Node node = reasonGraph.addNode(this, newEdge, time);
                node.addReason(reasonGraph.getNode(first, inEdge), reasonGraph.getNode(second, edge));*/
            }
        }
        return updatedEdges;
    }

    @Override
    public Conjunction<CoreLiteral> computeShortestReason(Edge edge) {
        if (!this.contains(edge))
            return Conjunction.FALSE;
        Iterator<Edge> outEdges = first.outEdgeIterator(edge.getFirst());
        while (outEdges.hasNext()) {
            Edge outEdge = outEdges.next();
            Edge link = new Edge(outEdge.getSecond(), edge.getSecond());
            if (second.contains(link))
                return first.computeShortestReason(outEdge).and(second.computeShortestReason(link));
        }
        return Conjunction.FALSE;
    }
}
