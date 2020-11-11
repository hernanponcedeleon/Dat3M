package com.dat3m.dartagnan.wmm.graphRefinement.coreReason;

import com.dat3m.dartagnan.wmm.graphRefinement.GraphContext;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public abstract class AbstractLiteral implements CoreLiteral {
    protected GraphContext context;

    public GraphContext getContext() {
        return context;
    }

    public AbstractLiteral(GraphContext context) {
        this.context = context;
    }

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
