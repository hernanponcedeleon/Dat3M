package com.dat3m.dartagnan.wmm.graphRefinement.edgeSet;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.graphRefinement.GraphContext;
import com.dat3m.dartagnan.wmm.graphRefinement.ReasonGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.EventLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationData;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import java.util.Set;

public class EdgeSetStatic extends EdgeSetAbstract {

    public EdgeSetStatic(RelationData rel) {
        super(rel);
    }

    @Override
    public Set<Edge> initialize(GraphContext context) {
        super.initialize(context);
        for (Tuple tuple : relation.getRelation().getEncodeTupleSet()) {
            Edge edge = context.getEdge(tuple);
            if (context.eventExists(edge.getFirst()) && context.eventExists(edge.getSecond())) {
                add(edge, 0);
                // Test for reason tracking
                /*ReasonGraph.Node node = reasonGraph.addNode(this, edge, 0);
                node.setCoreReason(context.getEventLiteral(edge.getFirst()), context.getEventLiteral(edge.getSecond()));*/
            }
        }
        return history.get(0).edges;
    }

    @Override
    public Conjunction<CoreLiteral> computeShortestReason(Edge edge) {
        return new Conjunction<>(new EventLiteral(edge.getFirst()), new EventLiteral(edge.getSecond()));
    }
}
