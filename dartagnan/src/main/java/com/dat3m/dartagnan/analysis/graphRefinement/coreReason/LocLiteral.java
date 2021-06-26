package com.dat3m.dartagnan.analysis.graphRefinement.coreReason;


import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.verification.model.Edge;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public class LocLiteral extends AbstractEdgeLiteral {

    public LocLiteral(Edge edge) {
        super("loc", edge);
        if (edge.getFirst().getEvent().getCId() > edge.getSecond().getEvent().getCId()) {
            this.edge = edge.getInverse();
        }
    }

    @Override
    public BoolExpr getZ3BoolExpr(Context ctx) {
        MemEvent e1 = (MemEvent)edge.getFirst().getEvent();
        MemEvent e2 = (MemEvent)edge.getSecond().getEvent();
        return ctx.mkEq(e1.getMemAddressExpr(), e2.getMemAddressExpr());
    }
}
