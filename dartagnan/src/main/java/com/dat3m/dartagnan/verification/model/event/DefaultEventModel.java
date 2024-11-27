package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
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
    public ThreadModel getThread() {
        return thread;
    }

    @Override
    public int getId() {
        return id;
    }

    @Override
    public boolean isMemoryEvent() { return event.hasTag(MEMORY); }

    @Override
    public boolean isInit() { return event.hasTag(INIT); }

    @Override
    public boolean isWrite() { return event.hasTag(WRITE); }

    @Override
    public boolean isRead() { return event.hasTag(READ); }

    @Override
    public boolean isFence() { return event.hasTag(FENCE); }

    @Override
    public boolean isExclusive() { return event.hasTag(EXCL); }

    @Override
    public boolean isRMW() { return event.hasTag(RMW); }

    @Override
    public boolean isVisible() { return event.hasTag(VISIBLE); }

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