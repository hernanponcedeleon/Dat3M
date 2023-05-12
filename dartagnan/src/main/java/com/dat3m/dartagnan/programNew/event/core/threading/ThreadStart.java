package com.dat3m.dartagnan.programNew.event.core.threading;


import com.dat3m.dartagnan.programNew.event.AbstractEvent;
import com.dat3m.dartagnan.programNew.event.Event;
import com.dat3m.dartagnan.programNew.event.EventUser;

import java.util.Set;

/*
    The ThreadStart event is placed in the beginning of a function, if that function is the entry point of a thread.
    A thread may run on program start-up (e.g., the main thread or the processes in Litmus tests), or it may be spawned
    by a ThreadCreate event. In the latter case, there is a one-to-one correspondence between the ThreadCreate and the
    ThreadSpawn event.

    NOTES:
        - A function with parameters can be run as a thread. In that case, the values of the parameters are
           (1) non-deterministically chosen, if the thread runs on start-up
        OR (2) given by the arguments to the ThreadCreate event.
        - In case (2), we use special ThreadArgument events to pass the arguments across thread boundaries.
 */
public abstract class ThreadStart extends AbstractEvent implements EventUser {

    /*
        The event that spawns this thread.
        Can be NULL if the thread runs immediately on start-up.
     */
    private ThreadCreate creationEvent;

    private ThreadStart(ThreadCreate creationEvent) {
        this.creationEvent = creationEvent;

        creationEvent.registerUser(this);
    }

    @Override
    public Set<Event> getReferencedEvents() {
        return creationEvent == null ? Set.of() : Set.of(creationEvent);
    }
}
