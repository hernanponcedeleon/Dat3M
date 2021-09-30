package com.dat3m.dartagnan.analysis.saturation.coreReason;

import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.Edge;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.RF;

public class RfLiteral extends AbstractEdgeLiteral {

    public RfLiteral(Edge edge) {
        super(RF, edge);
    }
}
