package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperTypes;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import org.junit.Test;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class VisitorOpsCompositeTest {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private final MockProgramBuilder builder = new MockProgramBuilder();

    @Test
    public void doTestCompositeExtractArrayRegister() {
        // given
        String input = "%extract_value = OpCompositeExtract %uint %composite_value 0";

        builder.mockFunctionStart(true);
        builder.mockIntType("%uint", 32);
        ArrayType arrayType = builder.mockVectorType("%uint_4", "%uint", 4);
        builder.mockPtrType("%_ptr_Function_uint_4", "%uint_4", "Function");
        Expression pointer = builder.mockVariable("%value", "%_ptr_Function_uint_4");

        List<Expression> registers = new ArrayList<>();
        for (int i = 0; i < 4; i++) {
            Register register = builder.addRegister("%r" + i, "%uint");
            List<Expression> index = List.of(new IntLiteral(types.getArchType(), new BigInteger(Long.toString(i))));
            Expression elementPointer = HelperTypes.getMemberAddress("%value", pointer, arrayType, index);
            Event load = EventFactory.newLoad(register, elementPointer);
            builder.addEvent(load);
            registers.add(register);
        }
        Expression arrayRegister = expressions.makeArray(arrayType.getElementType(), registers, true);
        builder.addExpression("%composite_value", arrayRegister);

        // when
        visit(input);

        // then
        Register compositeExtract = (Register) builder.getExpression("%extract_value");
        assertEquals(builder.getType("%uint"), compositeExtract.getType());
        assertEquals(registers.get(0), compositeExtract);
    }

    @Test
    public void doTestCompositeExtractNestedArray() {
        // given
        String input = """
                %extract_value = OpCompositeExtract %uint %composite_value 1 1
                """;

        builder.mockFunctionStart(true);
        IntegerType uintType = builder.mockIntType("%uint", 32);
        ArrayType arrType = builder.mockVectorType("%uint_4", "%uint", 4);

        AggregateType aggregateType = types.getAggregateType(List.of(uintType, arrType));

        Expression i1 = expressions.makeValue(1, uintType);
        Expression i2 = expressions.makeValue(2, uintType);
        Expression i3 = expressions.makeValue(3, uintType);
        Expression i4 = expressions.makeValue(4, uintType);

        List<Expression> arrayElements = List.of(i1, i2, i3, i4);
        Expression array = expressions.makeArray(builder.getType("%uint"), arrayElements, true);
        Expression aggregate = expressions.makeConstruct(aggregateType, List.of(i1, array));
        builder.addExpression("%composite_value", aggregate);

        // when
        visit(input);

        // then
        Expression compositeExtract = builder.getExpression("%extract_value");

        assertEquals(builder.getType("%uint"), compositeExtract.getType());

        assertEquals(i2, compositeExtract);
    }

    @Test
    public void doTestCompositeExtractWrongType() {
        // given
        String input = """
                %extract_value = OpCompositeExtract %uint64 %composite_value 0
                """;

        builder.mockFunctionStart(true);
        IntegerType uintType = builder.mockIntType("%uint", 32);
        builder.mockIntType("%uint64", 64);
        ArrayType arrType = builder.mockVectorType("%uint_4", "%uint", 4);

        AggregateType aggregateType = types.getAggregateType(List.of(uintType, arrType));

        Expression i1 = expressions.makeValue(1, uintType);
        Expression i2 = expressions.makeValue(2, uintType);
        Expression i3 = expressions.makeValue(3, uintType);
        Expression i4 = expressions.makeValue(4, uintType);

        List<Expression> arrayElements = List.of(i1, i2, i3, i4);
        Expression array = expressions.makeArray(builder.getType("%uint"), arrayElements, true);
        Expression aggregate = expressions.makeConstruct(aggregateType, List.of(i1, array));
        builder.addExpression("%composite_value", aggregate);

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (Exception e) {
            // then
            assertEquals("Type mismatch in composite extraction for: %extract_value", e.getMessage());
        }
    }

    @Test
    public void doTestCompositeExtractRuntimeArray() {
        // given
        String input = """
                %extract_0 = OpCompositeExtract %uint %composite_value 0
                %extract_1 = OpCompositeExtract %ra_ptr %composite_value 1
                """;

        builder.mockFunctionStart(true);
        IntegerType uintType = builder.mockIntType("%uint", 32);
        ArrayType arrType = builder.mockVectorType("%uint_4", "%uint", 4);

        AggregateType aggregateType = types.getAggregateType(List.of(uintType, arrType));

        Expression i1 = expressions.makeValue(1, uintType);
        Expression i2 = expressions.makeValue(2, uintType);
        Expression i3 = expressions.makeValue(3, uintType);
        Expression i4 = expressions.makeValue(4, uintType);

        List<Expression> arrayElements = List.of(i1, i2, i3, i4);
        Expression array = expressions.makeArray(builder.getType("%uint"), arrayElements, true);
        Expression aggregate = expressions.makeConstruct(aggregateType, List.of(i1, array));
        builder.addExpression("%composite_value", aggregate);

        builder.mockVectorType("%ra", "%uint", -1);
        builder.mockPtrType("%ra_ptr", "%ra", "Uniform");

        // when
        visit(input);

        // then
        Expression compositeExtract0 = builder.getExpression("%extract_0");
        Expression compositeExtract1 = builder.getExpression("%extract_1");

        assertEquals(builder.getType("%uint"), compositeExtract0.getType());
        assertEquals(builder.getType("%uint_4"), compositeExtract1.getType());

        assertEquals(i1, compositeExtract0);
        assertEquals(array, compositeExtract1);
    }

    @Test
    public void compositeExtractElementNotConstructExpr() {
        String input = "%extract_value = OpCompositeExtract %uint %composite_value 0";

        builder.mockFunctionStart(true);
        builder.mockIntType("%uint", 32);
        Expression nonConstructExpr = expressions.makeValue(1, (IntegerType) builder.getType("%uint"));
        builder.addExpression("%composite_value", nonConstructExpr);

        try {
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            assertEquals("Element is not a ConstructExpr at index: 0 for: %extract_value", e.getMessage());
        }
    }

    @Test
    public void compositeExtractIndexOutOfBounds() {
        String input = "%extract_value = OpCompositeExtract %uint %composite_value 5";

        builder.mockFunctionStart(true);
        builder.mockIntType("%uint", 32);
        List<Expression> elements = List.of(
                expressions.makeValue(1, (IntegerType) builder.getType("%uint")),
                expressions.makeValue(2, (IntegerType) builder.getType("%uint")),
                expressions.makeValue(3, (IntegerType) builder.getType("%uint")),
                expressions.makeValue(4, (IntegerType) builder.getType("%uint"))
        );
        Expression array = expressions.makeArray(builder.getType("%uint"), elements, true);
        builder.addExpression("%composite_value", array);

        try {
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            assertEquals("Index out of bounds: 5 for: %extract_value", e.getMessage());
        }
    }

    @Test
    public void compositeExtractIndexTooDeep() {
        String input = "%extract_value = OpCompositeExtract %uint %composite_value 0 0";

        builder.mockFunctionStart(true);
        builder.mockIntType("%uint", 32);
        List<Expression> elements = List.of(
                expressions.makeValue(1, (IntegerType) builder.getType("%uint")),
                expressions.makeValue(2, (IntegerType) builder.getType("%uint")),
                expressions.makeValue(3, (IntegerType) builder.getType("%uint")),
                expressions.makeValue(4, (IntegerType) builder.getType("%uint"))
        );
        Expression array = expressions.makeArray(builder.getType("%uint"), elements, true);
        builder.addExpression("%composite_value", array);

        try {
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            assertEquals("Element is not a ConstructExpr at index: 0 for: %extract_value", e.getMessage());
        }
    }

    private void visit(String input) {
        new MockSpirvParser(input).spv().accept(new VisitorOpsComposite(builder));
    }
}
