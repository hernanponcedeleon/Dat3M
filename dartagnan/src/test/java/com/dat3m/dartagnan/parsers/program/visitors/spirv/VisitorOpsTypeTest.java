package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.ScopedPointerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.Decoration;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import com.dat3m.dartagnan.program.event.Tag;
import org.junit.Test;

import java.util.List;
import java.util.Map;

import static com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType.ARRAY_STRIDE;
import static org.junit.Assert.*;

public class VisitorOpsTypeTest {

    private static final TypeFactory types = TypeFactory.getInstance();
    private final MockProgramBuilder builder = new MockProgramBuilder();

    @Test
    public void testSupportedTypes() {
        // given
        String input = """
                %void = OpTypeVoid
                %bool = OpTypeBool
                %int = OpTypeInt 16 1
                %vector = OpTypeVector %int 10
                %array = OpTypeArray %int %uint_20
                %ptr = OpTypePointer Input %int
                %func = OpTypeFunction %void %ptr %int
                %struct = OpTypeStruct %int %ptr %array
                """;

        builder.mockIntType("%uint", 32);
        builder.mockConstant("%uint_20", "%uint", 20);

        addMemberOffset("%struct", "0", "0");
        addMemberOffset("%struct", "1", "2");
        addMemberOffset("%struct", "2", "10");

        // when
        Map<String, Type> data = parseTypes(input);

        // then
        Type typeVoid = types.getVoidType();
        Type typeBoolean = types.getBooleanType();
        Type typeInteger = types.getIntegerType(16);
        Type typeVector = types.getArrayType(typeInteger, 10);
        Type typeArray = types.getArrayType(typeInteger, 20);
        Type typePointer = types.getScopedPointerType(Tag.Spirv.SC_INPUT, typeInteger, null);
        Type typeFunction = types.getFunctionType(typeVoid, List.of(typePointer, typeInteger));
        Type typeStruct = types.getAggregateType(List.of(typeInteger, typePointer, typeArray), List.of(0, 2, 10));

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
        assertEquals(types.getIntegerType(8), data.get("%uint_8"));
        assertEquals(types.getIntegerType(16), data.get("%uint_16"));
        assertEquals(types.getIntegerType(32), data.get("%uint_32"));
        assertEquals(types.getIntegerType(8), data.get("%int_8"));
        assertEquals(types.getIntegerType(16), data.get("%int_16"));
        assertEquals(types.getIntegerType(32), data.get("%int_32"));
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
        Type typeBoolean = types.getBooleanType();
        Type typeInteger = types.getIntegerType(32);

        assertEquals(types.getArrayType(typeBoolean, 5), data.get("%vector_bool_5"));
        assertEquals(types.getArrayType(typeBoolean, 10), data.get("%vector_bool_10"));
        assertEquals(types.getArrayType(typeInteger, 15), data.get("%vector_int_15"));
        assertEquals(types.getArrayType(typeInteger, 20), data.get("%vector_int_20"));
    }

    @Test
    public void testVectorTypeNonScalarElement() {
        builder.mockIntType("%uint", 32);
        builder.mockConstant("%uint_3", "%uint", 3);

        doTestNestedVectorType("""
                %subtype1 = OpTypeVector %uint 3
                %vector = OpTypeVector %subtype1 3
                """);
        doTestNestedVectorType("""
                %subtype2 = OpTypeArray %uint %uint_3
                %vector = OpTypeVector %subtype2 3
                """);
        doTestNestedVectorType("""
                %subtype3 = OpTypeRuntimeArray %uint
                %vector = OpTypeVector %subtype3 3
                """);
    }

