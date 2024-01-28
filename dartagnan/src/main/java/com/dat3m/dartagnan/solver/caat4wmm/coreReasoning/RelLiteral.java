package com.dat3m.dartagnan.solver.caat4wmm.coreReasoning;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.logic.AbstractDataLiteral;
import com.dat3m.dartagnan.wmm.utils.Tuple;

public class RelLiteral extends AbstractDataLiteral<CoreLiteral, Tuple> implements CoreLiteral {

    protected Event e1;
    protected Event e2;
    public RelLiteral(String name, Event e1, Event e2, boolean isNegative) {
        super(name, new Tuple(e1, e2), isNegative);
        this.e1 = e1;
        this.e2 = e2;
    }

    @Override
    public RelLiteral negated() {
        return new RelLiteral(name, e1, e2, !isNegative);
    }

    @Override
    public String toString() {
        return toStringBase() + "(" + e1.getGlobalId() + "," + e2.getGlobalId() + ")";
    }
}
