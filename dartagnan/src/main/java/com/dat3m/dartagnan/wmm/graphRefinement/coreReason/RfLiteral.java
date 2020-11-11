package com.dat3m.dartagnan.wmm.graphRefinement.coreReason;

import com.dat3m.dartagnan.wmm.graphRefinement.GraphContext;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.utils.Tuple;

public class RfLiteral extends AbstractEdgeLiteral {

    public RfLiteral(Edge edge, GraphContext context) {
        super("rf", edge, context);
    }
}
