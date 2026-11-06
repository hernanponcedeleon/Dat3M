package com.dat3m.dartagnan.program.event;

/*
    Base interface for all events that can block, i.e., stop the control flow.

    IMPLEMENTATION NOTE:
        The BlockingEvent counts as executed and appears in the execution graph as usual (if it is visible).
 */
public interface BlockingEvent extends Event {
}
