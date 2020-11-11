package com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.basic;

import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.graphRefinement.ReasonGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.EdgeLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationData;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import java.util.Set;

public class EdgeSetCo extends EdgeSetBasic {
    // Should only be called with "_co"
    // Ugly solution, but we will keep it for now
    public EdgeSetCo(RelationData rel) {
        super(rel);
    }

    @Override
    public Set<Edge> addAll(Set<Edge> edges, int time) {
        Set<Edge> added = super.addAll(edges, time);
        /*for (Edge edge : added) {
            //ReasonGraph.Node node = reasonGraph.addNode(this, edge, 0);
            if (edge.getFirst().is(EType.INIT))
                node.setCoreReason(Conjunction.TRUE);
            else
                node.setCoreReason(new EdgeLiteral(this.relation, edge));
        }*/
        return added;
    }

    @Override
    public boolean add(Edge edge, int time) {
        if (super.add(edge, time)) {
            /*ReasonGraph.Node node = reasonGraph.addNode(this, edge, time);
            if (edge.getFirst().is(EType.INIT))
                node.setCoreReason(Conjunction.TRUE);
            else
                node.setCoreReason(new EdgeLiteral(this.relation, edge));*/
            return true;
        }
        return false;
    }

    @Override
    public Conjunction<CoreLiteral> computeShortestReason(Edge edge) {
        if (!this.contains(edge))
            return Conjunction.FALSE;
        return new Conjunction<>(new CoLiteral(edge, context));
    }
}
