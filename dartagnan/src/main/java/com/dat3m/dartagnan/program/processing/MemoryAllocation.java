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
    Constructs for each malloc call a MemoryObject representing the result of the malloc call.
    Furthermore, new Init events are constructed to initialize the malloc'd memory
    (TODO: the memory is initialized to 0, but technically a non-deterministic value would be more appropriate)
    Replaces the malloc calls with a local assignment that assigns the created MemoryObject to the result register.
 */
public class MemoryAllocation implements ProgramProcessor {

    private MemoryAllocation() { }

    public static MemoryAllocation newInstance() { return new MemoryAllocation(); }

    @Override
    public void run(Program program) {

        List<MemoryObject> memObjs = new ArrayList<>();
        for (Malloc malloc : program.getEvents(Malloc.class)) {
            final int size;
            try {
                size = malloc.getSizeExpr().reduce().getValueAsInt();
            } catch (Exception e) {
                final String error = String.format("Variable-sized malloc '%s' is not supported", malloc);
                throw new MalformedProgramException(error);
            }

            final MemoryObject memoryObject = program.getMemory().allocate(size);
            memObjs.add(memoryObject);

            final Local local = EventFactory.newLocal(malloc.getResultRegister(), memoryObject);
            local.addFilters(Tag.Std.MALLOC);
            malloc.replaceBy(local);

        }

        createInits(program, memObjs);
        Memory.fixateMemoryValues().run(program);
    }

    private void createInits(Program program, List<MemoryObject> memObjs) {
        int nextThreadId = program.getThreads().size() + 1;
        for(MemoryObject a : memObjs) {
            for(int i = 0; i < a.size(); i++) {
                final Event init = EventFactory.newInit(a, i);
                final Thread thread = new Thread(nextThreadId++, init);

                program.add(thread);
                thread.setProgram(program);
                thread.getEntry().setSuccessor(EventFactory.newLabel("END_OF_T" + thread.getId()));
                thread.updateExit(thread.getEntry());
            }
        }
    }
}
