package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionInspector;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.specification.*;
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
        program.getThreadEvents(RegReader.class).forEach(r -> r.transformExpressions(collector));
        // Also add MemoryObjects referenced by initial values (this does happen in Litmus code)
        for (MemoryObject obj : memory.getObjects()) {
            for (Integer field : obj.getInitializedFields()) {
                obj.getInitialValue(field).accept(collector);
            }
        }
        // Traverse the program spec for references to memory objects
        addSpecMemoryObjects(program.getSpecification(), collector);
        Sets.difference(memory.getObjects(), collector.memoryObjects).forEach(memory::deleteMemoryObject);
    }

    private void addSpecMemoryObjects(AbstractAssert spec, MemoryObjectCollector collector) {
        if (spec instanceof AssertInline assertInline) {
            assertInline.getAssertion().getExpression().accept(collector);
        }
        if (spec instanceof AssertBasic assertBasic) {
            assertBasic.getLeft().accept(collector);
            assertBasic.getRight().accept(collector);
        }
        if (spec instanceof AssertNot assertNot) {
            addSpecMemoryObjects(assertNot.getChild(), collector);
        }
        if (spec instanceof AssertCompositeAnd assertCompositeAnd) {
            addSpecMemoryObjects(assertCompositeAnd.getLeft(), collector);
            addSpecMemoryObjects(assertCompositeAnd.getRight(), collector);
        }
        if (spec instanceof AssertCompositeOr assertCompositeOr) {
            addSpecMemoryObjects(assertCompositeOr.getLeft(), collector);
            addSpecMemoryObjects(assertCompositeOr.getRight(), collector);
        }
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
