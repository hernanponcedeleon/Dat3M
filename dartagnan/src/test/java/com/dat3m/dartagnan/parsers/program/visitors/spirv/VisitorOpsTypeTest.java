package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import org.junit.Test;

import java.math.BigInteger;
import java.util.List;
import java.util.Map;

import static org.junit.Assert.assertEquals;

public class VisitorOpsTypeTest {

    private static final TypeFactory FACTORY = TypeFactory.getInstance();
    private final ProgramBuilderSpv builder = new ProgramBuilderSpv();

    @Test
    public void testSupportedTypes() {
        // given
        String input = """
                %void = OpTypeVoid
                %bool = OpTypeBool
                %int = OpTypeInt 16 1
                %vector = OpTypeVector %int 10
                %array = OpTypeArray %int %val_20
                %ptr = OpTypePointer Input %int
                %func = OpTypeFunction %void %ptr %int
                %struct = OpTypeStruct %int %ptr %array
                """;

        addIntConstant("%val_20", 20);

        // when
        Map<String, Type> data = parseTypes(input);

        // then
        assertEquals(8, data.size());

        Type typeVoid = FACTORY.getVoidType();
        Type typeBoolean = FACTORY.getBooleanType();
        Type typeInteger = FACTORY.getIntegerType(16);
        Type typeVector = FACTORY.getArrayType(typeInteger, 10);
        Type typeArray = FACTORY.getArrayType(typeInteger, 20);
        Type typePointer = FACTORY.getPointerType();
        Type typeFunction = FACTORY.getFunctionType(typeVoid, List.of(typePointer, typeInteger));
        Type typeStruct = FACTORY.getAggregateType(List.of(typeInteger, typePointer, typeArray));

        assertEquals(data.get("%void"), typeVoid);
        assertEquals(data.get("%bool"), typeBoolean);
        assertEquals(data.get("%int"), typeInteger);
        assertEquals(data.get("%vector"), typeVector);
        assertEquals(data.get("%array"), typeArray);
        assertEquals(data.get("%ptr"), typePointer);
        assertEquals(data.get("%func"), typeFunction);
        assertEquals(data.get("%struct"), typeStruct);
    }

    @Test(expected = ParsingException.class)
    public void testUnsupportedType() {
        // given
        String input = "%float = OpTypeFloat 32";

        // when
        parseTypes(input);
    }

    @Test(expected = ParsingException.class)
    public void testRedefiningType() {
        // given
        String input = """
                %type = OpTypeVoid
                %type = OpTypeInt 16 1
                """;

        // when
        parseTypes(input);
    }

    @Test
    public void testIntegerType() {
        // given
        String input = """
                %uint_8 = OpTypeInt 8 0
                %uint_16 = OpTypeInt 16 0
                %uint_32 = OpTypeInt 32 0
                %int_8 = OpTypeInt 8 1
                %int_16 = OpTypeInt 16 1
                %int_32 = OpTypeInt 32 1
                """;

        // when
        Map<String, Type> data = parseTypes(input);

        // then
        assertEquals(6, data.size());

        assertEquals(data.get("%uint_8"), FACTORY.getIntegerType(8));
        assertEquals(data.get("%uint_16"), FACTORY.getIntegerType(16));
        assertEquals(data.get("%uint_32"), FACTORY.getIntegerType(32));
        assertEquals(data.get("%int_8"), FACTORY.getIntegerType(8));
        assertEquals(data.get("%int_16"), FACTORY.getIntegerType(16));
        assertEquals(data.get("%int_32"), FACTORY.getIntegerType(32));
    }

    @Test
    public void testVectorType() {
        // given
        String input = """
                %bool = OpTypeBool
                %int = OpTypeInt 32 1
                %vector_bool_5 = OpTypeVector %bool 5
                %vector_bool_10 = OpTypeVector %bool 10
                %vector_int_15 = OpTypeVector %int 15
                %vector_int_20 = OpTypeVector %int 20
                """;

        // when
        Map<String, Type> data = parseTypes(input);

        // then
        assertEquals(6, data.size());

        Type typeBoolean = FACTORY.getBooleanType();
        Type typeInteger = FACTORY.getIntegerType(32);

        assertEquals(data.get("%vector_bool_5"), FACTORY.getArrayType(typeBoolean, 5));
        assertEquals(data.get("%vector_bool_10"), FACTORY.getArrayType(typeBoolean, 10));
        assertEquals(data.get("%vector_int_15"), FACTORY.getArrayType(typeInteger, 15));
        assertEquals(data.get("%vector_int_20"), FACTORY.getArrayType(typeInteger, 20));
    }

    @Test
    public void testArrayType() {
        // given
        String input = """
                %bool = OpTypeBool
                %int = OpTypeInt 32 1
                %array_bool_5 = OpTypeArray %bool %val_5
                %array_bool_10 = OpTypeArray %bool %val_10
                %array_int_15 = OpTypeArray %int %val_15
                %array_int_20 = OpTypeArray %int %val_20
                """;

        addIntConstant("%val_5", 5);
        addIntConstant("%val_10", 10);
        addIntConstant("%val_15", 15);
        addIntConstant("%val_20", 20);

        // when
        Map<String, Type> data = parseTypes(input);

        // then
        assertEquals(6, data.size());

        Type typeBoolean = FACTORY.getBooleanType();
        Type typeInteger = FACTORY.getIntegerType(32);

        assertEquals(data.get("%array_bool_5"), FACTORY.getArrayType(typeBoolean, 5));
        assertEquals(data.get("%array_bool_10"), FACTORY.getArrayType(typeBoolean, 10));
        assertEquals(data.get("%array_int_15"), FACTORY.getArrayType(typeInteger, 15));
        assertEquals(data.get("%array_int_20"), FACTORY.getArrayType(typeInteger, 20));
    }

