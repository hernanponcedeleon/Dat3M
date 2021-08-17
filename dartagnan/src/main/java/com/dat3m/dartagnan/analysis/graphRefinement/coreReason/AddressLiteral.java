package com.dat3m.dartagnan.analysis.graphRefinement.coreReason;


import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.utils.Utils;
import com.dat3m.dartagnan.verification.model.Edge;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

public class AddressLiteral extends AbstractEdgeLiteral {

    public AddressLiteral(Edge edge) {
        super("loc", edge);
        if (edge.getFirst().getEvent().getCId() > edge.getSecond().getEvent().getCId()) {
            this.edge = edge.inverse();
        }
    }

    @Override
    public BooleanFormula getBooleanFormula(SolverContext ctx) {
        MemEvent e1 = (MemEvent)edge.getFirst().getEvent();
        MemEvent e2 = (MemEvent)edge.getSecond().getEvent();
        return Utils.generalEqual(e1.getMemAddressExpr(), e2.getMemAddressExpr(), ctx);
    }
}
