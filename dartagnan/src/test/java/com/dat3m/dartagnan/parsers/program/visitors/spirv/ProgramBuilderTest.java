package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Skip;
import org.junit.Test;

import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class ProgramBuilderTest {

    private static final TypeFactory TYPE_FACTORY = TypeFactory.getInstance();

    private final ProgramBuilderSpv builder = new ProgramBuilderSpv();

    @Test
    public void testAddEventOutsideFunction() {
        testAddChildError("Attempt to add an event outside a function definition");
    }

    @Test
    public void testAddEventBeforeBlock() {
        FunctionType type = TYPE_FACTORY.getFunctionType(TYPE_FACTORY.getVoidType(), List.of());
        builder.startFunctionDefinition("test", type, List.of());
        testAddChildError("Attempt to add an event outside a control flow block");
    }

    @Test
    public void testAddEventAfterBlock() {
        FunctionType type = TYPE_FACTORY.getFunctionType(TYPE_FACTORY.getVoidType(), List.of());
        builder.startFunctionDefinition("test_func", type, List.of());
        builder.startBlock(builder.getOrCreateLabel("test_label"));
        builder.endBlock(new Skip());
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
