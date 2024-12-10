package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.verification.model.ThreadModel;

import static com.dat3m.dartagnan.program.event.Tag.*;


public class DefaultEventModel implements EventModel {
    protected final Event event;
    protected final ThreadModel thread;
    protected int id = -1;

    public DefaultEventModel(Event event, ThreadModel thread, int id) {
        this.event = event;
        this.thread = thread;
        this.id = id;

        thread.addEvent(this);
    }

    @Override
    public Event getEvent() {
        return event;
    }

    @Override
    public ThreadModel getThreadModel() {
        return thread;
    }

    @Override
    public int getId() {
        return id;
    }

    @Override
    public boolean isMemoryEvent() { return event instanceof MemoryEvent; }

    @Override
    public boolean isInit() { return event instanceof Init; }

    @Override
    public boolean isWrite() { return event instanceof Store; }

    @Override
    public boolean isVisible() { return event instanceof MemoryEvent || event instanceof GenericVisibleEvent; }

    @Override
    public boolean isJump() { return event instanceof CondJump; }

    @Override
    public boolean isAssert() { return event instanceof Assert; }

    @Override
    public boolean isLocal() { return event instanceof Local; }

    @Override
    public boolean isRegReader() { return event instanceof RegReader; }

    @Override
    public boolean isRegWriter() { return event instanceof RegWriter; }

    @Override
    public int hashCode() {
        return id;
    }

    @Override
    public boolean equals(Object obj) {
        // EventModel instances are unique per event.
        return this == obj;
    }

    @Override
    public String toString() {
        return String.format("T%d/E%d", thread.getId(), id);
    }

    @Override
    public int compareTo(EventModel e) {
        return this.getId() - e.getId();
    }
}