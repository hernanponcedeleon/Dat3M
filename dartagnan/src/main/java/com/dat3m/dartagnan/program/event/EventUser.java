package com.dat3m.dartagnan.program.event;


import java.util.Map;
import java.util.Set;

/*
   Any Event that references other Events directly (not just as a predecessor/successor)
   should implement this interface.

   Common EventUsers:
        - Branching events (reference labels)
        - ExecutionStatus (references arbitrary events)
        - Paired events like RMWStore and BeginAtomic/EndAtomic (potentially reference each other)
        - Possibly PhiEvents (reference both labels and jumps?!)
*/
public interface EventUser extends Event {

    Set<Event> getReferencedEvents();
    void updateReferences(Map<Event, Event> updateMapping);

    /*
        Helper method to simplify implementation of <updateReference>
     */
    static Event moveUserReference(EventUser user, Event oldEv, Map<Event, Event> updateMapping) {
        final Event newEv = updateMapping.getOrDefault(oldEv, oldEv);
        if (oldEv != newEv) {
            oldEv.removeUser(user);
            newEv.registerUser(user);
        }
        return newEv;
    }
}
