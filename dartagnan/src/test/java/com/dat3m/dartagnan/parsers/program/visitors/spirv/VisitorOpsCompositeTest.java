package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.aggregates.ExtractExpr;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.aggregates.InsertExpr;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
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
            assertEquals("Type mismatch in composite extraction for '%extract'", e.getMessage());
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
            assertEquals("Non-aggregate type bv32. Offending id: '%extract'", e.getMessage());
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
            assertEquals("Index 5 out of bounds for type [4 x bv32]. Offending id: '%extract'", e.getMessage());
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
            assertEquals("Non-aggregate type bv32. Offending id: '%extract'", e.getMessage());
        }
    }

    @Test
    public void testCompositeInsertArray() {
        // given
        String input = "%insert = OpCompositeInsert %array %value %base 2";
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%array", "%uint", 4);
        builder.mockConstant("%base", "%array", List.of(1, 2, 3, 4));
        builder.mockConstant("%value", "%uint", 99);

        // when
        visit(input);

        // then
        InsertExpr insert = (InsertExpr) builder.getExpression("%insert");
        assertEquals(List.of(2), insert.getIndices());
        assertEquals(builder.getType("%array"), insert.getType());
        assertEquals(builder.getExpression("%value"), insert.getInsertedValue());
        assertEquals(builder.getExpression("%base"), insert.getAggregate());
    }

    @Test
    public void testCompositeInsertRuntimeArray() {
        // given
        String input = "%insert = OpCompositeInsert %array %value %base 2";
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%array", "%uint", -1);
        builder.mockVectorType("%array2", "%uint", 4);
        builder.mockConstant("%base", "%array", List.of(1, 2, 3, 4));
        builder.mockConstant("%value", "%uint", 99);

        // when
        visit(input);

        // then
        InsertExpr insert = (InsertExpr) builder.getExpression("%insert");
        assertEquals(List.of(2), insert.getIndices());
        assertEquals(builder.getType("%array2"), insert.getType());
        assertEquals(builder.getExpression("%value"), insert.getInsertedValue());
        assertEquals(builder.getExpression("%base"), insert.getAggregate());
    }

    @Test
    public void testCompositeInsertNestedArray() {
        // given
        String input = "%insert = OpCompositeInsert %struct %value %base 1 2";
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%array", "%uint", 4);
        builder.mockAggregateType("%struct", "%uint", "%array");
        builder.mockConstant("%member_0", "%uint", 1);
        builder.mockConstant("%member_1", "%array", List.of(1, 2, 3, 4));
        builder.mockConstant("%base", "%struct", List.of("%member_0", "%member_1"));
        builder.mockConstant("%value", "%uint", 99);

        // when
        visit(input);

        // then
        InsertExpr insert = (InsertExpr) builder.getExpression("%insert");
        assertEquals(List.of(1, 2), insert.getIndices());
        assertEquals(builder.getType("%struct"), insert.getType());
        assertEquals(builder.getExpression("%value"), insert.getInsertedValue());
        assertEquals(builder.getExpression("%base"), insert.getAggregate());
    }

    @Test
    public void testCompositeInsertNestedRuntimeArray() {
        // given
        String input = "%insert = OpCompositeInsert %array2 %value %base 1 2";
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%array", "%uint", -1);
        builder.mockVectorType("%array2", "%array", -1);
        builder.mockVectorType("%array3", "%array", 2);
        builder.mockConstant("%member_0", "%array", List.of(1, 2, 3, 4));
        builder.mockConstant("%member_1", "%array", List.of(5, 6, 7, 8));
        builder.mockConstant("%base", "%array2", List.of("%member_0", "%member_1"));
        builder.mockConstant("%value", "%uint", 99);

        // when
        visit(input);

        // then
        InsertExpr insert = (InsertExpr) builder.getExpression("%insert");
        assertEquals(List.of(1, 2), insert.getIndices());
        assertEquals(builder.getType("%array3"), insert.getType());
        assertEquals(builder.getExpression("%value"), insert.getInsertedValue());
        assertEquals(builder.getExpression("%base"), insert.getAggregate());
    }

    @Test
    public void testCompositeInsertArrayRegister() {
        // given
        String input = "%insert = OpCompositeInsert %array %value %base 0";
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%array", "%uint", 4);
        builder.mockFunctionStart(true);
        List<Register> registers = IntStream.range(0, 4).boxed()
                .map(i -> builder.addRegister("%r" + i, "%uint"))
                .toList();
        builder.mockConstant("%base", "%array", registers);
        builder.mockConstant("%value", "%uint", 99);

        // when
        visit(input);

        // then
        InsertExpr insert = (InsertExpr) builder.getExpression("%insert");
        assertEquals(List.of(0), insert.getIndices());
        assertEquals(builder.getType("%array"), insert.getType());
        assertEquals(builder.getExpression("%value"), insert.getInsertedValue());
        assertEquals(builder.getExpression("%base"), insert.getAggregate());
    }

    @Test
    public void testCompositeInsertWrongType() {
        // given
        String input = "%insert = OpCompositeInsert %struct %value %base 0 0";
        builder.mockFunctionStart(true);
        builder.mockIntType("%uint32", 32);
        builder.mockIntType("%uint64", 64);
        builder.mockVectorType("%array", "%uint32", 4);
        builder.mockAggregateType("%struct", "%uint32", "%array");

        builder.mockConstant("%t1", "%uint32", 1);
        builder.mockConstant("%test", "%array", List.of(1, 2, 3, 4));
        builder.mockConstant("%base", "%struct", List.of("%t1", "%test"));
        builder.mockConstant("%value", "%uint64", 99);

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (Exception e) {
            // then
            assertEquals("Non-aggregate type bv32. Offending id: '%insert'", e.getMessage());
        }
    }

    @Test
    public void testCompositeInsertWrongType1() {
        // given
        String input = "%insert = OpCompositeInsert %struct1 %value %base 0 0";
        builder.mockFunctionStart(true);
        builder.mockIntType("%uint32", 32);
        builder.mockVectorType("%array", "%uint32", 4);
        builder.mockVectorType("%array1", "%uint32", 2);
        builder.mockAggregateType("%struct", "%array1", "%array");
        builder.mockAggregateType("%struct1", "%array", "%array1");

        builder.mockConstant("%test", "%array", List.of(1, 2, 3, 4));
        builder.mockConstant("%test1", "%array", List.of(1, 2));
        builder.mockConstant("%base", "%struct", List.of("%test1", "%test"));
        builder.mockConstant("%value", "%uint32", 99);

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (Exception e) {
            // then
            assertEquals("Type mismatch in composite insert for '%insert'", e.getMessage());
        }
    }

    @Test
    public void testCompositeInsertElementNotConstructExpr() {
        // given
        String input = "%insert = OpCompositeInsert %uint %value %base 0";
        builder.mockFunctionStart(true);
        builder.mockIntType("%uint", 32);
        builder.mockConstant("%base", "%uint", 1);
        builder.mockConstant("%value", "%uint", 99);

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Non-aggregate type bv32. Offending id: '%insert'", e.getMessage());
        }
    }

    @Test
    public void testCompositeInsertIndexOutOfBounds() {
        // given
        String input = "%insert = OpCompositeInsert %array %value %base 5";
        builder.mockFunctionStart(true);
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%array", "%uint", 4);
        builder.mockConstant("%base", "%array", List.of(1, 2, 3, 4));
        builder.mockConstant("%value", "%uint", 99);

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Index 5 out of bounds for type [4 x bv32]. Offending id: '%insert'", e.getMessage());
        }
    }

    @Test
    public void testCompositeInsertIndexTooDeep() {
        // given
        String input = "%insert = OpCompositeInsert %array %value %base 0 0";
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%array", "%uint", 4);
        builder.mockConstant("%base", "%array", List.of(1, 2, 3, 4));
        builder.mockConstant("%value", "%uint", 99);

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Non-aggregate type bv32. Offending id: '%insert'", e.getMessage());
        }
    }

    @Test
    public void testVectorShuffle() {
        // given
        String input = "%shuffle = OpVectorShuffle %v4uint %v1 %v2 0 1 4 5";
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%v4uint", "%uint", 4);
        builder.mockConstant("%v1", "%v4uint", List.of(1, 2, 3, 4));
        builder.mockConstant("%v2", "%v4uint", List.of(5, 6, 7, 8));
        builder.mockConstant("%bv32(1)", "%uint", 1);
        builder.mockConstant("%bv32(2)", "%uint", 2);
        builder.mockConstant("%bv32(5)", "%uint", 5);
        builder.mockConstant("%bv32(6)", "%uint", 6);

        // when
        visit(input);

        // then
        ConstructExpr shuffle = (ConstructExpr) builder.getExpression("%shuffle");
        assertEquals(builder.getExpression("%bv32(1)"), shuffle.getOperands().get(0));
        assertEquals(builder.getExpression("%bv32(2)"), shuffle.getOperands().get(1));
        assertEquals(builder.getExpression("%bv32(5)"), shuffle.getOperands().get(2));
        assertEquals(builder.getExpression("%bv32(6)"), shuffle.getOperands().get(3));
    }

    @Test
    public void testVectorShuffleReturnType() {
        // given
        String input = "%shuffle = OpVectorShuffle %uint %v1 %v2 0 0 0 0";
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%v4uint", "%uint", 4);
        builder.mockConstant("%v1", "%v4uint", List.of(1, 2, 3, 4));
        builder.mockConstant("%v2", "%v4uint", List.of(5, 6, 7, 8));

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Return type bv32 of OpVectorShuffle '%shuffle' is not a vector", e.getMessage());
        }
    }

    @Test
    public void testVectorShuffleFirstParameterType() {
        // given
        String input = "%shuffle = OpVectorShuffle %v4uint %v1 %v2 0 0 0 0";
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%v4uint", "%uint", 4);
        builder.mockConstant("%v1", "%uint", 1);
        builder.mockConstant("%v2", "%v4uint", List.of(5, 6, 7, 8));

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Parameter of OpVectorShuffle '%shuffle' is not a vector", e.getMessage());
        }
    }

    @Test
    public void testVectorShuffleSecondParameterType() {
        // given
        String input = "%shuffle = OpVectorShuffle %v4uint %v1 %v2 0 0 0 0";
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%v4uint", "%uint", 4);
        builder.mockConstant("%v1", "%v4uint", List.of(5, 6, 7, 8));
        builder.mockConstant("%v2", "%uint", 1);

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Parameter of OpVectorShuffle '%shuffle' is not a vector", e.getMessage());
        }
    }

    @Test
    public void testVectorShuffleMismatchFirstParameterType() {
        // given
        String input = "%shuffle = OpVectorShuffle %v4uint %v1 %v2 0 0 0 0";
        builder.mockIntType("%uint", 32);
        builder.mockBoolType("%bool");
        builder.mockVectorType("%v4uint", "%uint", 4);
        builder.mockVectorType("%v4bool", "%bool", 4);
        builder.mockConstant("%v1", "%v4uint", List.of(1, 2, 3, 4));
        builder.mockConstant("%v2", "%v4bool", List.of(true, true, true, true));

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Type mismatch in OpVectorShuffle '%shuffle' between result type and components", e.getMessage());
        }
    }

    @Test
    public void testVectorShuffleMismatchSecondParameterType() {
        // given
        String input = "%shuffle = OpVectorShuffle %v4uint %v1 %v2 0 0 0 0";
        builder.mockIntType("%uint", 32);
        builder.mockBoolType("%bool");
        builder.mockVectorType("%v4uint", "%uint", 4);
        builder.mockVectorType("%v4bool", "%bool", 4);
        builder.mockConstant("%v1", "%v4bool", List.of(true, true, true, true));
        builder.mockConstant("%v2", "%v4uint", List.of(1, 2, 3, 4));

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Type mismatch in OpVectorShuffle '%shuffle' between result type and components", e.getMessage());
        }
    }

    @Test
    public void testVectorShuffleSizeMismatch() {
        // given
        String input = "%shuffle = OpVectorShuffle %v4uint %v1 %v2 0 0 0";
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%v4uint", "%uint", 4);
        builder.mockConstant("%v1", "%v4uint", List.of(1, 2, 3, 4));
        builder.mockConstant("%v2", "%v4uint", List.of(5, 6, 7, 8));

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Size mismatch in OpVectorShuffle '%shuffle' between result type [4 x bv32] and components [0, 0, 0]", e.getMessage());
        }
    }

    @Test
    public void testCompositeConstructNestedVectorCorrectType() {
        // given
        String input = "%result = OpCompositeConstruct %composite %member1 %member2";
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%composite", "%uint", 2);
        builder.mockConstant("%member1", "%uint", 1);
        builder.mockConstant("%member2", "%composite", List.of(2, 3));
        builder.mockConstant("%bv32(1)", "%uint", 1);
        builder.mockConstant("%bv32(2)", "%uint", 2);
        builder.mockConstant("%bv32(3)", "%uint", 3);

        // when
        visit(input);

        // then
        ConstructExpr shuffle = (ConstructExpr) builder.getExpression("%result");
        assertEquals(builder.getExpression("%bv32(1)"), shuffle.getOperands().get(0));
        assertEquals(builder.getExpression("%bv32(2)"), shuffle.getOperands().get(1));
        assertEquals(builder.getExpression("%bv32(3)"), shuffle.getOperands().get(2));
    }

    @Test
    public void testCompositeConstructMismatchingTypeStruct() {
        // given
        String input = "%result = OpCompositeConstruct %composite %member1 %member2";
        builder.mockBoolType("%bool");
        builder.mockIntType("%uint", 32);
        builder.mockAggregateType("%composite", "%bool", "%uint");
        builder.mockConstant("%member1", "%uint", 1);
        builder.mockConstant("%member2", "%uint", 2);

        try {
            visit(input);
            fail("Should throw exception");
        } catch (Exception e) {
            assertEquals("Arguments do not match the constructor signature. Offending id: '%result'", e.getMessage());
        }
    }

    @Test
    public void testCompositeConstructMismatchingTypeArray() {
        // given
        String input = "%result = OpCompositeConstruct %composite %member1 %member2";
        builder.mockBoolType("%bool");
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%composite", "%uint", 2);
        builder.mockConstant("%member1", "%uint", 1);
        builder.mockConstant("%member2", "%bool", true);

        try {
            visit(input);
            fail("Should throw exception");
        } catch (Exception e) {
            assertEquals("All elements in an array must have the same type. Offending id: '%result'", e.getMessage());
        }
    }

    @Test
    public void testCompositeConstructResultNotComposite() {
        // given
        String input = "%result = OpCompositeConstruct %uint %member1 %member2";
        builder.mockIntType("%uint", 32);
        builder.mockConstant("%member1", "%uint", 1);
        builder.mockConstant("%member2", "%uint", 2);

        try {
            visit(input);
            fail("Should throw exception");
        } catch (Exception e) {
            assertEquals("Result type of CompositeConstruct must be a composite for '%result'", e.getMessage());
        }
    }

    @Test
    public void testCompositeConstructNestedVectorWrongType() {
        // given
        String input = "%result = OpCompositeConstruct %composite %member1 %member2";
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%composite", "%uint", 2);
        builder.mockVectorType("%composite-composite", "%composite", 2);
        builder.mockConstant("%member1", "%uint", 1);
        builder.mockConstant("%v1", "%composite", List.of(2, 3));
        builder.mockConstant("%v2", "%composite", List.of(4, 5));
        builder.mockConstant("%member2", "%composite-composite",
            List.of(builder.getExpression("%v1"), builder.getExpression("%v2")));

        try {
            visit(input);
            fail("Should throw exception");
        } catch (Exception e) {
            assertEquals("All elements in an array must have the same type. Offending id: '%result'", e.getMessage());
        }
    }

    private void visit(String input) {
        new MockSpirvParser(input).spv().accept(new VisitorOpsComposite(builder));
    }
}
