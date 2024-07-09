package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilderSpv;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import com.dat3m.dartagnan.expression.type.ScopedPointerType;
import com.dat3m.dartagnan.program.event.Tag;
import org.junit.Test;

import java.math.BigInteger;
import java.util.List;
import java.util.Map;

import static org.junit.Assert.assertEquals;

public class VisitorOpsTypeTest {

    private static final TypeFactory FACTORY = TypeFactory.getInstance();
    private final MockProgramBuilderSpv builder = new MockProgramBuilderSpv();

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
        Type typePointer = FACTORY.getScopedPointerType(Tag.Spirv.SC_INPUT, typeInteger);
        Type typeFunction = FACTORY.getFunctionType(typeVoid, List.of(typePointer, typeInteger));
        Type typeStruct = FACTORY.getAggregateType(List.of(typeInteger, typePointer, typeArray));

        assertEquals(typeVoid, data.get("%void"));
        assertEquals(typeBoolean, data.get("%bool"));
        assertEquals(typeInteger, data.get("%int"));
        assertEquals(typeVector, data.get("%vector"));
        assertEquals(typeArray, data.get("%array"));
        assertEquals(typePointer, data.get("%ptr"));
        assertEquals(typeFunction, data.get("%func"));
        assertEquals(typeStruct, data.get("%struct"));
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

        assertEquals(FACTORY.getIntegerType(8), data.get("%uint_8"));
        assertEquals(FACTORY.getIntegerType(16), data.get("%uint_16"));
        assertEquals(FACTORY.getIntegerType(32), data.get("%uint_32"));
        assertEquals(FACTORY.getIntegerType(8), data.get("%int_8"));
        assertEquals(FACTORY.getIntegerType(16), data.get("%int_16"));
        assertEquals(FACTORY.getIntegerType(32), data.get("%int_32"));
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

        assertEquals(FACTORY.getArrayType(typeBoolean, 5), data.get("%vector_bool_5"));
        assertEquals(FACTORY.getArrayType(typeBoolean, 10), data.get("%vector_bool_10"));
        assertEquals(FACTORY.getArrayType(typeInteger, 15), data.get("%vector_int_15"));
        assertEquals(FACTORY.getArrayType(typeInteger, 20), data.get("%vector_int_20"));
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

        assertEquals(FACTORY.getArrayType(typeBoolean, 5), data.get("%array_bool_5"));
        assertEquals(FACTORY.getArrayType(typeBoolean, 10), data.get("%array_bool_10"));
        assertEquals(FACTORY.getArrayType(typeInteger, 15), data.get("%array_int_15"));
        assertEquals(FACTORY.getArrayType(typeInteger, 20), data.get("%array_int_20"));
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

        ScopedPointerType boolPtr = (ScopedPointerType)data.get("%ptr_input_bool");
        assertEquals(Tag.Spirv.SC_INPUT, boolPtr.getScopeId());
        assertEquals(builder.getType("%bool"), boolPtr.getPointedType());

        ScopedPointerType inputIntPtr = (ScopedPointerType)data.get("%ptr_input_int");
        assertEquals(Tag.Spirv.SC_INPUT, inputIntPtr.getScopeId());
        assertEquals(builder.getType("%int"), inputIntPtr.getPointedType());

        ScopedPointerType workgroupIntPtr = (ScopedPointerType)data.get("%ptr_workgroup_int");
        assertEquals(Tag.Spirv.SC_WORKGROUP, workgroupIntPtr.getScopeId());
        assertEquals(builder.getType("%int"), workgroupIntPtr.getPointedType());
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
        Type typePointer = FACTORY.getScopedPointerType(Tag.Spirv.SC_INPUT, typeInteger);

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
        Type typePointer = FACTORY.getScopedPointerType(Tag.Spirv.SC_INPUT, typeStructFirst);
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
        IntegerType type = FACTORY.getArchType();
        IntLiteral iValue = new IntLiteral(type, new BigInteger(Integer.toString(value)));
        builder.addExpression(id, iValue);
    }
}
