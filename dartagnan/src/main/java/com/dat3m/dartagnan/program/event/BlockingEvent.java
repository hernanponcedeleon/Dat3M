package com.dat3m.dartagnan.program.event;

/*
    Base interface for all events that can block, i.e., stop the control-flow.

    IMPLEMENTATION NOTE:
        A BlockingEvent is considered blocking if it is part of the control-flow but does not get executed,
        i.e., the execution condition is precisely the unblocking condition.
 */
public interface BlockingEvent extends Event {
}
