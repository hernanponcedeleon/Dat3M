package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import com.dat3m.dartagnan.program.memory.ScopedPointerVariable;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class VisitorOpsAnnotationTest {

    private final MockProgramBuilder builder = new MockProgramBuilder();

    @Test
    public void testAlignment() {
        // given
        String input = "OpDecorate %v_uint_aligned Alignment 16";
        builder.mockIntType("%uint", 32);
        builder.mockPtrType("%_ptr_Function_uint", "%uint", "Function");

        // when
        visit(input);
        builder.mockVariable("%v_uint", "%_ptr_Function_uint");
        builder.mockVariable("%v_uint_aligned", "%_ptr_Function_uint");

        // then
        ScopedPointerVariable var = (ScopedPointerVariable) builder.getExpression("%v_uint");
        ScopedPointerVariable var_aligned = (ScopedPointerVariable) builder.getExpression("%v_uint_aligned");
        assertEquals(8, var.getAddress().getKnownAlignment());
        assertEquals(16, var_aligned.getAddress().getKnownAlignment());
    }

    private void visit(String text) {
        builder.mockFunctionStart(true);
        new MockSpirvParser(text).spv().spvInstructions().accept(new VisitorOpsAnnotation(builder));
    }
}
