package com.dat3m.dartagnan.program.analysis.interval;

import com.dat3m.dartagnan.program.event.Event;

public class EventNotFoundException extends RuntimeException {
    public EventNotFoundException(Event e) {
        super("Event " + e.toString() + " not encountered during analysis");
    }
}
