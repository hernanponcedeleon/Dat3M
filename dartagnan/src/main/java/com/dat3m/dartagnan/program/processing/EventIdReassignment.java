package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.core.AbstractEvent;

public class EventIdReassignment implements ProgramProcessor {

    private EventIdReassignment() {}

    public static EventIdReassignment newInstance() {
        return new EventIdReassignment();
    }

    @Override
    public void run(Program program) {
        int globalId = 0;
        for (Thread thread : program.getThreads()) {
            AbstractEvent cur = thread.getEntry();
            while (cur != null) {
                cur.setGlobalId(globalId++);
                cur = cur.getSuccessor();
            }
        }
    }
}
