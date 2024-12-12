package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.verification.model.ThreadModel;


public class DefaultEventModel implements EventModel {
    protected final Event event;
    protected final ThreadModel thread;
    protected final int id;

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