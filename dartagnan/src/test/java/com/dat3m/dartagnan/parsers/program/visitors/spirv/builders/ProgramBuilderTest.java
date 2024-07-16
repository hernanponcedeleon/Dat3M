package com.dat3m.dartagnan.parsers.program.visitors.spirv.builders;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.utils.ThreadGrid;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Skip;
import org.junit.Test;

import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class ProgramBuilderTest {

    private static final TypeFactory types = TypeFactory.getInstance();

    private final ProgramBuilder builder = new ProgramBuilder(new ThreadGrid(1, 1, 1, 1));
    private final ControlFlowBuilder cfBuilder = builder.getControlFlowBuilder();

    @Test
    public void testAddEventOutsideFunction() {
        testAddChildError("Attempt to add an event outside a function definition");
    }

    @Test
    public void testAddEventBeforeBlock() {
        FunctionType type = types.getFunctionType(types.getVoidType(), List.of());
        builder.startFunctionDefinition("test", type, List.of());
        testAddChildError("Attempt to add an event outside a control flow block");
    }

    @Test
    public void testAddEventAfterBlock() {
        FunctionType type = types.getFunctionType(types.getVoidType(), List.of());
        builder.startFunctionDefinition("test_func", type, List.of());
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

    // TODO: Test throws error if an input is unused,
    //  i.e. refers to a non-existent or to an incorrect id
}
