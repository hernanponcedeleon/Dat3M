package com.dat3m.dartagnan.solver.caat4wmm.coreReasoning;

import com.dat3m.dartagnan.program.event.Event;

import java.util.Objects;

/*
This encodes events as literals. An event literal is simply the events exec-variable.
 */
public final class ExecLiteral implements CoreLiteral {

    private final Event event;
    private final boolean isPositive;

    public ExecLiteral(Event event, boolean isPositive) {
        this.event = event;
        this.isPositive = isPositive;
    }

    public ExecLiteral(Event event) {
        this(event,true);
    }

    public Event getEvent() { return event; }

    @Override
    public String getName() {
        return "exec";
    }

    @Override
    public boolean isPositive() {
        return isPositive;
    }

    @Override
    public ExecLiteral negated() {
        return new ExecLiteral(event, !isPositive);
    }

    @Override
    public String toString() {
        return getName() + "(" + event.getGlobalId() + ")";
    }

    @Override
    public int hashCode() {
        return Objects.hash(event, isPositive);
    }

    @Override
    public boolean equals(Object obj) {
        return (obj instanceof ExecLiteral other
                && this.event == other.event
                && this.isPositive == other.isPositive);
    }

}
