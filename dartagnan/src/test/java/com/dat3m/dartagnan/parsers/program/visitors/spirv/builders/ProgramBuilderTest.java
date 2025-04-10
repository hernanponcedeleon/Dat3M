package com.dat3m.dartagnan.parsers.program.visitors.spirv.builders;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Skip;
import org.junit.Test;

import java.util.Arrays;
import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.newVoidFunctionCall;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class ProgramBuilderTest {

    private static final TypeFactory types = TypeFactory.getInstance();

    private final ProgramBuilder builder = new ProgramBuilder(Arrays.asList(1, 1, 1, 1));
    private final ControlFlowBuilder cfBuilder = builder.getControlFlowBuilder();

    @Test
    public void testAddEventOutsideFunction() {
        testAddChildError("Attempt to add an event outside a function definition");
    }

    @Test
    public void testAddEventBeforeBlock() {
        FunctionType type = types.getFunctionType(types.getVoidType(), List.of());
        builder.startCurrentFunction(new Function("test", type, List.of(), 0, null));
        testAddChildError("Attempt to add an event outside a control flow block");
    }

    @Test
    public void testAddEventAfterBlock() {
        FunctionType type = types.getFunctionType(types.getVoidType(), List.of());
        builder.startCurrentFunction(new Function("test_func", type, List.of(), 0, null));
        cfBuilder.getOrCreateLabel("test_label");
        cfBuilder.startBlock("test_label");
        cfBuilder.endBlock(new Skip());
        testAddChildError("Attempt to add an event outside a control flow block");
    }

    private void testAddChildError(String error) {
        // given
        Event event = new Skip();
        try {
            // when
            builder.addEvent(event);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals(error, e.getMessage());
        }
    }

    @Test
    public void testCallingUndefinedFunction() {
        // given
        FunctionType type = types.getFunctionType(types.getVoidType(), List.of());
        Function called = new Function("called", type, List.of(), 1, null);
        builder.setEntryPointId("test_func");

        builder.startCurrentFunction(new Function("test_func", type, List.of(), 0, null));
        cfBuilder.getOrCreateLabel("test_label");
        cfBuilder.startBlock("test_label");
        builder.addEvent(newVoidFunctionCall(called, List.of()));
        cfBuilder.endBlock(new Skip());
        builder.endCurrentFunction();

        try {
            // when
            builder.build();
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Call to undefined function 'called'", e.getMessage());
        }
    }
}
