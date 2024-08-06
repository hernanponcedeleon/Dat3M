package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.ControlBarrier;
import com.dat3m.dartagnan.program.event.core.GenericVisibleEvent;
import org.junit.Test;

import java.util.Set;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class VisitorOpsBarrierTest {

    private final MockProgramBuilder builder = new MockProgramBuilder();

    @Test
    public void testControlBarrier() {
        // given
        String input = "OpControlBarrier %uint_2 %uint_2 %uint_264";
        builder.mockIntType("%uint", 64);
        builder.mockConstant("%uint_2", "%uint", 2);
        builder.mockConstant("%uint_264", "%uint", 264);

        // when
        ControlBarrier event = (ControlBarrier) visit(input);

        // then
        assertEquals(Set.of(Tag.VISIBLE, Tag.FENCE, Tag.Spirv.CONTROL, Tag.Spirv.ACQ_REL,
                Tag.Spirv.WORKGROUP, Tag.Spirv.SEM_WORKGROUP), event.getTags());
    }

    @Test
    public void testControlBarrierNoneSemantics() {
        // given
        String input = "OpControlBarrier %uint_2 %uint_2 %uint_0";
        builder.mockIntType("%uint", 64);
        builder.mockConstant("%uint_0", "%uint", 0);
        builder.mockConstant("%uint_2", "%uint", 2);

        // when
        ControlBarrier event = (ControlBarrier) visit(input);

        // then
        assertEquals(Set.of(Tag.VISIBLE, Tag.Spirv.CONTROL, Tag.Spirv.WORKGROUP), event.getTags());
    }

    @Test
    public void testMemoryBarrier() {
        // given
        String input = "OpMemoryBarrier %uint_2 %uint_264";
        builder.mockIntType("%uint", 64);
        builder.mockConstant("%uint_2", "%uint", 2);
        builder.mockConstant("%uint_264", "%uint", 264);

        // when
        GenericVisibleEvent event = (GenericVisibleEvent) visit(input);

        // then
        assertEquals(Set.of(Tag.VISIBLE, Tag.FENCE, Tag.Spirv.ACQ_REL,
                Tag.Spirv.WORKGROUP, Tag.Spirv.SEM_WORKGROUP), event.getTags());
    }

    @Test
    public void testMemoryBarrierNoneSemantics() {
        // given
        String input = "OpMemoryBarrier %uint_2 %uint_0";
        builder.mockIntType("%uint", 64);
        builder.mockConstant("%uint_0", "%uint", 0);
        builder.mockConstant("%uint_2", "%uint", 2);

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal OpMemoryBarrier with semantics None",
                    e.getMessage());
        }
    }

    private Event visit(String text) {
        builder.mockFunctionStart(true);
        return new MockSpirvParser(text).spv().spvInstructions().accept(new VisitorOpsBarrier(builder));
    }
}
