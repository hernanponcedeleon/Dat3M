package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.collect.Sets;

import java.util.HashSet;
import java.util.Set;

public class RemoveUnusedMemory implements ProgramProcessor {

    private RemoveUnusedMemory() {}

    public static RemoveUnusedMemory newInstance() {
        return new RemoveUnusedMemory();
    }

    @Override
    public void run(Program program) {
        final Set<MemoryObject> memoryObjects = new HashSet<>();
        final Memory memory = program.getMemory();

        // Threads
        program.getThreadEvents(MemoryEvent.class)
                .forEach(e -> e.getMemoryAccesses()
                        .forEach(a -> memoryObjects.addAll(a.address().getMemoryObjects())));

        // Initial values
        memory.getObjects()
                .forEach(o -> o.getInitializedFields()
                        .forEach(f -> memoryObjects.addAll(o.getInitialValue(f).getMemoryObjects())));

        // Assertions
        if (program.getSpecification() != null) {
            memoryObjects.addAll(program.getSpecification().getMemoryObjects());
        }

        // Remove unused objects
        Sets.difference(memory.getObjects(), memoryObjects).forEach(memory::deleteMemoryObject);
    }
}
