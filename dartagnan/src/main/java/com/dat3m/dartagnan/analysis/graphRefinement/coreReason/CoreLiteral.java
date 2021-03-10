package com.dat3m.dartagnan.analysis.graphRefinement.coreReason;

import com.dat3m.dartagnan.analysis.graphRefinement.logic.Literal;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

/* A core literal should be one of the following
    - An event
    - An rf or co edge
    - An address equality/inequality
*/
public interface CoreLiteral extends Literal<CoreLiteral> {
    BoolExpr getZ3BoolExpr(Context ctx);
}

