package com.dat3m.dartagnan.solver.onlineCaat.caat4wmm.coreReasoning;

import com.dat3m.dartagnan.utils.logic.Literal;

/* A core literal should be one of the following
    - An event
    - An rf or co edge
    - An address equality/inequality
*/
public interface CoreLiteral extends Literal<CoreLiteral> {
}

