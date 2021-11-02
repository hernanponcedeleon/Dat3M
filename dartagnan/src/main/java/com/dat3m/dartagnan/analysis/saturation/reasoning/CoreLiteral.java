package com.dat3m.dartagnan.analysis.saturation.reasoning;

import com.dat3m.dartagnan.analysis.saturation.logic.Literal;

/* A core literal should be one of the following
    - An event
    - An rf or co edge
    - An address equality/inequality
*/
public interface CoreLiteral extends Literal<CoreLiteral> {
    boolean isNegated();
}

