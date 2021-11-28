package com.dat3m.dartagnan.solver.caat4bmc;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.logic.AbstractDataLiteral;

/*
This encodes events as literals. An event literal is simply the events exec-variable.
 */
public class EventLiteral extends AbstractDataLiteral<CoreLiteral, Event> implements CoreLiteral {

    public EventLiteral(Event event, boolean isNegative) {
        super("exec", event, isNegative);
    }

    public EventLiteral(Event event) {
        this(event,false);
    }

    @Override
    public EventLiteral negated() {
        return new EventLiteral(data, !isNegative());
    }
}
