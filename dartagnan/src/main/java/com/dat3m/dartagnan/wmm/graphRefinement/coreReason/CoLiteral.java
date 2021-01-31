package com.dat3m.dartagnan.wmm.graphRefinement.coreReason;

import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;

public class CoLiteral extends AbstractEdgeLiteral {
    private CoLiteral opposite;

    public CoLiteral(Edge edge) {
        super("co", edge);
    }

    @Override
    public boolean hasOpposite() {
        return true;
    }

    @Override
    public CoreLiteral getOpposite() {
        if (opposite == null) {
            opposite = new CoLiteral(edge.getInverse());
            opposite.opposite = this;
        }
        return opposite;
    }
}
