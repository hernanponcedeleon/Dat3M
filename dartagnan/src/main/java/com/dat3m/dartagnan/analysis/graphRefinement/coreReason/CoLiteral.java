package com.dat3m.dartagnan.analysis.graphRefinement.coreReason;

import com.dat3m.dartagnan.verification.model.Edge;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CO;

public class CoLiteral extends AbstractEdgeLiteral {
    private CoLiteral opposite;

    public CoLiteral(Edge edge) {
        super(CO, edge);
    }

    @Override
    public boolean hasOpposite() {
        return true;
    }

    @Override
    public CoreLiteral getOpposite() {
        if (opposite == null) {
            opposite = new CoLiteral(edge.inverse());
            opposite.opposite = this;
        }
        return opposite;
    }
}
