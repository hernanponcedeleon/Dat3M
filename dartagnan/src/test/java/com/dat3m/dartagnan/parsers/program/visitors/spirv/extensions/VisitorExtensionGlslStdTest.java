package com.dat3m.dartagnan.parsers.program.visitors.spirv.extensions;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.extenstions.VisitorExtensionGlslStd;
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

    private void visit(MockProgramBuilder builder, String input) {
        new MockSpirvParser(input).spv().accept(new VisitorExtensionGlslStd(builder));
    }

}
