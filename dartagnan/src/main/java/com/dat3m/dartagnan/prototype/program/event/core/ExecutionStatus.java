package com.dat3m.dartagnan.prototype.program.event.core;

import com.dat3m.dartagnan.prototype.program.Register;
import com.dat3m.dartagnan.prototype.program.event.AbstractEvent;
import com.dat3m.dartagnan.prototype.program.event.Event;
import com.dat3m.dartagnan.prototype.program.event.EventUser;

import java.util.Set;

// TODO: "abstract" is only here to avoid providing a complete implementation for now
public abstract class ExecutionStatus extends AbstractEvent implements Register.Writer, EventUser {

    private Register resultRegister;
    private Event trackedEvent;
    private boolean doesTrackDependencies;

    private ExecutionStatus(Register resultRegister, Event trackedEvent, boolean doesTrackDependencies) {
        this.resultRegister = resultRegister;
        this.trackedEvent = trackedEvent;
        this.doesTrackDependencies = doesTrackDependencies;

        trackedEvent.registerUser(this);
    }

    @Override
    public Register getResultRegister() {
        return resultRegister;
    }
    public Event getTrackedEvent() { return trackedEvent; }
    public boolean doesTrackDependencies() { return doesTrackDependencies; }

    @Override
    public Set<Event> getReferencedEvents() {
        return Set.of(trackedEvent);
    }
}
