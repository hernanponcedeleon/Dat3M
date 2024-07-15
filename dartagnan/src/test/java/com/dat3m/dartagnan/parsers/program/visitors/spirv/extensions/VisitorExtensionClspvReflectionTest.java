package com.dat3m.dartagnan.parsers.program.visitors.spirv.extensions;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.extenstions.VisitorExtensionClspvReflection;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.utils.ThreadGrid;
import com.dat3m.dartagnan.program.memory.ScopedPointerVariable;
import org.junit.Before;
import org.junit.Test;

import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class VisitorExtensionClspvReflectionTest {

    private final MockProgramBuilder builder = new MockProgramBuilder(new ThreadGrid(2, 3, 4, 1));

    @Before
    public void before() {
        builder.mockIntType("%uint", 32);

        builder.mockVectorType("%v1uint", "%uint", 1);
        builder.mockVectorType("%v2uint", "%uint", 2);
        builder.mockVectorType("%v3uint", "%uint", 3);

        builder.mockConstant("%uint_0", "%uint", 0);
        builder.mockConstant("%uint_1", "%uint", 1);
        builder.mockConstant("%uint_4", "%uint", 4);
        builder.mockConstant("%uint_8", "%uint", 8);
        builder.mockConstant("%uint_12", "%uint", 12);
    }

    @Test
    public void testPushConstant() {
        // given
        String input = """
                %ext = OpExtInstImport "NonSemantic.ClspvReflection.5"
                %1 = OpExtInst %void %ext PushConstantGlobalOffset %uint_0 %uint_12
                %2 = OpExtInst %void %ext PushConstantGlobalSize %uint_0 %uint_12
                %3 = OpExtInst %void %ext PushConstantEnqueuedLocalSize %uint_0 %uint_12
                %4 = OpExtInst %void %ext PushConstantNumWorkgroups %uint_0 %uint_12
                %5 = OpExtInst %void %ext PushConstantRegionOffset %uint_0 %uint_12
                %6 = OpExtInst %void %ext PushConstantRegionGroupOffset %uint_0 %uint_12
                """;

        builder.mockAggregateType("%6x_v3uint", "%v3uint", "%v3uint", "%v3uint", "%v3uint", "%v3uint", "%v3uint");
        builder.mockPtrType("%ptr_6x_v3uint", "%6x_v3uint", "PushConstant");
        ScopedPointerVariable pointer = builder.mockVariable("%var", "%ptr_6x_v3uint");

        // when
        new MockSpirvParser(input).spv().accept(new VisitorExtensionClspvReflection(builder));

        // then
        verifyPushConstant(pointer, 0, List.of(0, 0, 0));
        verifyPushConstant(pointer, 12, List.of(24, 1, 1));
        verifyPushConstant(pointer, 24, List.of(6, 1, 1));
        verifyPushConstant(pointer, 36, List.of(4, 1, 1));
        verifyPushConstant(pointer, 48, List.of(0, 0, 0));
        verifyPushConstant(pointer, 60, List.of(0, 0, 0));
    }

    @Test
    public void testPushConstantMissingVariable() {
        // given
        String input = """
                %ext = OpExtInstImport "NonSemantic.ClspvReflection.5"
                %1 = OpExtInst %void %ext PushConstantGlobalOffset %uint_0 %uint_12
                """;

        try {
            // when
            visit(input);
            fail("Should throw exception");

        } catch (ParsingException e) {
            // then
            assertEquals("Cannot identify PushConstant referenced by CLSPV extension", e.getMessage());
        }
    }

    @Test
    public void testPushConstantMultipleVariables() {
        // given
        String input = """
                %ext = OpExtInstImport "NonSemantic.ClspvReflection.5"
                %1 = OpExtInst %void %ext PushConstantGlobalOffset %uint_0 %uint_12
                """;

        builder.mockAggregateType("%6x_v3uint", "%v3uint", "%v3uint", "%v3uint", "%v3uint", "%v3uint", "%v3uint");
        builder.mockPtrType("%ptr_6x_v3uint", "%6x_v3uint", "PushConstant");
        builder.mockVariable("%var1", "%ptr_6x_v3uint");
        builder.mockVariable("%var2", "%ptr_6x_v3uint");

        try {
            // when
            visit(input);
            fail("Should throw exception");

        } catch (ParsingException e) {
            // then
            assertEquals("Cannot identify PushConstant referenced by CLSPV extension", e.getMessage());
        }
    }

    @Test
    public void testPushConstantMismatchingVariableType() {
        // given
        String input = """
                %ext = OpExtInstImport "NonSemantic.ClspvReflection.5"
                %1 = OpExtInst %void %ext PushConstantGlobalOffset %uint_0 %uint_12
                """;

        builder.mockPtrType("%ptr_uint", "%uint", "PushConstant");
        builder.mockVariable("%var", "%ptr_uint");

        try {
            // when
            visit(input);
            fail("Should throw exception");

        } catch (ParsingException e) {
            // then
            assertEquals("Unexpected type 'bv32' for PushConstant '%var'", e.getMessage());
        }
    }

    @Test
    public void testPushConstantIndexOutOfBound() {
        // given
        String input = """
                %ext = OpExtInstImport "NonSemantic.ClspvReflection.5"
                %1 = OpExtInst %void %ext PushConstantGlobalOffset %uint_0 %uint_12
                %2 = OpExtInst %void %ext PushConstantGlobalSize %uint_0 %uint_12
                %3 = OpExtInst %void %ext PushConstantEnqueuedLocalSize %uint_0 %uint_12
                """;

        builder.mockAggregateType("%2x_v3uint", "%v3uint", "%v3uint");
        builder.mockPtrType("%ptr_2x_v3uint", "%2x_v3uint", "PushConstant");
        builder.mockVariable("%var", "%ptr_2x_v3uint");

        try {
            // when
            visit(input);
            fail("Should throw exception");

        } catch (ParsingException e) {
            // then
            assertEquals("Out of bounds definition 'PushConstantEnqueuedLocalSize' " +
                    "in PushConstant '%var'", e.getMessage());
        }
    }

    @Test
    public void testPushConstantMismatchingElementType() {
        // given
        String input = """
                %ext = OpExtInstImport "NonSemantic.ClspvReflection.5"
                %1 = OpExtInst %void %ext PushConstantGlobalOffset %uint_0 %uint_12
                """;

        builder.mockAggregateType("%1x_v2uint", "%v2uint");
        builder.mockPtrType("%ptr_1x_v2uint", "%1x_v2uint", "PushConstant");
        builder.mockVariable("%var", "%ptr_1x_v2uint");

        try {
            // when
            visit(input);
            fail("Should throw exception");

        } catch (ParsingException e) {
            // then
            assertEquals("Unexpected element type in '%var' at index 0", e.getMessage());
        }
    }

    @Test
    public void testPodPushConstant() {
        String input = """
                %ext = OpExtInstImport "NonSemantic.ClspvReflection.5"
                %1 = OpExtInst %void %ext ArgumentInfo %kernel
                %2 = OpExtInst %void %ext ArgumentPodPushConstant %kernel %uint_0 %uint_0 %uint_4 %1
                %3 = OpExtInst %void %ext ArgumentInfo %kernel
                %4 = OpExtInst %void %ext ArgumentPodPushConstant %kernel %uint_1 %uint_4 %uint_8 %3
                """;

        builder.mockAggregateType("%v1uint_v2uint", "%v1uint", "%v2uint");
        builder.mockPtrType("%ptr_v1uint_v2uint", "%v1uint_v2uint", "PushConstant");
        ScopedPointerVariable pointer = builder.mockVariable("%var", "%ptr_v1uint_v2uint");

        // when
        new MockSpirvParser(input).spv().accept(new VisitorExtensionClspvReflection(builder));

        // then
        assertEquals(12, pointer.getAddress().size());
    }

    @Test
    public void testPodPushConstantMixed() {
        String input = """
                %ext = OpExtInstImport "NonSemantic.ClspvReflection.5"
                %1 = OpExtInst %void %ext PushConstantGlobalSize %uint_0 %uint_12
                %2 = OpExtInst %void %ext ArgumentInfo %kernel
                %3 = OpExtInst %void %ext ArgumentPodPushConstant %kernel %uint_1 %uint_0 %uint_4 %2
                """;

        builder.mockAggregateType("%v3uint_v1uint", "%v3uint", "%v1uint");
        builder.mockPtrType("%ptr_v3uint_v1uint", "%v3uint_v1uint", "PushConstant");
        ScopedPointerVariable pointer = builder.mockVariable("%var", "%ptr_v3uint_v1uint");

        // when
        new MockSpirvParser(input).spv().accept(new VisitorExtensionClspvReflection(builder));

        // then
        assertEquals(16, pointer.getAddress().size());
        verifyPushConstant(pointer, 0, List.of(24, 1, 1));
    }

    @Test
    public void testPodPushConstantMissingVariable() {
        String input = """
                %ext = OpExtInstImport "NonSemantic.ClspvReflection.5"
                %1 = OpExtInst %void %ext ArgumentInfo %kernel
                %2 = OpExtInst %void %ext ArgumentPodPushConstant %kernel %uint_0 %uint_0 %uint_4 %1
                %3 = OpExtInst %void %ext ArgumentInfo %kernel
                %4 = OpExtInst %void %ext ArgumentPodPushConstant %kernel %uint_1 %uint_4 %uint_8 %3
                """;

        try {
            // when
            visit(input);
            fail("Should throw exception");

        } catch (ParsingException e) {
            // then
            assertEquals("Cannot identify PushConstant referenced by CLSPV extension", e.getMessage());
        }
    }

    @Test
    public void testPodPushConstantMultipleVariables() {
        String input = """
                %ext = OpExtInstImport "NonSemantic.ClspvReflection.5"
                %1 = OpExtInst %void %ext ArgumentInfo %kernel
                %2 = OpExtInst %void %ext ArgumentPodPushConstant %kernel %uint_0 %uint_0 %uint_4 %1
                %3 = OpExtInst %void %ext ArgumentInfo %kernel
                %4 = OpExtInst %void %ext ArgumentPodPushConstant %kernel %uint_1 %uint_4 %uint_8 %3
                """;

        builder.mockAggregateType("%v3uint_v1uint", "%v3uint", "%v1uint");
        builder.mockPtrType("%ptr_v3uint_v1uint", "%v3uint_v1uint", "PushConstant");
        builder.mockVariable("%var1", "%ptr_v3uint_v1uint");
        builder.mockVariable("%var2", "%ptr_v3uint_v1uint");

        try {
            // when
            visit(input);
            fail("Should throw exception");

        } catch (ParsingException e) {
            // then
            assertEquals("Cannot identify PushConstant referenced by CLSPV extension", e.getMessage());
        }
    }

    @Test
    public void testPodPushConstantPodMismatchingVariableType() {
        String input = """
                %ext = OpExtInstImport "NonSemantic.ClspvReflection.5"
                %1 = OpExtInst %void %ext ArgumentInfo %kernel
                %2 = OpExtInst %void %ext ArgumentPodPushConstant %kernel %uint_0 %uint_0 %uint_4 %1
                %3 = OpExtInst %void %ext ArgumentInfo %kernel
                %4 = OpExtInst %void %ext ArgumentPodPushConstant %kernel %uint_1 %uint_4 %uint_8 %3
                """;

        builder.mockPtrType("%ptr_uint", "%uint", "PushConstant");
        builder.mockVariable("%var", "%ptr_uint");

        try {
            // when
            visit(input);
            fail("Should throw exception");

        } catch (ParsingException e) {
            // then
            assertEquals("Unexpected type 'bv32' for PushConstant '%var'", e.getMessage());
        }
    }

    @Test
    public void testPodPushConstantIndexOutOfBound() {
        String input = """
                %ext = OpExtInstImport "NonSemantic.ClspvReflection.5"
                %1 = OpExtInst %void %ext ArgumentInfo %kernel
                %2 = OpExtInst %void %ext ArgumentPodPushConstant %kernel %uint_0 %uint_0 %uint_4 %1
                %3 = OpExtInst %void %ext ArgumentInfo %kernel
                %4 = OpExtInst %void %ext ArgumentPodPushConstant %kernel %uint_1 %uint_4 %uint_8 %3
                """;

        builder.mockAggregateType("%1x_v1uint", "%v1uint");
        builder.mockPtrType("%ptr_1x_v1uint", "%1x_v1uint", "PushConstant");
        builder.mockVariable("%var", "%ptr_1x_v1uint");

        try {
            // when
            visit(input);
            fail("Should throw exception");

        } catch (ParsingException e) {
            // then
            assertEquals("Out of bounds definition 'ArgumentPodPushConstant' " +
                    "in PushConstant '%var'", e.getMessage());
        }
    }

    @Test
    public void testPodPushConstantMismatchingElementType() {
        String input = """
                %ext = OpExtInstImport "NonSemantic.ClspvReflection.5"
                %1 = OpExtInst %void %ext ArgumentInfo %kernel
                %2 = OpExtInst %void %ext ArgumentPodPushConstant %kernel %uint_0 %uint_0 %uint_4 %1
                %3 = OpExtInst %void %ext ArgumentInfo %kernel
                %4 = OpExtInst %void %ext ArgumentPodPushConstant %kernel %uint_1 %uint_4 %uint_8 %3
                """;

        builder.mockAggregateType("%v1uint_uint_uint", "%v1uint", "%uint", "%uint");
        builder.mockPtrType("%ptr_v1uint_uint_uint", "%v1uint_uint_uint", "PushConstant");
        builder.mockVariable("%var", "%ptr_v1uint_uint_uint");

        try {
            // when
            visit(input);
            fail("Should throw exception");

        } catch (ParsingException e) {
            // then
            assertEquals("Unexpected offset in PushConstant '%var' element '1'", e.getMessage());
        }
    }

    @Test
    public void testPodPushConstantElementSizeOutOfBound() {
        String input = """
                %ext = OpExtInstImport "NonSemantic.ClspvReflection.5"
                %1 = OpExtInst %void %ext ArgumentInfo %kernel
                %2 = OpExtInst %void %ext ArgumentPodPushConstant %kernel %uint_0 %uint_0 %uint_4 %1
                %3 = OpExtInst %void %ext ArgumentInfo %kernel
                %4 = OpExtInst %void %ext ArgumentPodPushConstant %kernel %uint_1 %uint_4 %uint_8 %3
                """;

        builder.mockAggregateType("%2x_v1uint", "%v1uint", "%v1uint");
        builder.mockPtrType("%ptr_2x_v1uint", "%2x_v1uint", "PushConstant");
        builder.mockVariable("%var", "%ptr_2x_v1uint");

        try {
            // when
            visit(input);
            fail("Should throw exception");

        } catch (ParsingException e) {
            // then
            assertEquals("Unexpected offset in PushConstant '%var' element '1'", e.getMessage());
        }
    }

    private void visit(String input) {
        new MockSpirvParser(input).spv().accept(new VisitorExtensionClspvReflection(builder));
    }

    private void verifyPushConstant(ScopedPointerVariable pointer, int offset, List<Integer> expected) {
        for (int i = 0; i < expected.size(); i++) {
            int actual = ((IntLiteral) pointer.getAddress().getInitialValue(offset + i * 4)).getValueAsInt();
            assertEquals(expected.get(i).intValue(), actual);
        }
    }
}
