package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilderSpv;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import org.junit.Test;

import java.util.List;
import java.util.Map;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class VisitorOpsConstantTest {

    private static final ExpressionFactory FACTORY = ExpressionFactory.getInstance();
    private final MockProgramBuilderSpv builder = new MockProgramBuilderSpv();

    @Test
    public void testOpConstantBool() {
        doTestOpConstantBool("""
                %b1 = OpConstantTrue %bool
                %b2 = OpConstantTrue %bool
                %b3 = OpConstantFalse %bool
                %b4 = OpConstantFalse %bool
                """, false);
    }

    @Test
    public void testOpSpecConstantBool() {
        doTestOpConstantBool("""
                %b1 = OpSpecConstantTrue %bool
                %b2 = OpSpecConstantTrue %bool
                %b3 = OpSpecConstantFalse %bool
                %b4 = OpSpecConstantFalse %bool
                """, true);
    }

    private void doTestOpConstantBool(String input, boolean isSpec) {
        // given
        builder.mockBoolType("%bool");

        // when
        Map<String, Expression> data = parseConstants(input);

        // then
        assertEquals(4, data.size());
        assertEquals(FACTORY.makeTrue(), data.get("%b1"));
        assertEquals(FACTORY.makeTrue(), data.get("%b2"));
        assertEquals(FACTORY.makeFalse(), data.get("%b3"));
        assertEquals(FACTORY.makeFalse(), data.get("%b4"));

        for (String id : List.of("%b1", "%b2", "%b3", "%b4")) {
            assertEquals(isSpec, builder.isSpecConstant(id));
        }
    }

    @Test
    public void testOpConstant() {
        doTestOpConstant("""
                %i1 = OpConstant %int16 5
                %i2 = OpConstant %int16 5
                %i3 = OpConstant %int16 10
                %i4 = OpConstant %int32 10
                %i5 = OpConstant %int32 20
                """, false);
    }

    @Test
    public void testOpSpecConstant() {
        doTestOpConstant("""
                %i1 = OpSpecConstant %int16 5
                %i2 = OpSpecConstant %int16 5
                %i3 = OpSpecConstant %int16 10
                %i4 = OpSpecConstant %int32 10
                %i5 = OpSpecConstant %int32 20
                """, true);
    }

    private void doTestOpConstant(String input, boolean isSpec) {
        // given
        IntegerType iType16 = builder.mockIntType("%int16", 16);
        IntegerType iType32 = builder.mockIntType("%int32", 32);

        // when
        Map<String, Expression> data = parseConstants(input);

        // then
        assertEquals(5, data.size());
        assertEquals(FACTORY.makeValue(5, iType16), data.get("%i1"));
        assertEquals(FACTORY.makeValue(5, iType16), data.get("%i2"));
        assertEquals(FACTORY.makeValue(10, iType16), data.get("%i3"));
        assertEquals(FACTORY.makeValue(10, iType32), data.get("%i4"));
        assertEquals(FACTORY.makeValue(20, iType32), data.get("%i5"));

        for (String id : List.of("%i1", "%i2", "%i3", "%i4", "%i5")) {
            assertEquals(isSpec, builder.isSpecConstant(id));
        }
    }

    @Test
    public void testOpConstantCompositeBoolean() {
        doTestOpConstantBoolean("""
                %b1 = OpConstantTrue %bool
                %b2 = OpConstantFalse %bool
                %b3 = OpConstantTrue %bool
                %b3v = OpConstantComposite %bool3v %b1 %b2 %b3
                """, false);
    }

    @Test
    public void testOpConstantSpecCompositeBoolean() {
        doTestOpConstantBoolean("""
                %b1 = OpSpecConstantTrue %bool
                %b2 = OpSpecConstantFalse %bool
                %b3 = OpSpecConstantTrue %bool
                %b3v = OpSpecConstantComposite %bool3v %b1 %b2 %b3
                """, true);
    }

    private void doTestOpConstantBoolean(String input, boolean isSpec) {
        // given
        BooleanType bType = builder.mockBoolType("%bool");
        builder.mockVectorType("%bool3v", "%bool", 3);

        // when
        Map<String, Expression> data = parseConstants(input);

        // then
        assertEquals(4, data.size());

        Expression bTrue = FACTORY.makeTrue();
        Expression bFalse = FACTORY.makeFalse();
        Expression b3v = FACTORY.makeArray(bType, List.of(bTrue, bFalse, bTrue), true);

        assertEquals(bTrue, data.get("%b1"));
        assertEquals(bFalse, data.get("%b2"));
        assertEquals(bTrue, data.get("%b3"));
        assertEquals(b3v, data.get("%b3v"));

        for (String id : List.of("%b1", "%b2", "%b3", "%b3v")) {
            assertEquals(isSpec, builder.isSpecConstant(id));
        }
    }

    @Test
    public void testOpConstantCompositeInteger() {
        doTestOpConstantInteger("""
                %i1 = OpConstant %int 1
                %i2 = OpConstant %int 0
                %i3 = OpConstant %int 17
                %i4 = OpConstant %int -123
                %i4v = OpConstantComposite %int4v %i1 %i2 %i3 %i4
                """, false);
    }

    @Test
    public void testOpConstantSpecCompositeInteger() {
        doTestOpConstantInteger("""
                %i1 = OpSpecConstant %int 1
                %i2 = OpSpecConstant %int 0
                %i3 = OpSpecConstant %int 17
                %i4 = OpSpecConstant %int -123
                %i4v = OpSpecConstantComposite %int4v %i1 %i2 %i3 %i4
                """, true);
    }

    private void doTestOpConstantInteger(String input, boolean isSpec) {
        // given
        IntegerType iType = builder.mockIntType("%int", 64);
        builder.mockVectorType("%int4v", "%int", 4);

        // when
        Map<String, Expression> data = parseConstants(input);

        // then
        assertEquals(5, data.size());

        Expression i1 = FACTORY.makeValue(1, iType);
        Expression i2 = FACTORY.makeValue(0, iType);
        Expression i3 = FACTORY.makeValue(17, iType);
        Expression i4 = FACTORY.makeValue(-123, iType);
        Expression i4v = FACTORY.makeArray(iType, List.of(i1, i2, i3, i4), true);

        assertEquals(i1, data.get("%i1"));
        assertEquals(i2, data.get("%i2"));
        assertEquals(i3, data.get("%i3"));
        assertEquals(i4, data.get("%i4"));
        assertEquals(i4v, data.get("%i4v"));

        for (String id : List.of("%i1", "%i2", "%i3", "%i3", "%i4v")) {
            assertEquals(isSpec, builder.isSpecConstant(id));
        }
    }

    @Test
    public void testOpConstantCompositeStruct() {
        doTestOpConstantStruct("""
                %b = OpConstantTrue %bool
                %i = OpConstant %int 7
                %s = OpConstantComposite %struct %b %i
                """, false);
    }

    @Test
    public void testOpConstantSpecCompositeStruct() {
        doTestOpConstantStruct("""
                %b = OpSpecConstantTrue %bool
                %i = OpSpecConstant %int 7
                %s = OpSpecConstantComposite %struct %b %i
                """, true);
    }

    private void doTestOpConstantStruct(String input, boolean isSpec) {
        // given
        builder.mockBoolType("%bool");
        IntegerType iType = builder.mockIntType("%int", 64);
        builder.mockAggregateType("%struct", "%bool", "%int");

        // when
        Map<String, Expression> data = parseConstants(input);

        // then
        assertEquals(3, data.size());

        Expression b = FACTORY.makeTrue();
        Expression i = FACTORY.makeValue(7, iType);
        Expression s = FACTORY.makeConstruct(List.of(b, i));

        assertEquals(b, data.get("%b"));
        assertEquals(i, data.get("%i"));
        assertEquals(s, data.get("%s"));

        for (String id : List.of("%b", "%i", "%s")) {
            assertEquals(isSpec, builder.isSpecConstant(id));
        }
    }

    @Test
    public void testOpConstantNull() {
        // given
        String input = """
                %n1 = OpConstantNull %int16
                %n2 = OpConstantNull %int16
                %n3 = OpConstantNull %int32
                %n4 = OpConstantNull %bool
                """;

        builder.mockBoolType("%bool");
        IntegerType iType16 = builder.mockIntType("%int16", 16);
        IntegerType iType32 = builder.mockIntType("%int32", 32);

        // when
        Map<String, Expression> data = parseConstants(input);

        // then
        assertEquals(4, data.size());
        assertEquals(FACTORY.makeValue(0, iType16), data.get("%n1"));
        assertEquals(FACTORY.makeValue(0, iType16), data.get("%n2"));
        assertEquals(FACTORY.makeValue(0, iType32), data.get("%n3"));
        assertEquals(FACTORY.makeFalse(), data.get("%n4"));
    }

    @Test
    public void testPrimitiveTypes() {
        // given
        String input = """
                %b1 = OpConstantTrue %bool
                %b2 = OpConstantFalse %bool
                %b3 = OpConstantNull %bool
                %i1 = OpConstant %int 2
                %i2 = OpConstant %int 7
                %i3 = OpConstantNull %int
                """;

        builder.mockBoolType("%bool");
        IntegerType iType = builder.mockIntType("%int", 64);

        // when
        Map<String, Expression> data = parseConstants(input);

        // then
        assertEquals(6, data.size());
        assertEquals(FACTORY.makeTrue(), data.get("%b1"));
        assertEquals(FACTORY.makeFalse(), data.get("%b2"));
        assertEquals(FACTORY.makeFalse(), data.get("%b3"));
        assertEquals(FACTORY.makeValue(2, iType), data.get("%i1"));
        assertEquals(FACTORY.makeValue(7, iType), data.get("%i2"));
        assertEquals(FACTORY.makeValue(0, iType), data.get("%i3"));
    }

    @Test
    public void testNestedCompositeTypes() {
        // given
        String input = """
                %b0 = OpConstantFalse %bool
                %i0 = OpConstant %int 0
                %s0 = OpConstantComposite %inner %b0 %i0
                %b1 = OpConstantTrue %bool
                %i1 = OpConstant %int 1
                %s1 = OpConstantComposite %inner %b1 %i1
                %b2 = OpConstantTrue %bool
                %i2 = OpConstant %int 2
                %s2 = OpConstantComposite %inner %b2 %i2
                %a0 = OpConstantComposite %v2inner %s1 %s2
                %s = OpConstantComposite %outer %s0 %a0
                """;

        builder.mockBoolType("%bool");
        IntegerType iType = builder.mockIntType("%int", 64);
        AggregateType aType = builder.mockAggregateType("%inner", "%bool", "%int");
        builder.mockVectorType("%v2inner", "%inner", 2);
        builder.mockAggregateType("%outer", "%inner", "%v2inner");

        // when
        Map<String, Expression> data = parseConstants(input);

        // then
        assertEquals(11, data.size());

        Expression b0 = FACTORY.makeFalse();
        Expression b1 = FACTORY.makeTrue();
        Expression b2 = FACTORY.makeTrue();

        Expression i0 = FACTORY.makeValue(0, iType);
        Expression i1 = FACTORY.makeValue(1, iType);
        Expression i2 = FACTORY.makeValue(2, iType);

        Expression s0 = FACTORY.makeConstruct(List.of(b0, i0));
        Expression s1 = FACTORY.makeConstruct(List.of(b1, i1));
        Expression s2 = FACTORY.makeConstruct(List.of(b2, i2));

        Expression a0 = FACTORY.makeArray(aType, List.of(s1, s2), true);
        Expression s = FACTORY.makeConstruct(List.of(s0, a0));

        assertEquals(b0, data.get("%b0"));
        assertEquals(b1, data.get("%b1"));
        assertEquals(b2, data.get("%b2"));

        assertEquals(i0, data.get("%i0"));
        assertEquals(i1, data.get("%i1"));
        assertEquals(i2, data.get("%i2"));

        assertEquals(s0, data.get("%s0"));
        assertEquals(s1, data.get("%s1"));
        assertEquals(s2, data.get("%s2"));

        assertEquals(a0, data.get("%a0"));
        assertEquals(s, data.get("%s"));
    }

    @Test
    public void testOpConstantUnsupported() {
        // given
        String input = "%const = OpConstant %bool 12345";
        builder.mockBoolType("%bool");

        try {
            // when
            parseConstants(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal constant type 'bool'", e.getMessage());
        }
    }

    @Test
    public void testRedefiningConstantValue() {
        // given
        String input = """
                %const = OpConstant %int 1
                %const = OpConstant %int 2
                """;

        builder.mockIntType("%int", 64);

        try {
            // when
            parseConstants(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Duplicated definition '%const'", e.getMessage());
        }
    }

    @Test
    public void testReferenceToBaseConstantInSpec() {
        // given
        String input = """
                %b1 = OpSpecConstantTrue %bool
                %b2 = OpSpecConstantFalse %bool
                %b3 = OpConstantTrue %bool
                %b3v = OpSpecConstantComposite %bool3v %b1 %b2 %b3
                """;

        builder.mockBoolType("%bool");
        builder.mockVectorType("%bool3v", "%bool", 3);

        try {
            // when
            parseConstants(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Reference to base constant '%b3' " +
                    "from spec composite constant '%b3v'", e.getMessage());
        }
    }

    @Test
    public void testReferenceToSpecConstantInBase() {
        // given
        String input = """
                %b1 = OpConstantTrue %bool
                %b2 = OpConstantFalse %bool
                %b3 = OpSpecConstantTrue %bool
                %b3v = OpConstantComposite %bool3v %b1 %b2 %b3
                """;

        builder.mockBoolType("%bool");
        builder.mockVectorType("%bool3v", "%bool", 3);

        try {
            // when
            parseConstants(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Reference to spec constant '%b3' " +
                    "from base composite constant '%b3v'", e.getMessage());
        }
    }

    @Test
    public void testIllegalCompositeType() {
        // given
        String input = """
                %b1 = OpConstantTrue %bool
                %b2 = OpConstantFalse %bool
                %b3 = OpConstantTrue %bool
                %b3v = OpConstantComposite %bool %b1 %b2 %b3
                """;

        builder.mockBoolType("%bool");

        try {
            // when
            parseConstants(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal type 'bool' for composite constant '%b3v'",
                    e.getMessage());
        }
    }

    @Test
    public void testMismatchingArrayElementType() {
        // given
        String input = """
                %i1 = OpConstant %int 1
                %i2 = OpConstant %int 2
                %b1 = OpConstantTrue %bool
                %i3v = OpConstantComposite %int3v %i1 %i2 %b1
                """;

        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 64);
        builder.mockVectorType("%int3v", "%int", 3);

        try {
            // when
            parseConstants(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Mismatching type of a composite constant '%i3v' element '%b1', " +
                    "expected 'bv64' but received 'bool'", e.getMessage());
        }
    }

    @Test
    public void testMismatchingStructElementType() {
        // given
        String input = """
                %i1 = OpConstant %int 1
                %i2 = OpConstant %int 2
                %s = OpConstantComposite %struct %i1 %i2
                """;

        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 64);
        builder.mockAggregateType("%struct", "%int", "%bool");

        try {
            // when
            parseConstants(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Mismatching type of a composite constant '%s' element '%i2', " +
                    "expected 'bool' but received 'bv64'", e.getMessage());
        }
    }

    @Test
    public void testMismatchingArrayElementsSize() {
        // given
        String input = """
                %i1 = OpConstant %int 1
                %i2 = OpConstant %int 2
                %i3v = OpConstantComposite %int3v %i1 %i2
                """;

        builder.mockIntType("%int", 64);
        builder.mockVectorType("%int3v", "%int", 3);

        try {
            // when
            parseConstants(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Mismatching number of elements in the composite constant '%i3v', " +
                    "expected 3 elements but received 2 elements", e.getMessage());
        }
    }

    @Test
    public void testMismatchingStructElementsSize() {
        // given
        String input = """
                %i = OpConstant %int 1
                %s = OpConstantComposite %struct %i
                """;

        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 64);
        builder.mockAggregateType("%struct", "%int", "%bool");

        try {
            // when
            parseConstants(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Mismatching number of elements in the composite constant '%s', " +
                    "expected 2 elements but received 1 elements", e.getMessage());
        }
    }

    @Test
    public void testSpecConstantFalseOverride() {
        // given
        String input = """
                %f1 = OpSpecConstantFalse %bool
                %f2 = OpSpecConstantFalse %bool
                %f3 = OpSpecConstantFalse %bool
                %f4 = OpSpecConstantFalse %bool
                %b4v = OpSpecConstantComposite %bool4v %f1 %f2 %f3 %f4
                """;

        BooleanType bType = builder.mockBoolType("%bool");
        builder.mockVectorType("%bool4v", "%bool", 4);

        builder.getDecoration(DecorationType.SPEC_ID).addDecoration("%f1", "1");
        builder.getDecoration(DecorationType.SPEC_ID).addDecoration("%f3", "123");
        builder.getDecoration(DecorationType.SPEC_ID).addDecoration("%f4", "0");

        // when
        Map<String, Expression> data = parseConstants(input);

        // then
        Expression f1 = FACTORY.makeTrue();
        Expression f2 = FACTORY.makeFalse();
        Expression f3 = FACTORY.makeTrue();
        Expression f4 = FACTORY.makeFalse();

        assertEquals(f1, data.get("%f1"));
        assertEquals(f2, data.get("%f2"));
        assertEquals(f3, data.get("%f3"));
        assertEquals(f4, data.get("%f4"));

        assertEquals(FACTORY.makeArray(bType, List.of(f1, f2, f3, f4), true),
                data.get("%b4v"));
    }

    @Test
    public void testSpecConstantTrueOverride() {
        // given
        String input = """
                %t1 = OpSpecConstantTrue %bool
                %t2 = OpSpecConstantTrue %bool
                %t3 = OpSpecConstantTrue %bool
                %t4 = OpSpecConstantTrue %bool
                %b4v = OpSpecConstantComposite %bool4v %t1 %t2 %t3 %t4
                """;

        BooleanType bType = builder.mockBoolType("%bool");
        builder.mockVectorType("%bool4v", "%bool", 4);

        builder.getDecoration(DecorationType.SPEC_ID).addDecoration("%t1", "0");
        builder.getDecoration(DecorationType.SPEC_ID).addDecoration("%t3", "123");
        builder.getDecoration(DecorationType.SPEC_ID).addDecoration("%t4", "1");

        // when
        Map<String, Expression> data = parseConstants(input);

        // then
        Expression t1 = FACTORY.makeFalse();
        Expression t2 = FACTORY.makeTrue();
        Expression t3 = FACTORY.makeTrue();
        Expression t4 = FACTORY.makeTrue();

        assertEquals(t1, data.get("%t1"));
        assertEquals(t2, data.get("%t2"));
        assertEquals(t3, data.get("%t3"));
        assertEquals(t4, data.get("%t4"));

        assertEquals(FACTORY.makeArray(bType, List.of(t1, t2, t3, t4), true),
                data.get("%b4v"));
    }

    @Test
    public void testSpecConstantOverride() {
        // given
        String input = """
                %i1 = OpSpecConstant %int 1
                %i2 = OpSpecConstant %int 2
                %i3 = OpSpecConstant %int 3
                %i3v = OpSpecConstantComposite %int3v %i1 %i2 %i3
                """;

        IntegerType iType = builder.mockIntType("%int", 64);
        builder.mockVectorType("%int3v", "%int", 3);
        builder.getDecoration(DecorationType.SPEC_ID).addDecoration("%i1", "11");
        builder.getDecoration(DecorationType.SPEC_ID).addDecoration("%i3", "3");

        // when
        Map<String, Expression> data = parseConstants(input);

        // then
        Expression i1 = FACTORY.makeValue(11, iType);
        Expression i2 = FACTORY.makeValue(2, iType);
        Expression i3 = FACTORY.makeValue(3, iType);

        assertEquals(i1, data.get("%i1"));
        assertEquals(i2, data.get("%i2"));
        assertEquals(i3, data.get("%i3"));

        assertEquals(FACTORY.makeArray(iType, List.of(i1, i2, i3), true), data.get("%i3v"));
    }

    @Test
    public void testOverrideNotSpecConstant() {
        // given
        String input = """
                %f = OpConstantFalse %bool
                %t = OpConstantTrue %bool
                %i = OpConstant %int 1
                %s = OpConstantComposite %struct %f %t %i
                """;

        builder.mockBoolType("%bool");
        IntegerType iType = builder.mockIntType("%int", 64);
        builder.mockAggregateType("%struct", "%bool", "%bool", "%int");

        builder.getDecoration(DecorationType.SPEC_ID).addDecoration("%f", "1");
        builder.getDecoration(DecorationType.SPEC_ID).addDecoration("%t", "0");
        builder.getDecoration(DecorationType.SPEC_ID).addDecoration("%i", "2");

        // when
        Map<String, Expression> data = parseConstants(input);

        // then
        Expression f = FACTORY.makeFalse();
        Expression t = FACTORY.makeTrue();
        Expression i = FACTORY.makeValue(1, iType);

        assertEquals(f, data.get("%f"));
        assertEquals(t, data.get("%t"));
        assertEquals(i, data.get("%i"));

        assertEquals(FACTORY.makeConstruct(List.of(f, t, i)), data.get("%s"));
    }

    private Map<String, Expression> parseConstants(String input) {
        new MockSpirvParser(input).spv().accept(new VisitorOpsConstant(builder));
        return builder.getExpressions();
    }
}
