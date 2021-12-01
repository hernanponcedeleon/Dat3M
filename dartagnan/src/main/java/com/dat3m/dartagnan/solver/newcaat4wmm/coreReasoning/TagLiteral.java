package com.dat3m.dartagnan.solver.newcaat4wmm.coreReasoning;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.logic.AbstractDataLiteral;


public class TagLiteral extends AbstractDataLiteral<CoreLiteral, Event> implements CoreLiteral {

    public TagLiteral(String name, Event event, boolean isNegative) {
        super(name, event, isNegative);
    }

    public TagLiteral(String name, Event event) {
        this(name, event, false);
    }

    @Override
    public TagLiteral negated() {
        return new TagLiteral(name, data, !isNegative());
    }
}
