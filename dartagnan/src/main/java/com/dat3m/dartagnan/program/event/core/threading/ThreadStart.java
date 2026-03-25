package com.dat3m.dartagnan.program.event.core.threading;

import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventUser;

import java.util.Map;
import java.util.Set;

public class ThreadStart extends AbstractEvent implements EventUser {

    // May be NULL if this thread is not spawned.
    private ThreadCreate creator;

    public ThreadStart(ThreadCreate creator) {
        this.creator = creator;

        if (creator != null) {
            creator.registerUser(this);
        }
    }

    protected ThreadStart(ThreadStart other) {
        super(other);
        this.creator = other.creator;

        if (creator != null) {
            creator.registerUser(this);
        }
    }

    public boolean isSpawned() { return creator != null; }
    public ThreadCreate getCreator() { return creator; }

    @Override
    public String defaultString() {
        if (isSpawned()) {
            return String.format("ThreadStart by %s::%s", creator.getThread(), creator);
        } else {
            return "ThreadStart";
        }
    }

    @Override
    public ThreadStart getCopy() {
        return new ThreadStart(this);
    }

    @Override
    public Set<Event> getReferencedEvents() {
        return Set.of(creator);
    }

    @Override
    public void updateReferences(Map<Event, Event> updateMapping) {
        creator = (ThreadCreate) EventUser.moveUserReference(this, creator, updateMapping);
    }
}