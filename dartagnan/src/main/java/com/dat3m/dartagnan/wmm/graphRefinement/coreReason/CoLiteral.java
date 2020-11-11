package com.dat3m.dartagnan.wmm.graphRefinement.coreReason;

import com.dat3m.dartagnan.wmm.graphRefinement.GraphContext;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.utils.Tuple;

public class CoLiteral extends AbstractEdgeLiteral {
    private CoLiteral opposite;

    public CoLiteral(Edge edge, GraphContext context) {
        super("co", edge, context);
    }

    @Override
    public boolean hasOpposite() {
        return true;
    }

    @Override
    public CoreLiteral getOpposite() {
        if (opposite == null) {
            opposite = new CoLiteral(edge.getInverse(), context);
            opposite.opposite = this;
        }
        return opposite;
    }
}
