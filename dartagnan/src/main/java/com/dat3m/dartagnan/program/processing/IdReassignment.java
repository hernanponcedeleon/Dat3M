package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.google.common.collect.Iterables;

public class IdReassignment implements ProgramProcessor, FunctionProcessor {

    private IdReassignment() {}

    public static IdReassignment newInstance() {
        return new IdReassignment();
    }

    @Override
    public void run(Program program) {
        int funcId = 0;
        int globalId = 0;
        for (Function func : Iterables.concat(program.getThreads(), program.getFunctions())) {
            func.setId(funcId++);
            Event cur = func.getEntry();
            int localId = 0;
            while (cur != null) {
                cur.setLocalId(localId++);
                cur.setGlobalId(globalId++);
                cur = cur.getSuccessor();
            }
        }
    }

    @Override
    public void run(Function function) {
        Event cur = function.getEntry();
        int localId = 0;
        while (cur != null) {
            cur.setLocalId(localId++);
            cur = cur.getSuccessor();
        }
    }
}