    @Test
    public void testPointerType() {
        // given
        String input = """
                %bool = OpTypeBool
                %int = OpTypeInt 32 1
                %ptr_input_bool = OpTypePointer Input %bool
                %ptr_input_int = OpTypePointer Input %int
                %ptr_workgroup_int = OpTypePointer Workgroup %int
                """;

        // when
        Map<String, Type> data = parseTypes(input);

        // then
        assertEquals(5, data.size());
        assertEquals(data.get("%ptr_input_bool"), FACTORY.getPointerType());
        assertEquals(builder.getPointedType("%ptr_input_bool"), FACTORY.getBooleanType());
        assertEquals(data.get("%ptr_input_int"), FACTORY.getPointerType());
        assertEquals(builder.getPointedType("%ptr_input_int"), FACTORY.getIntegerType(32));
        assertEquals(data.get("%ptr_workgroup_int"), FACTORY.getPointerType());
        assertEquals(builder.getPointedType("%ptr_workgroup_int"), FACTORY.getIntegerType(32));
    }

    @Test(expected = ParsingException.class)
    public void testPointerTypeUndefinedReference() {
        // given
        String input = "%ptr = OpTypePointer Input %undefined";

        // when
        parseTypes(input);
    }

    @Test
    public void testFunctionType() {
        // given
        String input = """
                %void = OpTypeVoid
                %bool = OpTypeBool
                %int = OpTypeInt 16 1
                %array = OpTypeArray %int %val_5
                %ptr = OpTypePointer Input %int
                %f1 = OpTypeFunction %void
                %f2 = OpTypeFunction %bool %int %array
                %f3 = OpTypeFunction %ptr %ptr
                """;

        addIntConstant("%val_5", 5);

        // when
        Map<String, Type> data = parseTypes(input);

        // then
        assertEquals(8, data.size());

        Type typeVoid = FACTORY.getVoidType();
        Type typeBoolean = FACTORY.getBooleanType();
        Type typeInteger = FACTORY.getIntegerType(16);
        Type typeArray = FACTORY.getArrayType(typeInteger, 5);
        Type typePointer = FACTORY.getPointerType();

        assertEquals(data.get("%f1"), FACTORY.getFunctionType(typeVoid, List.of()));
        assertEquals(data.get("%f2"), FACTORY.getFunctionType(typeBoolean, List.of(typeInteger, typeArray)));
        assertEquals(data.get("%f3"), FACTORY.getFunctionType(typePointer, List.of(typePointer)));
    }

    @Test(expected = ParsingException.class)
    public void testFunctionTypeUndefinedReturnReference() {
        // given
        String input = "%func = OpTypeFunction %undefined";

        // when
        parseTypes(input);
    }

    @Test(expected = ParsingException.class)
    public void testFunctionTypeUndefinedArgumentReference() {
        // given
        String input = """
                %void = OpTypeVoid
                %bool = OpTypeBool
                %func = OpTypeFunction %void %bool %undefined
                """;

        // when
        parseTypes(input);
    }

    @Test
    public void testStructType() {
        // given
        String input = """
                %bool = OpTypeBool
                %int = OpTypeInt 32 0
                %array = OpTypeArray %int %val_10
                %s1 = OpTypeStruct %int %array
                %ptr = OpTypePointer Input %s1
                %s2 = OpTypeStruct %bool %ptr
                """;

        addIntConstant("%val_10", 10);

        // when
        Map<String, Type> data = parseTypes(input);

        // then
        assertEquals(6, data.size());

        Type typeBoolean = FACTORY.getBooleanType();
        Type typeInteger = FACTORY.getIntegerType(32);
        Type typeArray = FACTORY.getArrayType(typeInteger, 10);
        Type typeStructFirst = FACTORY.getAggregateType(List.of(typeInteger, typeArray));
        Type typePointer = FACTORY.getPointerType();
        Type typeStructSecond = FACTORY.getAggregateType(List.of(typeBoolean, typePointer));

        assertEquals(data.get("%s1"), typeStructFirst);
        assertEquals(data.get("%s2"), typeStructSecond);
    }

    @Test(expected = ParsingException.class)
    public void testStructTypeUndefinedReference() {
        // given
        String input = """
                %int = OpTypeInt 32 0
                %s1 = OpTypeStruct %int %ptr
                """;

        // when
        parseTypes(input);
    }

    private Map<String, Type> parseTypes(String input) {
        new MockSpirvParser(input).spv().accept(new VisitorOpsType(builder));
        return builder.getTypes();
    }

    private void addIntConstant(String id, int value) {
        IntegerType type = FACTORY.getIntegerType(64);
        IntLiteral iValue = new IntLiteral(type, new BigInteger(Integer.toString(value)));
        builder.addExpression(id, iValue);
    }
}
