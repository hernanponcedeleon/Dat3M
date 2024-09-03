package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import com.dat3m.dartagnan.program.memory.ScopedPointerVariable;
import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class VisitorOpsExtensionTest {

    private final MockProgramBuilder builder = new MockProgramBuilder();

    @Test
    public void testSupportedInstruction() {
        // given
        String input = """
                %1 = OpExtInstImport "NonSemantic.ClspvReflection.5"
                %2 = OpExtInst %void %1 PushConstantNumWorkgroups %uint_0 %uint_12
                """;

        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%v3uint", "%uint", 3);
        builder.mockAggregateType("%1x_v3uint", "%v3uint");
        builder.mockPtrType("%ptr_1x_v3uint", "%1x_v3uint", "PushConstant");
        builder.mockConstant("%uint_0", "%uint", 0);
        builder.mockConstant("%uint_12", "%uint", 12);

        ScopedPointerVariable pointer = builder.mockVariable("%var", "%ptr_1x_v3uint");

        // when
        visit(input);

        // then
        assertEquals(1, ((IntLiteral) pointer.getAddress().getInitialValue(0)).getValueAsInt());
        assertEquals(1, ((IntLiteral) pointer.getAddress().getInitialValue(4)).getValueAsInt());
        assertEquals(1, ((IntLiteral) pointer.getAddress().getInitialValue(8)).getValueAsInt());
    }

    @Test
    public void testUnsupportedExtension() {
        // given
        String input = """
                %1 = OpExtInstImport "unsupported"
                """;
        try {
            // when
            visit(input);
            fail("Should throw exception");

        } catch (ParsingException e) {
            // then
            assertEquals("Unsupported Spir-V extension 'unsupported'", e.getMessage());
        }
    }

    @Test
    public void testUndefinedExtensionId() {
        // given
        String input = """
                %2 = OpExtInst %void %1 ArgumentInfo %3
                """;
        try {
            // when
            visit(input);
            fail("Should throw exception");

        } catch (ParsingException e) {
            // then
            assertEquals("Unexpected extension id '%1'", e.getMessage());
        }
    }

    @Test
    public void tesUnsupportedInstruction() {
        // given
        String input = """
                %1 = OpExtInstImport "NonSemantic.ClspvReflection.5"
                %2 = OpExtInst %void %1 PrintfInfo %3 %4
                """;
        try {
            // when
            visit(input);
            fail("Should throw exception");

        } catch (ParsingException e) {
            // then
            assertEquals("External instruction 'PrintfInfo' " +
                    "is not implemented for 'NonSemantic.ClspvReflection.5'", e.getMessage());
        }
    }

    private void visit(String input) {
        new MockSpirvParser(input).spv().accept(new VisitorOpsExtension(builder));
    }
}
