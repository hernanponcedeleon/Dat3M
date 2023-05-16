package com.dat3m.dartagnan.prototype.program.event;

import java.util.Set;

/*
   Any Event that references other Events directly (not just as a predecessor/successor)
   should implement this interface.

   Common EventUsers:
        - Branching events (reference labels)
        - PhiEvents (reference both labels and jumps)
        - ExecutionStatus and ExternalAssignments (reference arbitrary events)
*/

/*
    TODO: Maybe we could have Expressions that are EventUsers (in which case EventUser would not extend Event).
     ADVANTAGES:
       - This would allow us to have more general expressions that could maybe subsume ExecutionStatus,
         ExternalAssignment, and PhiEvents.
     DISADVANTAGES:
       - General expressions can appear anywhere, which makes them harder to handle.
         -- Some use-patterns, like PhiEvents, get harder to detect (detecting PhiEvents might be useful!?)
       - We get cyclic dependencies from the Event-hierarchy to the Expression-hierarchy and back.
       - ExecutionStatus needs special dependency-handling anyway.

 */

public interface EventUser extends Event {
    Set<Event> getReferencedEvents();
}
