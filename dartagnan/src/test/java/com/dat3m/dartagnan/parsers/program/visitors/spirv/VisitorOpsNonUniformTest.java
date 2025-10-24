package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.tangles.*;
import com.dat3m.dartagnan.expression.tangles.TangleType;

import org.junit.Test;
import java.util.Set;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class VisitorOpsNonUniformTest {

    private final MockProgramBuilder builder = new MockProgramBuilder();

    @Test
    public void testNonUniformBool() {
        // given
        String input = "%result = OpGroupNonUniformAll %bool %uint_3 %false";
        builder.mockBoolType("%bool");
        builder.mockConstant("%false", "%bool", false);
        builder.mockIntType("%uint", 64);
        builder.mockConstant("%uint_3", "%uint", 3);

        // when
        NonUniformOpBool event = (NonUniformOpBool) visit(input);

        // then
        assertEquals(Set.of(Tag.VISIBLE, Tag.Vulkan.CBAR), event.getTags());
        assertEquals(TangleType.ALL, event.getTangleType());
    }

    @Test
    public void testNonUniformBoolWrongResultType() {
        // given
        String input = "%result = OpGroupNonUniformAll %uint %uint_3 %false";
        builder.mockBoolType("%bool");
        builder.mockConstant("%false", "%bool", false);
        builder.mockIntType("%uint", 64);
        builder.mockConstant("%uint_3", "%uint", 3);

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Return type bv64 of OpGroupNonUniformAll '%result' is not bool", e.getMessage());
        }
    }

    @Test
    public void testNonUniformBoolWrongPredicateType() {
        // given
        String input = "%result = OpGroupNonUniformAll %bool %uint_3 %uint_3";
        builder.mockBoolType("%bool");
        builder.mockIntType("%uint", 64);
        builder.mockConstant("%uint_3", "%uint", 3);

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Predicate type bv64 of OpGroupNonUniformAll '%result' is not bool", e.getMessage());
        }
    }

    @Test
    public void testNonUniformBoolWrongScope() {
        // given
        String input = "%result = OpGroupNonUniformAll %bool %uint_2  %false";
        builder.mockBoolType("%bool");
        builder.mockConstant("%false", "%bool", false);
        builder.mockIntType("%uint", 64);
        builder.mockConstant("%uint_2", "%uint", 2);

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Unsupported execution scope 'SPV_WORKGROUP'", e.getMessage());
        }
    }

    @Test
    public void testNonUniformInteger() {
        // given
        String input = "%result = OpGroupNonUniformIAdd %uint %uint_3 Reduce %input";
        builder.mockIntType("%uint", 64);
        builder.mockConstant("%uint_3", "%uint", 3);
        builder.mockUndefinedValue("%input", "%uint");

        // when
        NonUniformOpArithmetic event = (NonUniformOpArithmetic) visit(input);

        // then
        assertEquals(Set.of(Tag.VISIBLE, Tag.Vulkan.CBAR), event.getTags());
        assertEquals(TangleType.IADD, event.getTangleType());
    }

    @Test
    public void testNonUniformIntegerVector() {
        // given
        String input = "%result = OpGroupNonUniformIAdd %vector %uint_3 Reduce %input";
        builder.mockIntType("%uint", 64);
        builder.mockVectorType("%vector", "%uint", 4);
        builder.mockConstant("%uint_3", "%uint", 3);
        builder.mockUndefinedValue("%input", "%vector");

        // when
        NonUniformOpArithmetic event = (NonUniformOpArithmetic) visit(input);

        // then
        assertEquals(Set.of(Tag.VISIBLE, Tag.Vulkan.CBAR), event.getTags());
        assertEquals(TangleType.IADD, event.getTangleType());
    }

    @Test
    public void testNonUniformIntegerTypeMissmtach() {
        // given
        String input = "%result = OpGroupNonUniformIAdd %uint %uint_3 Reduce %input";
        builder.mockBoolType("%bool");
        builder.mockIntType("%uint", 64);
        builder.mockConstant("%uint_3", "%uint", 3);
        builder.mockUndefinedValue("%input", "%bool");

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Type mismatch in OpGroupNonUniformIAdd '%result' between result type and value", e.getMessage());
        }
    }

    @Test
    public void testNonUniformIntegerWrongResultType() {
        // given
        String input = "%result = OpGroupNonUniformIAdd %bool %uint_3 Reduce %input";
        builder.mockBoolType("%bool");
        builder.mockIntType("%uint", 64);
        builder.mockConstant("%uint_3", "%uint", 3);
        builder.mockUndefinedValue("%input", "%bool");

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Return type bool of OpGroupNonUniformIAdd '%result' is not scalar or vector of integer", e.getMessage());
        }
    }

    @Test
    public void testNonUniformIntegerWrongScope() {
        // given
        String input = "%result = OpGroupNonUniformIAdd %uint %uint_2 Reduce %input";
        builder.mockIntType("%uint", 64);
        builder.mockConstant("%uint_2", "%uint", 2);
        builder.mockUndefinedValue("%input", "%uint");

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Unsupported execution scope 'SPV_WORKGROUP'", e.getMessage());
        }
    }

    @Test
    public void testNonUniformBroadcastInt() {
        // given
        String input = "%result = OpGroupNonUniformBroadcast %uint %uint_3 %input %uint_0";
        builder.mockIntType("%uint", 64);
        builder.mockConstant("%uint_3", "%uint", 3);
        builder.mockConstant("%uint_0", "%uint", 0);
        builder.mockUndefinedValue("%input", "%uint");

        // when
        NonUniformOpBroadcast event = (NonUniformOpBroadcast) visit(input);

        // then
        assertEquals(Set.of(Tag.VISIBLE, Tag.Vulkan.CBAR), event.getTags());
        assertEquals(TangleType.BROADCAST, event.getTangleType());
    }

    @Test
    public void testNonUniformBroadcastBool() {
        // given
        String input = "%result = OpGroupNonUniformBroadcast %bool %uint_3 %input %uint_0";
        builder.mockBoolType("%bool");
        builder.mockIntType("%uint", 64);
        builder.mockConstant("%uint_3", "%uint", 3);
        builder.mockConstant("%uint_0", "%uint", 0);
        builder.mockUndefinedValue("%input", "%bool");

        // when
        NonUniformOpBroadcast event = (NonUniformOpBroadcast) visit(input);

        // then
        assertEquals(Set.of(Tag.VISIBLE, Tag.Vulkan.CBAR), event.getTags());
        assertEquals(TangleType.BROADCAST, event.getTangleType());
    }

    @Test
    public void testNonUniformBroadcastTypeMissmtach() {
        // given
        String input = "%result = OpGroupNonUniformBroadcast %bool %uint_3 %input %uint_0";
        builder.mockBoolType("%bool");
        builder.mockIntType("%uint", 64);
        builder.mockConstant("%uint_3", "%uint", 3);
        builder.mockConstant("%uint_0", "%uint", 0);
        builder.mockUndefinedValue("%input", "%uint");

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Type mismatch in OpGroupNonUniformBroadcast '%result' between result type and value", e.getMessage());
        }
    }

    @Test
    public void testNonUniformBroadcastWrongIdType() {
        // given
        String input = "%result = OpGroupNonUniformBroadcast %uint %uint_3 %input %id";
        builder.mockBoolType("%bool");
        builder.mockIntType("%uint", 64);
        builder.mockConstant("%uint_3", "%uint", 3);
        builder.mockUndefinedValue("%id", "%bool");
        builder.mockUndefinedValue("%input", "%uint");

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("The id in OpGroupNonUniformBroadcast '%result' should be of integer type", e.getMessage());
        }
    }

    @Test
    public void testNonUniformBroadcastWrongScope() {
        // given
        String input = "%result = OpGroupNonUniformBroadcast %uint %uint_2 %input %uint_0";
        builder.mockIntType("%uint", 64);
        builder.mockConstant("%uint_2", "%uint", 2);
        builder.mockConstant("%uint_0", "%uint", 0);
        builder.mockUndefinedValue("%input", "%uint");

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Unsupported execution scope 'SPV_WORKGROUP'", e.getMessage());
        }
    }

    private Event visit(String text) {
        builder.mockFunctionStart(true);
        return new MockSpirvParser(text).spv().spvInstructions().accept(new VisitorOpsNonUniform(builder));
    }
}
