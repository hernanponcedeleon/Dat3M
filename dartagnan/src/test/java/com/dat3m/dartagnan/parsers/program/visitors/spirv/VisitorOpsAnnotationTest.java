package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.Alignment;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.Offset;
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

        // when
        visit(input);

        // then
        Alignment alignment = (Alignment) builder.getDecorationsBuilder().getDecoration(DecorationType.ALIGNMENT);
        assertEquals(16, (long) alignment.getValue("%v_uint_aligned"));
    }

    @Test
    public void testOffset() {
        // given
        String input = """
               OpMemberDecorate %struct 0 Offset 0
               OpMemberDecorate %struct 1 Offset 1
               OpMemberDecorate %struct 2 Offset 3
               OpMemberDecorate %struct 3 Offset 6
               OpMemberDecorate %struct 4 Offset 10
               OpMemberDecorate %struct 5 Offset 15
               OpMemberDecorate %struct 6 Offset 21
               OpMemberDecorate %struct 7 Offset 28
              """;

        // when
        visit(input);

        // then
        Offset offset = (Offset) builder.getDecorationsBuilder().getDecoration(DecorationType.OFFSET);
        assertEquals(0, (long) offset.getValue("%struct").get(0));
        assertEquals(1, (long) offset.getValue("%struct").get(1));
        assertEquals(3, (long) offset.getValue("%struct").get(2));
        assertEquals(6, (long) offset.getValue("%struct").get(3));
        assertEquals(10, (long) offset.getValue("%struct").get(4));
        assertEquals(15, (long) offset.getValue("%struct").get(5));
        assertEquals(21, (long) offset.getValue("%struct").get(6));
        assertEquals(28, (long) offset.getValue("%struct").get(7));
    }

    private void visit(String text) {
        builder.mockFunctionStart(true);
        new MockSpirvParser(text).spv().spvInstructions().accept(new VisitorOpsAnnotation(builder));
    }
}
