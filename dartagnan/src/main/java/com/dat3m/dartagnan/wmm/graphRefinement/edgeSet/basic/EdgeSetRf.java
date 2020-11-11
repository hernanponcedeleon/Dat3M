package com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.basic;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.graphRefinement.GraphContext;
import com.dat3m.dartagnan.wmm.graphRefinement.ReasonGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.EdgeLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.RfLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.EventData;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationData;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import java.util.Map;
import java.util.Set;

public class EdgeSetRf extends EdgeSetBasic {
    // Should only be called with "rf"
    // Ugly solution, but we will keep it for now
    public EdgeSetRf(RelationData rel) {
        super(rel);
    }

    @Override
    public Set<Edge> addAll(Set<Edge> edges, int time) {
        Set<Edge> added = super.addAll(edges, time);
        /*for (Edge edge : added) {
            ReasonGraph.Node node = reasonGraph.addNode(this, edge, 0);
            node.setCoreReason(new EdgeLiteral(this.relation, edge));
        }*/
        return added;
    }

    @Override
    public boolean add(Edge edge, int time) {
        if (super.add(edge, time)) {
            /*ReasonGraph.Node node = reasonGraph.addNode(this, edge, 0);
            node.setCoreReason(new EdgeLiteral(this.relation, edge));*/
            return true;
        }
        return false;
    }

    @Override
    public Set<Edge> initialize(GraphContext context) {
        super.initialize(context);

        for (Map.Entry<EventData, EventData> readWrite : context.getReadWriteMap().entrySet()) {
            Edge edge = new Edge(readWrite.getValue(), readWrite.getKey());
            super.add(edge, 0);
            /*ReasonGraph.Node node = reasonGraph.addNode(this, edge, 0);
            node.setCoreReason(new EdgeLiteral(this.relation, edge));*/
        }
        return history.get(0).edges;
    }

    @Override
    public Conjunction<CoreLiteral> computeShortestReason(Edge edge) {
        if (!this.contains(edge))
            return Conjunction.FALSE;
        return new Conjunction<>(new RfLiteral(edge, context));
    }
}
