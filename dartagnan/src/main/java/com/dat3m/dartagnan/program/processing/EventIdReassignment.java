package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.core.Event;
import com.google.common.collect.Iterables;

public class EventIdReassignment implements ProgramProcessor {

    private EventIdReassignment() {}

    public static EventIdReassignment newInstance() {
        return new EventIdReassignment();
    }

    @Override
    public void run(Program program) {
        int globalId = 0;
        for (Function func : Iterables.concat(program.getThreads(), program.getFunctions())) {
            Event cur = func.getEntry();
            while (cur != null) {
                cur.setGlobalId(globalId++);
                cur = cur.getSuccessor();
            }
        }
    }
}
