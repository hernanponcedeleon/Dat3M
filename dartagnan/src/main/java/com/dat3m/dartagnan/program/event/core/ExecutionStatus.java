package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.*;

import java.util.Map;
import java.util.Set;

public class ExecutionStatus extends AbstractEvent implements RegWriter, EventUser {

    private Register register;
    private Event event;
    private final boolean trackDep;

    public ExecutionStatus(Register register, Event event, boolean trackDep) {
        this.register = register;
        this.event = event;
        this.trackDep = trackDep;

        this.event.registerUser(this);
    }

    protected ExecutionStatus(ExecutionStatus other) {
        super(other);
        this.register = other.register;
        this.event = other.event;
        this.trackDep = other.trackDep;

        this.event.registerUser(this);
    }

    @Override
    public Register getResultRegister() {
        return register;
    }

    @Override
    public void setResultRegister(Register reg) {
        this.register = reg;
    }

    public Event getStatusEvent() {
        return event;
    }

    public boolean doesTrackDep() {
        return trackDep;
    }

    @Override
    public String defaultString() {
        return register + " = not_exec(" + event + ")";
    }

    @Override
    public Event getCopy() {
        return new ExecutionStatus(this);
    }

    @Override
    public void updateReferences(Map<Event, Event> updateMapping) {
        this.event = EventUser.moveUserReference(this, this.event, updateMapping);
    }

    @Override
    public Set<Event> getReferencedEvents() {
        return Set.of(event);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitExecutionStatus(this);
    }

}