package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.lang.std.Malloc;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.ArrayList;
import java.util.List;

/*
    This pass collects all Malloc events in the program and for each of them it:
        (1) allocates a MemoryObject of appropriate size
        (2) creates Init events that initialize the allocated memory
            (TODO: If possible, only allocate subset of relevant init events)
        (3) replaces the Malloc event with a local register assignment, assigning the newly created MemoryObject
 */
public class MemoryAllocation implements ProgramProcessor {

    private MemoryAllocation() { }

    public static MemoryAllocation newInstance() { return new MemoryAllocation(); }

    @Override
    public void run(Program program) {

        final List<MemoryObject> memObjs = new ArrayList<>();
        for (Malloc malloc : program.getEvents(Malloc.class)) {
            final MemoryObject memoryObject = program.getMemory().allocate(getSize(malloc));
            memObjs.add(memoryObject);

            final Local local = EventFactory.newLocal(malloc.getResultRegister(), memoryObject);
            local.addFilters(Tag.Std.MALLOC);
            malloc.replaceBy(local);
        }

        createInits(program, memObjs);
        Memory.fixateMemoryValues().run(program);
    }

    private int getSize(Malloc malloc) {
        try {
            return malloc.getSizeExpr().reduce().getValueAsInt();
        } catch (Exception e) {
            final String error = String.format("Variable-sized malloc '%s' is not supported", malloc);
            throw new MalformedProgramException(error);
        }
    }

    private void createInits(Program program, List<MemoryObject> memoryObjects) {
        final List<Thread> threads = program.getThreads();

        int nextThreadId = threads.get(threads.size() - 1).getId() + 1;
        for(MemoryObject memObj : memoryObjects) {
            for(int i = 0; i < memObj.size(); i++) {
                final Event init = EventFactory.newInit(memObj, i);
                final Thread thread = new Thread(nextThreadId++, init);

                program.add(thread);
                thread.setProgram(program);
                thread.getEntry().setSuccessor(EventFactory.newLabel("END_OF_T" + thread.getId()));
                thread.updateExit(thread.getEntry());
            }
        }
    }
}
