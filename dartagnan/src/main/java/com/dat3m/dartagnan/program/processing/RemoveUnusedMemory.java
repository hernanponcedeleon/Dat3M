package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionInspector;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.collect.Sets;

import java.util.HashSet;

public class RemoveUnusedMemory implements ProgramProcessor {

    private RemoveUnusedMemory() {}

    public static RemoveUnusedMemory newInstance() {
        return new RemoveUnusedMemory();
    }

    @Override
    public void run(Program program) {
        final Memory memory = program.getMemory();
        final MemoryObjectCollector collector = new MemoryObjectCollector();

        // Threads
        program.getThreadEvents(RegReader.class).forEach(r -> r.transformExpressions(collector));

        // Initial values
        memory.getObjects()
                .forEach(o -> o.getInitializedFields()
                        .forEach(f -> collector.memoryObjects.addAll(o.getInitialValue(f).getMemoryObjects())));

        // Assertions
        if (program.getSpecification() != null) {
            collector.memoryObjects.addAll(program.getSpecification().getMemoryObjects());
        }

        // Remove unused objects
        Sets.difference(memory.getObjects(), collector.memoryObjects).forEach(memory::deleteMemoryObject);
    }

    private static class MemoryObjectCollector implements ExpressionInspector {

        private final HashSet<MemoryObject> memoryObjects = new HashSet<>();

        @Override
        public Expression visitMemoryObject(MemoryObject address) {
            memoryObjects.add(address);
            return address;
        }

        @Override
        public Expression visitLocation(Location location) {
            memoryObjects.add(location.getMemoryObject());
            return location;
        }
    }
}