    private void doTestNestedVectorType(String input) {
        try {
            parseTypes(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            assertEquals("Attempt to use a non-scalar element in vector type '%vector'", e.getMessage());
        }
    }

    @Test
    public void testArrayType() {
        // given
        String input = """
                %bool = OpTypeBool
                %int = OpTypeInt 32 1
                %array_bool_5 = OpTypeArray %bool %uint_5
                %array_bool_10 = OpTypeArray %bool %uint_10
                %array_int_15 = OpTypeArray %int %uint_15
                %array_int_20 = OpTypeArray %int %uint_20
                %array_array_bool = OpTypeArray %array_bool_5 %uint_10
                %array_array_int = OpTypeArray %array_int_15 %uint_20
                """;

        builder.mockIntType("%uint", 32);
        builder.mockConstant("%uint_5", "%uint", 5);
        builder.mockConstant("%uint_10", "%uint", 10);
        builder.mockConstant("%uint_15", "%uint", 15);
        builder.mockConstant("%uint_20", "%uint", 20);

        // when
        Map<String, Type> data = parseTypes(input);

        // then
        Type typeBoolean = types.getBooleanType();
        Type typeInteger = types.getIntegerType(32);

        assertEquals(types.getArrayType(typeBoolean, 5), data.get("%array_bool_5"));
        assertEquals(types.getArrayType(typeBoolean, 10), data.get("%array_bool_10"));
        assertEquals(types.getArrayType(typeInteger, 15), data.get("%array_int_15"));
        assertEquals(types.getArrayType(typeInteger, 20), data.get("%array_int_20"));
        assertEquals(types.getArrayType(data.get("%array_bool_5"), 10), data.get("%array_array_bool"));
        assertEquals(types.getArrayType(data.get("%array_int_15"), 20), data.get("%array_array_int"));
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
        ScopedPointerType boolPtr = (ScopedPointerType) data.get("%ptr_input_bool");
        assertEquals(Tag.Spirv.SC_INPUT, boolPtr.getScopeId());
        assertEquals(builder.getType("%bool"), boolPtr.getPointedType());

        ScopedPointerType inputIntPtr = (ScopedPointerType) data.get("%ptr_input_int");
        assertEquals(Tag.Spirv.SC_INPUT, inputIntPtr.getScopeId());
        assertEquals(builder.getType("%int"), inputIntPtr.getPointedType());

        ScopedPointerType workgroupIntPtr = (ScopedPointerType) data.get("%ptr_workgroup_int");
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
                %array = OpTypeArray %int %uint_5
                %ptr = OpTypePointer Input %int
                %f1 = OpTypeFunction %void
                %f2 = OpTypeFunction %bool %int %array
                %f3 = OpTypeFunction %ptr %ptr
                """;

        builder.mockIntType("%uint", 32);
        builder.mockConstant("%uint_5", "%uint", 5);

        // when
        Map<String, Type> data = parseTypes(input);

        // then
        Type typeVoid = types.getVoidType();
        Type typeBoolean = types.getBooleanType();
        Type typeInteger = types.getIntegerType(16);
        Type typeArray = types.getArrayType(typeInteger, 5);
        Type typePointer = types.getScopedPointerType(Tag.Spirv.SC_INPUT, typeInteger, null);

        assertEquals(data.get("%f1"), types.getFunctionType(typeVoid, List.of()));
        assertEquals(data.get("%f2"), types.getFunctionType(typeBoolean, List.of(typeInteger, typeArray)));
        assertEquals(data.get("%f3"), types.getFunctionType(typePointer, List.of(typePointer)));
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
                %array = OpTypeArray %int %uint_10
                %s1 = OpTypeStruct %int %array
                %ptr = OpTypePointer Input %s1
                %s2 = OpTypeStruct %bool %ptr
                %s3 = OpTypeStruct %bool %ptr
                """;

        builder.mockIntType("%uint", 32);
        builder.mockConstant("%uint_10", "%uint", 10);

        addMemberOffset("%s1", "0", "0");
        addMemberOffset("%s1", "1", "4");
        addMemberOffset("%s2", "0", "0");
        addMemberOffset("%s2", "1", "1");
        addMemberOffset("%s3", "0", "0");
        addMemberOffset("%s3", "1", "2");

        // when
        Map<String, Type> data = parseTypes(input);

        // then
        Type typeBoolean = types.getBooleanType();
        Type typeInteger = types.getIntegerType(32);
        Type typeArray = types.getArrayType(typeInteger, 10);
        Type typeStructFirst = types.getAggregateType(List.of(typeInteger, typeArray), List.of(0, 4));
        Type typePointer = types.getScopedPointerType(Tag.Spirv.SC_INPUT, typeStructFirst, null);
        Type typeStructSecond = types.getAggregateType(List.of(typeBoolean, typePointer), List.of(0, 1));
        Type typeStructThird = types.getAggregateType(List.of(typeBoolean, typePointer), List.of(0, 2));

        assertEquals(data.get("%s1"), typeStructFirst);
        assertEquals(data.get("%s2"), typeStructSecond);
        assertEquals(data.get("%s3"), typeStructThird);
        assertNotEquals(data.get("%s2"), data.get("%s3"));
    }

    @Test(expected = ParsingException.class)
    public void testStructTypeUndefinedReference() {
        // given
        String input = """
                %int = OpTypeInt 32 0
                %s1 = OpTypeStruct %int %ptr
                """;

        addMemberOffset("%s1", "0", "0");
        addMemberOffset("%s1", "1", "4");

        // when
        parseTypes(input);
    }

    @Test
    public void testAlignmentOpenCL() {
        // given
        String input = """
                %vector_uint_2 = OpTypeVector %uint 2
                %vector_uint_3 = OpTypeVector %uint 3
                %vector_uint_4 = OpTypeVector %uint 4
                %array_uint_2 = OpTypeArray %uint %uint_2
                %array_uint_3 = OpTypeArray %uint %uint_3
                %array_uint_4 = OpTypeArray %uint %uint_4
                """;

        builder.mockIntType("%uint", 32);
        builder.mockConstant("%uint_2", "%uint", 2);
        builder.mockConstant("%uint_3", "%uint", 3);
        builder.mockConstant("%uint_4", "%uint", 4);

        // when
        builder.setArch(Arch.OPENCL);
        parseTypes(input);

        // then
        assertNull(getAlignment("%vector_uint_2"));
        assertEquals(16, getAlignment("%vector_uint_3").intValue());
        assertNull(getAlignment("%vector_uint_4"));
        assertNull(getAlignment("%array_uint_2"));
        assertNull(getAlignment("%array_uint_3"));
        assertNull(getAlignment("%array_uint_4"));
    }

    @Test
    public void testAlignmentVulkan() {
        // given
        String input = """
                %vector_uint_2 = OpTypeVector %uint 2
                %vector_uint_3 = OpTypeVector %uint 3
                %vector_uint_4 = OpTypeVector %uint 4
                %array_uint_2 = OpTypeArray %uint %uint_2
                %array_uint_3 = OpTypeArray %uint %uint_3
                %array_uint_4 = OpTypeArray %uint %uint_4
                """;

        builder.mockIntType("%uint", 32);
        builder.mockConstant("%uint_2", "%uint", 2);
        builder.mockConstant("%uint_3", "%uint", 3);
        builder.mockConstant("%uint_4", "%uint", 4);

        // when
        builder.setArch(Arch.VULKAN);
        parseTypes(input);

        // then
        assertNull(getAlignment("%vector_uint_2"));
        assertNull(getAlignment("%vector_uint_3"));
        assertNull(getAlignment("%vector_uint_4"));
        assertNull(getAlignment("%array_uint_2"));
        assertNull(getAlignment("%array_uint_3"));
        assertNull(getAlignment("%array_uint_4"));
    }

    @Test
    public void testArrayStride() {
        Map<String, List<Integer>> iData = Map.of(
                "OpTypeArray %uint %uint_3", List.of(4, 8, 16),
                "OpTypeArray %array1 %uint_3", List.of(12, 16, 32),
                "OpTypeArray %array2 %uint_3", List.of(4, 12, 16, 32),

                "OpTypeRuntimeArray %uint", List.of(4, 8, 16),
                "OpTypeRuntimeArray %array1", List.of(12, 16, 32),
                "OpTypeRuntimeArray %array2", List.of(4, 12, 16, 32),

                "OpTypePointer Uniform %uint", List.of(4, 8, 16),
                "OpTypePointer Uniform %array1", List.of(12, 16, 32),
                "OpTypePointer Uniform %array2", List.of(4, 12, 16, 32)
        );

        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%array1", "%uint", 3);
        builder.mockVectorType("%array2", "%uint", -1);
        builder.mockConstant("%uint_3", "%uint", 3);
        Decoration decoration = builder.getDecorationsBuilder().getDecoration(ARRAY_STRIDE);

        int i = 0;
        for (String op : iData.keySet()) {
            for (Integer stride : iData.get(op)) {
                i++;
                // given
                String id1 = "%type1_" + i;
                String id2 = "%type2_" + i;

                // when
                decoration.addDecoration(id1, Integer.toString(stride));
                parseTypes(String.format("%s = %s\n%s = %s", id1, op, id2, op));

                // then
                assertEquals(stride, getArrayStride(id1));
                assertNull(getArrayStride(id2));
            }
        }
    }

    @Test
    public void testIllegalArrayStride() {
        Map<String, List<Integer>> iData = Map.of(
                "OpTypeArray %uint %uint_3", List.of(1, 3),
                "OpTypeArray %uint64 %uint_3", List.of(1, 4),
                "OpTypeArray %array %uint_3", List.of(1, 4, 8),

                "OpTypeRuntimeArray %uint", List.of(1, 3),
                "OpTypeRuntimeArray %uint64", List.of(1, 4),
                "OpTypeRuntimeArray %array", List.of(1, 4, 8),

                "OpTypePointer Uniform %uint", List.of(1, 3),
                "OpTypePointer Uniform %uint64", List.of(1, 4),
                "OpTypePointer Uniform %array", List.of(1, 4, 8)
        );

        builder.mockIntType("%uint", 32);
        builder.mockIntType("%uint64", 64);
        builder.mockVectorType("%array", "%uint", 3);
        builder.mockConstant("%uint_3", "%uint", 3);
        Decoration decoration = builder.getDecorationsBuilder().getDecoration(ARRAY_STRIDE);

        int i = 0;
        for (String op : iData.keySet()) {
            for (Integer stride : iData.get(op)) {
                i++;
                // given
                String id = "%type_" + i;
                decoration.addDecoration(id, Integer.toString(stride));
                try {
                    // when
                    parseTypes(String.format("%s = %s", id, op));
                    fail("Should throw exception");
                } catch (ParsingException e) {
                    // then
                    int size = op.contains("%array") ? 12 : op.contains("%uint64") ? 8 : 4;
                    assertEquals(String.format("Illegal array definition of type '%s', " +
                                    "element size %d exceeds the ArrayStride value %d",
                            id, size, stride), e.getMessage());
                }
            }
        }
    }

    private Map<String, Type> parseTypes(String input) {
        new MockSpirvParser(input).spv().accept(new VisitorOpsType(builder));
        return builder.getTypes();
    }

    private void addMemberOffset(String id, String idx, String offset) {
        builder.getDecorationsBuilder().getDecoration(DecorationType.OFFSET).addDecoration(id, idx, offset);
    }

    private Integer getArrayStride(String id) {
        Type type = builder.getType(id);
        if (type instanceof ArrayType aType) {
            return aType.getStride();
        }
        if (type instanceof ScopedPointerType pType) {
            return pType.getStride();
        }
        throw new RuntimeException("Unexpected type");
    }

    private Integer getAlignment(String id) {
        return ((ArrayType) builder.getType(id)).getAlignment();
    }
}
