package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.aggregates.ExtractExpr;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import com.dat3m.dartagnan.program.Register;
import org.junit.Test;

import java.util.List;
import java.util.stream.IntStream;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class VisitorOpsCompositeTest {

    private final MockProgramBuilder builder = new MockProgramBuilder();

    @Test
    public void testCompositeExtractArray() {
        // given
        String input = "%extract = OpCompositeExtract %uint %base 2";
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%array", "%uint", 4);
        builder.mockConstant("%base", "%array", List.of(1, 2, 3, 4));

        // when
        visit(input);

        // then
        ExtractExpr extract = (ExtractExpr) builder.getExpression("%extract");
        assertEquals(List.of(2), extract.getIndices());
        assertEquals(builder.getType("%uint"), extract.getType());
    }

    @Test
    public void testCompositeExtractRuntimeArray() {
        // given
        String input = "%extract = OpCompositeExtract %uint %base 2";
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%array", "%uint", -1);
        builder.mockConstant("%base", "%array", List.of(1, 2, 3, 4));

        // when
        visit(input);

        // then
        ExtractExpr extract = (ExtractExpr) builder.getExpression("%extract");
        assertEquals(List.of(2), extract.getIndices());
        assertEquals(builder.getType("%uint"), extract.getType());
    }

    @Test
    public void testCompositeExtractNestedArray() {
        // given
        String input = "%extract = OpCompositeExtract %uint %base 1 2";
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%array", "%uint", 4);
        builder.mockAggregateType("%struct", "%uint", "%array");
        builder.mockConstant("%member_0", "%uint", 1);
        builder.mockConstant("%member_1", "%array", List.of(1, 2, 3, 4));
        builder.mockConstant("%base", "%struct", List.of("%member_0", "%member_1"));

        // when
        visit(input);

        // then
        ExtractExpr extract = (ExtractExpr) builder.getExpression("%extract");
        assertEquals(List.of(1, 2), extract.getIndices());
        assertEquals(builder.getType("%uint"), extract.getType());
    }

    @Test
    public void testCompositeExtractNestedRuntimeArray() {
        // given
        String input = "%extract = OpCompositeExtract %uint %base 1 2";
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%array", "%uint", -1);
        builder.mockVectorType("%array2", "%array", -1);
        builder.mockConstant("%member_0", "%array", List.of(1, 2, 3, 4));
        builder.mockConstant("%member_1", "%array", List.of(5, 6, 7, 8));
        builder.mockConstant("%base", "%array2", List.of("%member_0", "%member_1"));

        // when
        visit(input);

        // then
        ExtractExpr extract = (ExtractExpr) builder.getExpression("%extract");
        assertEquals(List.of(1, 2), extract.getIndices());
        assertEquals(builder.getType("%uint"), extract.getType());
    }

    @Test
    public void testCompositeExtractArrayRegister() {
        // given
        String input = "%extract = OpCompositeExtract %uint %base 0";
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%array", "%uint", 4);
        builder.mockFunctionStart(true);
        List<Register> registers = IntStream.range(0, 4).boxed()
                .map(i -> builder.addRegister("%r" + i, "%uint"))
                .toList();
        builder.mockConstant("%base", "%array", registers);

        // when
        visit(input);

        // then
        ExtractExpr extract = (ExtractExpr) builder.getExpression("%extract");
        assertEquals(List.of(0), extract.getIndices());
        assertEquals(builder.getType("%uint"), extract.getType());
    }

    @Test
    public void testCompositeExtractWrongType() {
        // given
        String input = "%extract = OpCompositeExtract %uint64 %base 0";

        builder.mockFunctionStart(true);
        builder.mockIntType("%uint32", 32);
        builder.mockIntType("%uint64", 64);
        builder.mockVectorType("%array", "%uint32", 4);
        builder.mockAggregateType("%struct", "%uint32", "%array");

        builder.mockConstant("%t1", "%uint32", 1);
        builder.mockConstant("%test", "%array", List.of(1, 2, 3, 4));
        builder.mockConstant("%base", "%struct", List.of("%t1", "%test"));

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (Exception e) {
            // then
            assertEquals("Type mismatch in composite extraction for: %extract", e.getMessage());
        }
    }

    @Test
    public void testCompositeExtractElementNotConstructExpr() {
        // given
        String input = "%extract = OpCompositeExtract %uint %base 0";
        builder.mockFunctionStart(true);
        builder.mockIntType("%uint", 32);
        builder.mockConstant("%base", "%uint", 1);

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Index out of bounds in OpCompositeExtract for '%extract'", e.getMessage());
        }
    }

    @Test
    public void testCompositeExtractIndexOutOfBounds() {
        // given
        String input = "%extract = OpCompositeExtract %uint %base 5";
        builder.mockFunctionStart(true);
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%array", "%uint", 4);
        builder.mockConstant("%base", "%array", List.of(1, 2, 3, 4));

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Index out of bounds in OpCompositeExtract for '%extract'", e.getMessage());
        }
    }

    @Test
    public void testCompositeExtractIndexTooDeep() {
        // given
        String input = "%extract = OpCompositeExtract %uint %base 0 0";
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%array", "%uint", 4);
        builder.mockConstant("%base", "%array", List.of(1, 2, 3, 4));

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Index out of bounds in OpCompositeExtract for '%extract'", e.getMessage());
        }
    }

    private void visit(String input) {
        new MockSpirvParser(input).spv().accept(new VisitorOpsComposite(builder));
    }
}
