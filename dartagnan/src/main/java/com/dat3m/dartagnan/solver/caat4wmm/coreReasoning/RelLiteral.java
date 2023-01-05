package com.dat3m.dartagnan.solver.caat4wmm.coreReasoning;

import com.dat3m.dartagnan.utils.logic.AbstractDataLiteral;
import com.dat3m.dartagnan.wmm.utils.Tuple;

public class RelLiteral extends AbstractDataLiteral<CoreLiteral, Tuple> implements CoreLiteral {

    public RelLiteral(String name, Tuple edge, boolean isNegative) {
        super(name, edge, isNegative);
    }

    @Override
    public RelLiteral negated() {
        return new RelLiteral(name, data, !isNegative);
    }

    @Override
    public String toString() {
        return toStringBase() + "(" + data.getFirst().getGlobalId() + "," + data.getSecond().getGlobalId() + ")";
    }

}
