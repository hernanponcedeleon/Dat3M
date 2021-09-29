package com.dat3m.dartagnan.analysis.saturation.reasoning;

import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.Edge;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.RF;

public class RfLiteral extends EdgeLiteral {

    public RfLiteral(Edge edge) {
        super(RF, edge);
    }
}
