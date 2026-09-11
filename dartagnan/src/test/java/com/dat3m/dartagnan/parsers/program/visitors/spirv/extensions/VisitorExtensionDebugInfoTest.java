package com.dat3m.dartagnan.parsers.program.visitors.spirv.extensions;

import com.dat3m.dartagnan.parsers.program.visitors.spirv.extenstions.VisitorExtensionDebugInfo;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import com.dat3m.dartagnan.program.event.metadata.SourceLocation;
import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;

public class VisitorExtensionDebugInfoTest {

    private final MockProgramBuilder builder = new MockProgramBuilder();
    private final VisitorExtensionDebugInfo visitor = new VisitorExtensionDebugInfo(builder);

    @Test
    public void testDebugLine() {
        // given
        String input = """
                %source = OpExtInst %void %ext DebugSource %file
                %line = OpExtInst %void %ext DebugLine %source %uint_42 %uint_42 %uint_0 %uint_0
                """;

        builder.mockIntType("%uint", 32);
        builder.mockConstant("%uint_42", "%uint", 42);
        builder.addDebugInfo("%file", "\"test.slang\"");

        // when
        visit(input);

        // then
        assertEquals(new SourceLocation.Generic("test.slang", 42),
                builder.getControlFlowBuilder().getCurrentLocation());
    }

    @Test
    public void testDebugNoLine() {
        // given
        String input = "%noLine = OpExtInst %void %ext DebugNoLine";
        builder.getControlFlowBuilder().setCurrentLocation("test.slang", 42);

        // when
        visit(input);

        // then
        assertFalse(builder.getControlFlowBuilder().hasCurrentLocation());
    }

    private void visit(String input) {
        new MockSpirvParser(input).spv().accept(visitor);
    }
}
