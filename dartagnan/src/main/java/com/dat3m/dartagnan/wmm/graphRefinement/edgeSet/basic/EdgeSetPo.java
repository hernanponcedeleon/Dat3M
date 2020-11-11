package com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.basic;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.graphRefinement.GraphContext;
import com.dat3m.dartagnan.wmm.graphRefinement.ReasonGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.EventLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.EventData;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationData;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import java.util.List;
import java.util.Set;

public class EdgeSetPo extends EdgeSetBasic {
    // Should only be called with "po"
    // Ugly solution, but we will keep it for now
    public EdgeSetPo(RelationData rel) {
        super(rel);
    }

    @Override
    public Set<Edge> addAll(Set<Edge> edges, int time) {
        Set<Edge> added = super.addAll(edges, time);
        /*for (Tuple edge : added) {
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
        List<EventData> eventList = context.getEventList();
        int cur = 0;
        EventData curEvent = eventList.get(cur);
        int i = 1;
        EventData next;

        while (i < eventList.size()) {
            next = eventList.get(i);
            if (next.getThread().equals(curEvent.getThread())) {
                Edge edge = new Edge(curEvent, next);
                super.add(edge, 0);
                /*ReasonGraph.Node node = reasonGraph.addNode(this, edge, 0);
                node.setCoreReason(context.getEventLiteral(curEvent), context.getEventLiteral(next));*/
                i++;
            } else if (i == cur + 1) {
                cur = i++;
                curEvent = next;
            } else {
                curEvent = eventList.get(++cur);
                i = cur + 1;
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
