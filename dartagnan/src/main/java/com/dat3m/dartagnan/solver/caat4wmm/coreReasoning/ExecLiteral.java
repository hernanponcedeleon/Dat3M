package com.dat3m.dartagnan.solver.caat4wmm.coreReasoning;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.logic.AbstractDataLiteral;

/*
This encodes events as literals. An event literal is simply the events exec-variable.
 */
public class ExecLiteral extends AbstractDataLiteral<CoreLiteral, Event> implements CoreLiteral {

    public ExecLiteral(Event event, boolean isNegative) {
        super("exec", event, isNegative);
    }

    public ExecLiteral(Event event) {
        this(event,false);
    }

    @Override
    public ExecLiteral negated() {
        return new ExecLiteral(data, !isNegative());
    }

    @Override
    public String toString() {
        return toStringBase() + "(" + data.getGlobalId() + ")";
    }
}
