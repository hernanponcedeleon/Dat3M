package com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.unary;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.graphRefinement.GraphContext;
import com.dat3m.dartagnan.wmm.graphRefinement.ReasonGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.EventLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.EventData;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationData;
import com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.EdgeSet;
import com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.EdgeSetAbstract;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

public class EdgeSetReflexive extends EdgeSetAbstract {
    protected EdgeSet inner;

    public EdgeSetReflexive(RelationData rel, EdgeSet inner) {
        super(rel);
        this.inner = inner;
    }

    @Override
    public Set<Edge> initialize(GraphContext context) {
        super.initialize(context);
        Set<Edge> updatedEdges = new HashSet<>();
        for (EventData e : context.getEventList()) {
            updatedEdges.add(new Edge(e, e));
        }
        addAll(updatedEdges, 0);
        return updatedEdges;
    }

    @Override
    public Set<Edge> update(EdgeSet changedSet, Set<Edge> addedEdges, int time) {
        if (changedSet != inner)
            return Collections.EMPTY_SET;
        Set<Edge> updatedEdges = addAll(addedEdges, time);
        /*for (Edge edge : updatedEdges) {
            ReasonGraph.Node node = reasonGraph.addNode(this, edge, time);
            node.addReason(reasonGraph.getNode(changedSet, edge));
        }*/
        return updatedEdges;
    }

    @Override
    public Conjunction<CoreLiteral> computeShortestReason(Edge edge) {
        if (!this.contains(edge))
            return Conjunction.FALSE;
        if (edge.getFirst().equals(edge.getSecond()))
            return new Conjunction<>(new EventLiteral(edge.getFirst()));
        return inner.computeShortestReason(edge);
    }
}
