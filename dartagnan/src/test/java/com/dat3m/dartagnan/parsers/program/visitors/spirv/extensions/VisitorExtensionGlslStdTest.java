package com.dat3m.dartagnan.parsers.program.visitors.spirv.extensions;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.VisitorOpsExtension;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import org.junit.Test;

import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class VisitorExtensionGlslStdTest {

    @Test
    public void testWrongTypeFindILsb() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockIntType("%int", 64);
        builder.mockAggregateType("%struct", "%int", "%int");
        builder.mockConstant("%a", "%int", 1);
        builder.mockConstant("%b", "%int", 2);
        builder.mockConstant("%value", "%struct", List.of("%a", "%b"));
        String input = """
                %ext = OpExtInstImport "GLSL.std.450"
                %reg = OpExtInst %int %ext FindILsb %value
                """;

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Value type { 0: bv64, 8: bv64 } in %value of FindILsb is not integer scalar or integer vector",
                    e.getMessage());
        }
    }

    @Test
    public void testWrongReturnTypeFindILsb() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockIntType("%int64", 64);
        builder.mockIntType("%int32", 32);
        builder.mockConstant("%value", "%int64", 1);
        String input = """
                %ext = OpExtInstImport "GLSL.std.450"
                %reg = OpExtInst %int32 %ext FindILsb %value
                """;

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Mismatching result type in OpExtInst '%reg'", e.getMessage());
        }
    }

    @Test
    public void testWrongTypeMinMax() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockIntType("%int", 64);
        builder.mockAggregateType("%struct", "%int", "%int");
        builder.mockConstant("%a", "%int", 1);
        builder.mockConstant("%b", "%int", 2);
        builder.mockConstant("%value", "%struct", List.of("%a", "%b"));
        String input = """
                %ext = OpExtInstImport "GLSL.std.450"
                %reg = OpExtInst %int %ext SMax %value %value
                """;

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal definition for SMax, type { 0: bv64, 8: bv64 } is not scalar or vector of scalar", e.getMessage());
        }
    }

    @Test
    public void testWrongReturnTypeMinMax() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockIntType("%int64", 64);
        builder.mockIntType("%int32", 32);
        builder.mockConstant("%value1", "%int64", 1);
        builder.mockConstant("%value2", "%int64", 2);
        String input = """
                %ext = OpExtInstImport "GLSL.std.450"
                %reg = OpExtInst %int32 %ext SMax %value1 %value2
                """;

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Mismatching result type in OpExtInst '%reg'", e.getMessage());
        }
    }

    @Test
    public void testMismatchTypeMinMax() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockIntType("%int64", 64);
        builder.mockIntType("%int32", 32);
        builder.mockConstant("%value1", "%int64", 1);
        builder.mockConstant("%value2", "%int32", 2);
        String input = """
                %ext = OpExtInstImport "GLSL.std.450"
                %reg = OpExtInst %int64 %ext SMax %value1 %value2
                """;

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal definition for SMax, types do not match: 'bv64(1)' is 'bv64' and 'bv32(2)' is 'bv32'", e.getMessage());
        }
    }

    private void visit(MockProgramBuilder builder, String input) {
        new MockSpirvParser(input).spv().accept(new VisitorOpsExtension(builder));
    }
}