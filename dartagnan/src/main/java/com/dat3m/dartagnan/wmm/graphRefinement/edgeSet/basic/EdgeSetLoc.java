package com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.basic;

import com.dat3m.dartagnan.wmm.graphRefinement.GraphContext;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.EventLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.EventData;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationData;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;

import java.util.*;

// For now, this one performs exactly the same as po or any other static relation
// But for programs with operations on non-constant addresses (due to pointer arithmetic or non-determinism)
// we want different core reasons here!
public class EdgeSetLoc extends EdgeSetBasic {
    // Should only be called with "loc"
    // Ugly solution, but we will keep it for now
    public EdgeSetLoc(RelationData rel) {
        super(rel);
    }

    @Override
    public Set<Edge> addAll(Set<Edge> edges, int time) {
        Set<Edge> added = super.addAll(edges, time);
        /*for (Edge edge : added) {
            ReasonGraph.Node node = reasonGraph.addNode(this, edge, 0);
            node.setCoreReason(new EventLiteral(edge.getFirst()), new EventLiteral(edge.getSecond()));
        }*/
        return added;
    }

    @Override
    public boolean add(Edge edge, int time) {
        if (super.add(edge, time)) {
            /*ReasonGraph.Node node = reasonGraph.addNode(this, edge, 0);
            node.setCoreReason(new EventLiteral(edge.getFirst()), new EventLiteral(edge.getSecond()));*/
            return true;
        }
        return false;
    }

    @Override
    public Set<Edge> initialize(GraphContext context) {
        super.initialize(context);

        for (Integer address : context.getAddressWritesMap().keySet()) {
            List<EventData> events = Arrays.asList(context.getAddressWritesMap().get(address).toArray(new EventData[0]));
            events.addAll(context.getAddressReadsMap().get(address));
            for (EventData a : events)
                for (EventData b : events) {
                    Edge edge = new Edge(a, b);
                    if (super.add(edge, 0)) {
                        /*ReasonGraph.Node node = reasonGraph.addNode(this, edge, 0);
                        node.setCoreReason(context.getEventLiteral(edge.getFirst()), context.getEventLiteral(edge.getSecond()));*/
                    }
                }
        }

        return history.get(0).edges;
    }

    @Override
    public Conjunction<CoreLiteral> computeShortestReason(Edge edge) {
        if (!this.contains(edge))
            return Conjunction.FALSE;
        return new Conjunction<>(new EventLiteral(edge.getFirst()), new EventLiteral(edge.getSecond()));
    }
}
