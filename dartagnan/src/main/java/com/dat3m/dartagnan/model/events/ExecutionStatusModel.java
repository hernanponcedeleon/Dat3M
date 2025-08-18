package com.dat3m.dartagnan.model.events;

import com.dat3m.dartagnan.encoding.TypedValue;
import com.dat3m.dartagnan.model.AbstractEventModel;
import com.dat3m.dartagnan.model.EventModel;
import com.dat3m.dartagnan.program.Register;

public final class ExecutionStatusModel extends AbstractEventModel implements RegWriterModel {

    private final Register register;
    private final TypedValue<?, ?> value;
    private final EventModel trackedEvent; // NULL, if tracked event was not executed

    public ExecutionStatusModel(Register register, TypedValue<?, ?> value, EventModel trackedEvent) {
        this.register = register;
        this.value = value;
        this.trackedEvent = trackedEvent;
    }

    @Override
    public Register getResultRegister() {
        return register;
    }

    @Override
    public TypedValue<?, ?> getValue() {
        return value;
    }

    public boolean trackedEventWasExecuted() { return trackedEvent != null; }

    public EventModel getTrackedEvent() {
        return trackedEvent;
    }

    @Override
    public String toString() {
        return String.format("%s {%s} <- ExecStatus(%s)", register, value, trackedEventWasExecuted() ? trackedEvent : "FAIL");
    }
}
