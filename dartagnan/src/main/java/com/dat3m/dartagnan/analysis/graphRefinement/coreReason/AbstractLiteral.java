package com.dat3m.dartagnan.analysis.graphRefinement.coreReason;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

//TODO: Add some context field (implement some sort of refinement context?)
public abstract class AbstractLiteral implements CoreLiteral {

    public AbstractLiteral() {}

    public abstract BoolExpr getZ3BoolExpr(Context ctx);

    @Override
    public boolean hasOpposite() {
        return false;
    }

    @Override
    public CoreLiteral getOpposite() {
        return null;
    }
}
