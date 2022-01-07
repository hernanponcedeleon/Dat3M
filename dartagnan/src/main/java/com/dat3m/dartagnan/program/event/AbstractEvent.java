package com.dat3m.dartagnan.program.event;

public abstract class AbstractEvent extends Event {

    protected AbstractEvent() {
        super();
    }

    protected AbstractEvent(AbstractEvent other) {
        super(other);
    }
}
