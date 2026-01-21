package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.CallEvent;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.base.Preconditions;
import com.google.common.collect.Iterables;

import java.util.HashMap;
import java.util.Map;

/// Replaces occurrences of {@link Function} expressions by addresses of new objects that represent them.
public class FunctionAllocation implements ProgramProcessor {

    private FunctionAllocation() {}

    public static FunctionAllocation newInstance() { return new FunctionAllocation(); }

    @Override
    public void run(Program program) {
        final var toAddressTransformer = new FunctionToAddressTransformer(program);
        for (MemoryObject object : program.getMemory().getObjects()) {
            for (int field : object.getInitializedFields()) {
                object.setInitialValue(field, object.getInitialValue(field).accept(toAddressTransformer));
            }
        }
        for (Function func : Iterables.concat(program.getThreads(), program.getFunctions())) {
            for (Event event : func.getEvents()) {
                applyTransformerToEvent(event, toAddressTransformer);
            }
        }
        for (Map.Entry<Function, MemoryObject> entry : toAddressTransformer.func2AddressMap.entrySet()) {
            entry.getValue().setName(String.format("__funcAddr_%s", entry.getKey().getName()));
        }
    }

    private void applyTransformerToEvent(Event e, ExpressionVisitor<Expression> transformer) {
        if (e instanceof CallEvent call) {
            // IMPORTANT: For call events we do not want to replace the call target here.
            // This is why we do not treat them the same as RegReaders
            call.getArguments().replaceAll(arg -> arg.accept(transformer));
        } else if (e instanceof RegReader reader) {
            reader.transformExpressions(transformer);
        }
    }

    // ================================================================================
    // Helper classes

    private static class FunctionToAddressTransformer extends ExprTransformer {

        private final Map<Function, MemoryObject> func2AddressMap = new HashMap<>();
        private final Program program;

        private FunctionToAddressTransformer(Program p) {
            program = Preconditions.checkNotNull(p);
        }

        @Override
        public Expression visitFunction(Function function) {
            return func2AddressMap.computeIfAbsent(function, k -> program.getMemory().allocate(1));
        }
    }
}
