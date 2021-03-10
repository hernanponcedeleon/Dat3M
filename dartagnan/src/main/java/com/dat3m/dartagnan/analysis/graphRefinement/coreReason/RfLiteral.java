package com.dat3m.dartagnan.analysis.graphRefinement.coreReason;

import com.dat3m.dartagnan.verification.model.Edge;

public class RfLiteral extends AbstractEdgeLiteral {

    public RfLiteral(Edge edge) {
        super("rf", edge);
    }
}
