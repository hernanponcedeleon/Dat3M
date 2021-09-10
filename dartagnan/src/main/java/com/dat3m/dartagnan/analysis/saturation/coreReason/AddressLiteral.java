package com.dat3m.dartagnan.analysis.saturation.coreReason;


import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.Edge;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.LOC;

public class AddressLiteral extends AbstractEdgeLiteral {

    //TODO: This normalization is ugly. We should use a literal factory at some point
    // which should perform such normalization.
    public AddressLiteral(Edge edge) {
        super(LOC, edge);
        if (edge.getFirst().getEvent().getCId() > edge.getSecond().getEvent().getCId()) {
            // We normalize the direction, because loc is symmetric
            this.edge = edge.inverse();
        }
    }
}
