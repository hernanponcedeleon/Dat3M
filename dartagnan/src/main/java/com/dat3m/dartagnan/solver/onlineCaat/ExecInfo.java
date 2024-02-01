package com.dat3m.dartagnan.solver.onlineCaat;

import com.dat3m.dartagnan.program.event.Event;

import java.util.List;

public record ExecInfo(List<Event> events) implements EncodingInfo {

    public void add(Event e) {
        events.add(e);
    }
}
