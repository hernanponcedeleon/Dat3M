package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.core.Event;

import java.util.function.BiConsumer;

public class EventIdReassignment implements ProgramProcessor {

    private final BiConsumer<Event, Integer> idTrackingFunction;

    private EventIdReassignment(BiConsumer<Event, Integer> idTrackingFunction) {
        this.idTrackingFunction = idTrackingFunction;
    }

    public static EventIdReassignment newInstance() {
        return new EventIdReassignment((e, id) -> {});
    }

    public static EventIdReassignment withIdTracking(BiConsumer<Event, Integer> trackingFunction) {
        return new EventIdReassignment(trackingFunction);
    }

    @Override
    public void run(Program program) {
        int globalId = 0;
        for (Thread thread : program.getThreads()) {
            int localId = 0;
            Event cur = thread.getEntry();
            while (cur != null) {
                cur.setLocalId(localId++);
                cur.setGlobalId(globalId++);
                idTrackingFunction.accept(cur, cur.getGlobalId());
                cur = cur.getSuccessor();
            }
        }
    }
}
