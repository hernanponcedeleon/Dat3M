package com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import org.junit.Before;
import org.junit.Test;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperInputs.castInput;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class HelperInputsTest {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private IntegerType int32;
    private IntegerType int64;
    private Expression[] i32;
    private Expression[] i64;

    @Before
    public void before() {
        int32 = types.getIntegerType(32);
        int64 = types.getIntegerType(64);
        i32 = IntStream.range(0, 4).boxed()
                .map(i -> expressions.makeValue(i, int32))
                .toArray(Expression[]::new);
        i64 = IntStream.range(0, 4).boxed()
                .map(i -> expressions.makeValue(i, int64))
                .toArray(Expression[]::new);
    }

    @Test
    public void testBoolean() {
        Type iType = types.getBooleanType();

        Expression[] iValues = {
                i32[0],
                i32[1],
                i64[0],
                i64[1]
        };

        Expression[] expected = {
                expressions.makeFalse(),
                expressions.makeTrue()
        };

        for (int i = 0; i < iValues.length; i++) {
            assertEquals(expected[i % 2], castInput("test", iType, iValues[i]));
        }
    }

    @Test
    public void testInteger() {
        Type[] iTypes = {
                int32,
                int64
        };

        Expression[] iValues = {
                i32[0],
                i64[0]
        };

        Expression[] expected = {
                i32[0],
                i64[0]
        };

        for (Expression input : iValues) {
            for (int i = 0; i < iTypes.length; i++) {
                assertEquals(expected[i], castInput("test", iTypes[i], input));
            }
        }
    }

    @Test
    public void testArray() {
        Type[] iTypes = {
                types.getArrayType(int32),
                types.getArrayType(int64),
                types.getArrayType(int32, 3),
                types.getArrayType(int64, 3)
        };

        Expression[] iValues = {
                makeConstruct(i64[0], i64[1], i64[2]),
                makeArray(i64[0], i64[1], i64[2])
        };

        Expression[] expected = {
                makeArray(i32[0], i32[1], i32[2]),
                makeArray(i64[0], i64[1], i64[2])
        };

        for (Expression input : iValues) {
            for (int i = 0; i < iTypes.length; i++) {
                assertEquals(expected[i % 2], castInput("test", iTypes[i], input));
            }
        }
    }

    @Test
    public void testAggregate() {
        Type[] iTypes = {
                types.getAggregateType(List.of(int32, int32, int32)),
                types.getAggregateType(List.of(int64, int64, int64)),
                types.getAggregateType(List.of(int32, int64, int32))
        };

        Expression[] iValues = {
                makeConstruct(i64[0], i64[1], i64[2]),
                makeArray(i64[0], i64[1], i64[2])
        };

        Expression[] expected = {
                makeConstruct(i32[0], i32[1], i32[2]),
                makeConstruct(i64[0], i64[1], i64[2]),
                makeConstruct(i32[0], i64[1], i32[2])
        };

        for (Expression input : iValues) {
            for (int i = 0; i < iTypes.length; i++) {
                assertEquals(expected[i], castInput("test", iTypes[i], input));
            }
        }
    }

    @Test
    public void testNestedArray1() {
        Type[] iSubTypes = {
                types.getArrayType(int32),
                types.getArrayType(int64),
                types.getArrayType(int32, 2),
                types.getArrayType(int64, 2),
        };

        Type[] iTypes = {
                types.getArrayType(iSubTypes[0]),
                types.getArrayType(iSubTypes[1]),
                types.getArrayType(iSubTypes[2]),
                types.getArrayType(iSubTypes[3]),
                types.getArrayType(iSubTypes[0], 2),
                types.getArrayType(iSubTypes[1], 2),
                types.getArrayType(iSubTypes[2], 2),
                types.getArrayType(iSubTypes[3], 2),
        };

        Expression[] iValues = {
                makeConstruct(makeConstruct(i64[0], i64[1]), makeConstruct(i64[2], i64[3])),
                makeArray(makeArray(i64[0], i64[1]), makeArray(i64[2], i64[3]))
        };

        Expression[] expected = {
                makeArray(makeArray(i32[0], i32[1]), makeArray(i32[2], i32[3])),
                makeArray(makeArray(i64[0], i64[1]), makeArray(i64[2], i64[3]))
        };

        for (Expression input : iValues) {
            for (int i = 0; i < iTypes.length; i++) {
                assertEquals(expected[i % 2], castInput("test", iTypes[i], input));
            }
        }
    }

    @Test
    public void testNestedArray2() {
        Type[] iSubTypes = {
                types.getAggregateType(List.of(int32, int32)),
                types.getAggregateType(List.of(int64, int64))
        };

        Type[] iTypes = {
                types.getArrayType(iSubTypes[0]),
                types.getArrayType(iSubTypes[1]),
                types.getArrayType(iSubTypes[0], 2),
                types.getArrayType(iSubTypes[1], 2)
        };

        Expression[] iValues = {
                makeConstruct(makeConstruct(i64[0], i64[1]), makeConstruct(i64[2], i64[3])),
                makeArray(makeConstruct(i64[0], i64[1]), makeConstruct(i64[2], i64[3]))
        };

        Expression[] expected = {
                makeArray(makeConstruct(i32[0], i32[1]), makeConstruct(i32[2], i32[3])),
                makeArray(makeConstruct(i64[0], i64[1]), makeConstruct(i64[2], i64[3]))
        };

        for (Expression input : iValues) {
            for (int i = 0; i < iTypes.length; i++) {
                assertEquals(expected[i % 2], castInput("test", iTypes[i], input));
            }
        }
    }

    @Test
    public void testNestedAggregate1() {
        Type[] iSubTypes = {
                types.getAggregateType(List.of(int32)),
                types.getAggregateType(List.of(int32, int32)),
                types.getAggregateType(List.of(int32, int32, int32)),
                types.getAggregateType(List.of(int64)),
                types.getAggregateType(List.of(int64, int64)),
                types.getAggregateType(List.of(int64, int64, int64))
        };

        Type[] iTypes = {
                types.getAggregateType(List.of(iSubTypes[0], iSubTypes[1], iSubTypes[2])),
                types.getAggregateType(List.of(iSubTypes[3], iSubTypes[4], iSubTypes[5]))
        };

        Expression[] iValues = {
                makeConstruct(makeConstruct(i64[0]), makeConstruct(i64[0], i64[1]), makeConstruct(i64[0], i64[1], i64[2]))
        };

        Expression[] expected = {
                makeConstruct(makeConstruct(i32[0]), makeConstruct(i32[0], i32[1]), makeConstruct(i32[0], i32[1], i32[2])),
                makeConstruct(makeConstruct(i64[0]), makeConstruct(i64[0], i64[1]), makeConstruct(i64[0], i64[1], i64[2]))
        };

        assertEquals(expected[0], castInput("test", iTypes[0], iValues[0]));
        assertEquals(expected[1], castInput("test", iTypes[1], iValues[0]));
    }

    @Test
    public void testNestedAggregate2() {
        Type[] iSubTypes = {
                types.getAggregateType(List.of(int32, int32)),
                types.getAggregateType(List.of(int64, int64)),
                types.getAggregateType(List.of(int32, int64)),
                types.getAggregateType(List.of(int64, int32))
        };

        Type[] iTypes = {
                types.getAggregateType(List.of(iSubTypes[0], iSubTypes[0])),
                types.getAggregateType(List.of(iSubTypes[1], iSubTypes[1])),
                types.getAggregateType(List.of(iSubTypes[0], iSubTypes[1])),
                types.getAggregateType(List.of(iSubTypes[2], iSubTypes[3])),
                types.getAggregateType(List.of(iSubTypes[3], iSubTypes[2]))
        };

        Expression[] iValues = {
                makeConstruct(makeConstruct(i64[0], i64[1]), makeConstruct(i64[2], i64[3])),
                makeArray(makeArray(i64[0], i64[1]), makeArray(i64[2], i64[3]))
        };

        Expression[] expected = {
                makeConstruct(makeConstruct(i32[0], i32[1]), makeConstruct(i32[2], i32[3])),
                makeConstruct(makeConstruct(i64[0], i64[1]), makeConstruct(i64[2], i64[3])),
                makeConstruct(makeConstruct(i32[0], i32[1]), makeConstruct(i64[2], i64[3])),
                makeConstruct(makeConstruct(i32[0], i64[1]), makeConstruct(i64[2], i32[3])),
                makeConstruct(makeConstruct(i64[0], i32[1]), makeConstruct(i32[2], i64[3]))
        };

        for (Expression input : iValues) {
            for (int i = 0; i < iTypes.length; i++) {
                assertEquals(expected[i], castInput("test", iTypes[i], input));
            }
        }
    }

    @Test
    public void testPointer1() {
        Type[] iSubTypes = {
                types.getScopedPointerType("test", int32, null),
                types.getScopedPointerType("test", int64, null)
        };

        Type[] iTypes = {
                iSubTypes[0],
                iSubTypes[1],
                types.getScopedPointerType("test", iSubTypes[0], null),
                types.getScopedPointerType("test", iSubTypes[1], null),
        };

        Expression[] iValues = {
                i32[0],
                i64[0],
                makeConstruct(i32[0], i32[1]),
                makeConstruct(i64[0], i64[1]),
                makeArray(i32[0], i32[1]),
                makeArray(i64[0], i64[1])
        };

        for (Expression input : iValues) {
            for (Type type : iTypes) {
                doTestInvalidType(type, input, "test", type, input.getType());
            }
        }
    }

    @Test
    public void testPointer2() {
        Type[] iSubTypes = {
                types.getScopedPointerType("test", int32, null),
                types.getScopedPointerType("test", int64, null)
        };

        ArrayType[] iTypes = {
                types.getArrayType(iSubTypes[0]),
                types.getArrayType(iSubTypes[1])
        };

        Expression[] iValues = {
                makeConstruct(i32[0], i32[1]),
                makeConstruct(i64[0], i64[1]),
                makeArray(i32[0], i32[1]),
                makeArray(i64[0], i64[1])
        };

        for (Expression input : iValues) {
            for (ArrayType type : iTypes) {
                doTestInvalidType(type, input, "test[0]", type.getElementType(), input.getOperands().get(0).getType());
            }
        }
    }

    @Test
    public void testInvalidTypeToScalar() {
        Type[] iTypes = {
                int32,
                int64
        };

        Expression[] iValues = {
                makeConstruct(i32[0]),
                makeConstruct(i64[0]),
                makeArray(i32[0]),
                makeArray(i64[0])
        };

        for (Expression input : iValues) {
            for (Type type : iTypes) {
                doTestInvalidType(type, input, "test", type, input.getType());
            }
        }
    }

    @Test
    public void testInvalidTypeToArray1() {
        ArrayType[] iTypes = {
                types.getArrayType(int32, 2),
                types.getArrayType(int64, 2)
        };

        Expression[] iValues = {
                makeConstruct(i32[0]),
                makeConstruct(i64[0]),
                makeConstruct(i32[0], i32[1], i32[2]),
                makeConstruct(i64[0], i64[1], i64[2]),
                makeArray(i32[0]),
                makeArray(i64[0]),
                makeArray(i32[0], i32[1], i32[2]),
                makeArray(i64[0], i64[1], i64[2])
        };

        for (Expression input : iValues) {
            for (ArrayType type : iTypes) {
                doTestInvalidType(type, input, "test", type, input.getType());
            }
        }
    }

    @Test
    public void testInvalidTypeToArray2() {
        ArrayType[] iTypes = {
                types.getArrayType(int32),
                types.getArrayType(int64),
                types.getArrayType(int32, 2),
                types.getArrayType(int64, 2)
        };

        Expression[] iValues = {
                makeArray(makeArray(i32[0], i32[1]), makeArray(i32[2], i32[3])),
                makeArray(makeArray(i64[0], i64[1]), makeArray(i64[2], i64[3])),
                makeConstruct(makeConstruct(i32[0], i32[1]), makeConstruct(i32[2], i32[3])),
                makeConstruct(makeConstruct(i64[0], i64[1]), makeConstruct(i64[2], i64[3]))
        };

        for (Expression input : iValues) {
            for (ArrayType type : iTypes) {
                doTestInvalidType(type, input, "test[0]", type.getElementType(),
                        input.getOperands().get(0).getType());
            }
        }
    }

    @Test
    public void testInvalidTypeToArray3() {
        Type[] iSubTypes = {
                types.getArrayType(int32, 2),
                types.getArrayType(int64, 2)
        };

        ArrayType[] iTypes = {
                types.getArrayType(iSubTypes[0], 2),
                types.getArrayType(iSubTypes[1], 2)
        };

        Expression[] iValues = {
                makeConstruct(i32[0], i32[1]),
                makeConstruct(i64[0], i64[1]),
                makeArray(i32[0], i32[1]),
                makeArray(i64[0], i64[1])
        };

        for (Expression input : iValues) {
            for (ArrayType type : iTypes) {
                doTestInvalidType(type, input, "test[0]", type.getElementType(),
                        input.getOperands().get(0).getType());
            }
        }
    }

    @Test
    public void testInvalidTypeToArray4() {
        ArrayType[] iTypes = {
                types.getArrayType(types.getArrayType(int32)),
                types.getArrayType(types.getArrayType(int32), 2),
        };

        Expression[] iValues = {
                makeConstruct(makeConstruct(i32[0]), makeConstruct(i32[1], i32[2])),
                makeConstruct(makeConstruct(i64[0]), makeConstruct(i64[1], i64[2])),
                makeConstruct(makeConstruct(), makeConstruct(i32[1], i32[2])),
                makeConstruct(makeConstruct(), makeConstruct(i64[1], i64[2]))
        };

        for (Expression input : iValues) {
            for (ArrayType type : iTypes) {
                doTestInvalidType(type, input, "test", type, input.getType());
            }
        }
    }

    @Test
    public void testArrayWithStride() {
        Type[] iTypes = {
                types.getArrayType(int32, -1, 12),
                types.getArrayType(int32, 3, 12),
                types.getArrayType(int32, -1, 16),
                types.getArrayType(int32, 3, 16),
                types.getArrayType(int64, -1, 24),
                types.getArrayType(int64, 3, 24),
                types.getArrayType(int64, -1, 32),
                types.getArrayType(int64, 3, 32)
        };

        Expression[] iValues = {
                makeConstruct(i64[0], i64[1], i64[2]),
                makeArray(i64[0], i64[1], i64[2])
        };

        Expression[] expected = {
                makeArrayWithStride(12, i32[0], i32[1], i32[2]),
                makeArrayWithStride(16, i32[0], i32[1], i32[2]),
                makeArrayWithStride(24, i64[0], i64[1], i64[2]),
                makeArrayWithStride(32, i64[0], i64[1], i64[2])
        };

        for (Expression input : iValues) {
            for (int i = 0; i < iTypes.length; i++) {
                assertEquals(expected[i / 2], castInput("test", iTypes[i], input));
            }
        }
    }

    @Test
    public void testInvalidTypeToArrayWithStride() {
        ArrayType[] iTypes = {
                types.getArrayType(types.getArrayType(int32), -1, 8),
                types.getArrayType(types.getArrayType(int32), 2, 8),
                types.getArrayType(types.getArrayType(int32), -1, 12),
                types.getArrayType(types.getArrayType(int32), 2, 12),
                types.getArrayType(types.getArrayType(int64), -1, 16),
                types.getArrayType(types.getArrayType(int64), 2, 16),
                types.getArrayType(types.getArrayType(int64), -1, 24),
                types.getArrayType(types.getArrayType(int64), 2, 24)
        };

        Expression[] iValues = {
                makeConstruct(
                        makeConstruct(i32[0], i32[1], i32[2], i32[3]),
                        makeConstruct(i32[0], i32[1], i32[2], i32[3])),
                makeConstruct(
                        makeConstruct(i64[0], i64[1], i64[2], i64[3]),
                        makeConstruct(i64[0], i64[1], i64[2], i64[3])),
        };

        for (Expression input : iValues) {
            for (ArrayType type : iTypes) {
                try {
                    castInput("test", type, input);
                    fail("Should throw exception");
                } catch (ParsingException e) {
                    Expression elValue = castInput("element", type.getElementType(), input.getOperands().get(0));
                    assertEquals(String.format("Mismatching value type for variable 'test', " +
                                            "element size %d is greater than array stride %d",
                                    types.getMemorySizeInBytes(elValue.getType()), type.getStride()),
                            e.getMessage());
                }
            }
        }
    }

    @Test
    public void testInvalidTypeToAggregate() {
        AggregateType[] iTypes = {
                types.getAggregateType(List.of(int32, int32)),
                types.getAggregateType(List.of(int64, int64)),
                types.getAggregateType(List.of(int32, int64))
        };

        Expression[] iValues = {
                makeConstruct(i32[0]),
                makeConstruct(i64[0]),
                makeConstruct(i32[0], i32[1], i32[2]),
                makeConstruct(i64[0], i64[1], i64[2]),
                makeArray(i32[0]),
                makeArray(i64[0]),
                makeArray(i32[0], i32[1], i32[2]),
                makeArray(i64[0], i64[1], i64[2])
        };

        for (Expression input : iValues) {
            for (AggregateType type : iTypes) {
                doTestInvalidType(type, input, "test", type, input.getType());
            }
        }
    }

    @Test
    public void testInvalidTypeToAggregate2() {
        AggregateType[] iTypes = {
                types.getAggregateType(List.of(int32, int32)),
                types.getAggregateType(List.of(int64, int64))
        };

        Expression[] iValues = {
                makeConstruct(makeConstruct(i32[0], i32[1]), makeConstruct(i32[2], i32[3])),
                makeConstruct(makeConstruct(i64[0], i64[1]), makeConstruct(i64[2], i64[3])),
                makeArray(makeArray(i32[0], i32[1]), makeArray(i32[2], i32[3])),
                makeArray(makeArray(i64[0], i64[1]), makeArray(i64[2], i64[3]))
        };

        for (Expression input : iValues) {
            for (AggregateType type : iTypes) {
                doTestInvalidType(type, input, "test[0]", type.getFields().get(0).type(),
                        input.getOperands().get(0).getType());
            }
        }
    }

    @Test
    public void testInvalidTypeToAggregate3() {
        Type[] iSubTypes = {
                types.getAggregateType(List.of(int32, int32)),
                types.getAggregateType(List.of(int64, int64))
        };

        AggregateType[] iTypes = {
                types.getAggregateType(List.of(iSubTypes[0], iSubTypes[0])),
                types.getAggregateType(List.of(iSubTypes[1], iSubTypes[1]))
        };

        Expression[] iValues = {
                makeConstruct(i32[0], i32[1]),
                makeConstruct(i64[0], i64[1]),
                makeArray(i32[0], i32[1]),
                makeArray(i64[0], i64[1])
        };

        for (Expression input : iValues) {
            for (AggregateType type : iTypes) {
                doTestInvalidType(type, input, "test[0]",
                        type.getFields().get(0).type(),
                        input.getOperands().get(0).getType());
            }
        }
    }

    private void doTestInvalidType(Type type, Expression value, String id, Type expected, Type actual) {
        try {
            castInput("test", type, value);
            fail("Should throw exception");
        } catch (ParsingException e) {
            assertEquals(String.format("Mismatching value type for variable '%s', " +
                    "expected '%s' but received '%s'", id, expected, actual), e.getMessage());
        }
    }

    private ConstructExpr makeConstruct(Expression... elements) {
        Type type = types.getAggregateType(Stream.of(elements).map(Expression::getType).toList());
        return (ConstructExpr) expressions.makeConstruct(type, Arrays.asList(elements));
    }

    private ConstructExpr makeArray(Expression... elements) {
        assertEquals(1, Stream.of(elements).map(Expression::getType).collect(Collectors.toSet()).size());
        ArrayType type = types.getArrayType(elements[0].getType(), elements.length);
        return (ConstructExpr) expressions.makeArray(type, Arrays.asList(elements));
    }

    private ConstructExpr makeArrayWithStride(Integer stride, Expression... elements) {
        assertEquals(1, Stream.of(elements).map(Expression::getType).collect(Collectors.toSet()).size());
        ArrayType type = types.getArrayType(elements[0].getType(), elements.length, stride);
        return (ConstructExpr) expressions.makeArray(type, Arrays.asList(elements));
    }
}
