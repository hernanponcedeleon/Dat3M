package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.misc.GEPExpr;
import com.dat3m.dartagnan.expression.processing.ExpressionInspector;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.core.Alloc;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.collect.Iterables;

// Checks pointer representations against the program's address width.
// Same-width integers remain indistinguishable from pointers until we introduce a dedicated pointer type.
public final class PointerWidthVerification implements ProgramProcessor {

    private PointerWidthVerification() { }

    public static PointerWidthVerification newInstance() {
        return new PointerWidthVerification();
    }

    @Override
    public void run(Program program) {
        final PointerInspector inspector = new PointerInspector(program.getArchType().getBitWidth());
        for (Function function : Iterables.concat(program.getFunctions(), program.getThreads())) {
            for (Alloc alloc : function.getEvents(Alloc.class)) {
                inspector.checkPointer(alloc.getResultRegister(), "Allocation result in", alloc);
            }
            for (MemoryEvent memoryEvent : function.getEvents(MemoryEvent.class)) {
                for (MemoryAccess access : memoryEvent.getMemoryAccesses()) {
                    inspector.checkPointer(access.address(), "Memory address in", memoryEvent);
                }
            }
            for (RegReader reader : function.getEvents(RegReader.class)) {
                reader.inspectExpressions(inspector);
            }
        }
        for (MemoryObject object : program.getMemory().getObjects()) {
            object.accept(inspector);
            for (int offset : object.getInitializedFields()) {
                object.getInitialValue(offset).accept(inspector);
            }
        }
        if (program.getSpecification() != null) {
            program.getSpecification().accept(inspector);
        }
        if (program.getFilterSpecification() != null) {
            program.getFilterSpecification().accept(inspector);
        }
        program.getLocations().forEach(location -> location.accept(inspector));
    }

    private static final class PointerInspector implements ExpressionInspector {

        private final int pointerWidth;

        private PointerInspector(int pointerWidth) {
            this.pointerWidth = pointerWidth;
        }

        private void checkPointer(Expression expression, String description, Object context) {
            // TODO: Replace the IntegerType check when we introduce a dedicated pointer type.
            // Pointers currently use integer representations, including ScopedPointerType.
            if (!(expression.getType() instanceof IntegerType type) || type.getBitWidth() != pointerWidth) {
                throw new MalformedProgramException(String.format("%s %s has type %s, expected a %d-bit pointer",
                        description, context, expression.getType(), pointerWidth));
            }
        }

        @Override
        public Expression visitMemoryObject(MemoryObject object) {
            checkPointer(object, "Memory object", object);
            return object;
        }

        @Override
        public Expression visitGEPExpression(GEPExpr gep) {
            checkPointer(gep.getBase(), "GEP base in", gep);
            return ExpressionInspector.super.visitExpression(gep);
        }
    }
}
