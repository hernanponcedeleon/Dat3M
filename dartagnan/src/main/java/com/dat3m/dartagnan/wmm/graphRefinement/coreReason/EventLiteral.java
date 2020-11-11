package com.dat3m.dartagnan.wmm.graphRefinement.coreReason;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.EventData;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

/*
This encodes events as literals. A event literal is simply the events exec-variable.
 */
public class EventLiteral implements CoreLiteral {

    private EventData event;

    public EventData getEvent() {
        return event;
    }

    public EventLiteral(EventData e) {
        this.event = e;
    }

    @Override
    public int hashCode() {
        return event.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this)
            return true;
        if (obj == null || !(obj instanceof EventLiteral))
            return false;

        EventLiteral other = (EventLiteral) obj;
        return this.event.equals(other.event);
    }

    @Override
    public String toString() {
        return event.toString();
    }

    @Override
    public BoolExpr getZ3BoolExpr(Context ctx) {
        return event.getEvent().exec();
    }

    @Override
    public boolean hasOpposite() {
        return false;
    }

    @Override
    public CoreLiteral getOpposite() {
        return null;
    }
}
