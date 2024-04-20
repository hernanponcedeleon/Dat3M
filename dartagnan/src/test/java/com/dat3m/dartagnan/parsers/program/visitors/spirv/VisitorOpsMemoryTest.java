package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntBinaryExpr;
import com.dat3m.dartagnan.expression.misc.ConstructExpr;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilderSpv;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.junit.Test;

import java.util.List;
import java.util.Set;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.expression.integers.IntBinaryOp.MUL;
import static org.junit.Assert.*;

public class VisitorOpsMemoryTest {

    private static final TypeFactory TYPE_FACTORY = TypeFactory.getInstance();
    private static final ExpressionFactory EXPR_FACTORY = ExpressionFactory.getInstance();

    private final MockProgramBuilderSpv builder = new MockProgramBuilderSpv();

    @Test
    public void testLoad() {
        // given
        String input = "%result = OpLoad %int %ptr";
        IntegerType iType = builder.mockIntType("%int", 32);
        builder.mockPtrType("%int_ptr", "%int", "Uniform");
        MemoryObject memObj = builder.mockVariable("%ptr", "%int_ptr");

        // when
        parse(input);

        // then
        Load load = (Load) builder.getLastEvent();
        assertNotNull(load);
        assertEquals(memObj, load.getAddress());
        assertEquals(iType, load.getAccessType());
        assertEquals(Set.of(Tag.VISIBLE, Tag.MEMORY, Tag.READ, Tag.Spirv.SC_UNIFORM,
                        Tag.Spirv.MEM_NON_PRIVATE, Tag.Spirv.DEVICE), load.getTags());

        Register register = load.getResultRegister();
        assertEquals("%result", register.getName());
        assertEquals(register, builder.getExpression("%result"));
    }

    @Test
    public void testLoadWithTags() {
        // given
        String input = "%result = OpLoad %int %ptr MakePointerVisible %scope";
        IntegerType iType = builder.mockIntType("%int", 32);
        builder.mockPtrType("%int_ptr", "%int", "Workgroup");
        MemoryObject memObj = builder.mockVariable("%ptr", "%int_ptr");
        builder.mockConstant("%scope", "%int", 2);

        // when
        parse(input);

        // then
        Load load = (Load) builder.getLastEvent();
        assertNotNull(load);
        assertEquals(memObj, load.getAddress());
        assertEquals(iType, load.getAccessType());
        assertEquals(Set.of(Tag.VISIBLE, Tag.MEMORY, Tag.READ, Tag.Spirv.WORKGROUP,
                Tag.Spirv.MEM_VISIBLE, Tag.Spirv.MEM_NON_PRIVATE,
                Tag.Spirv.SC_WORKGROUP), load.getTags());

        Register register = load.getResultRegister();
        assertEquals("%result", register.getName());
        assertEquals(register, builder.getExpression("%result"));
    }

    @Test
    public void testLoadWithIllegalTags() {
        // given
        String input = "%result = OpLoad %int %ptr MakePointerAvailable %scope";
        builder.mockIntType("%int", 32);
        builder.mockPtrType("%int_ptr", "%int", "Uniform");
        builder.mockVariable("%ptr", "%int_ptr");
        builder.mockConstant("%scope", "%int", 3);

        try {
            // when
            parse(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals(String.format("OpLoad cannot contain tag '%s'",
                    Tag.Spirv.MEM_AVAILABLE), e.getMessage());
        }
    }

    @Test
    public void testStore() {
        // given
        String input = "OpStore %ptr %value";
        IntegerType iType = builder.mockIntType("%int", 32);
        builder.mockPtrType("%int_ptr", "%int", "Uniform");
        MemoryObject memObj = builder.mockVariable("%ptr", "%int_ptr");
        Expression value = builder.mockConstant("%value", "%int", 123);

        // when
        parse(input);

        // then
        Store store = (Store) builder.getLastEvent();
        assertNotNull(store);
        assertEquals(memObj, store.getAddress());
        assertEquals(iType, store.getAccessType());
        assertEquals(value, store.getMemValue());
        assertEquals(Set.of(Tag.VISIBLE, Tag.MEMORY, Tag.WRITE, Tag.Spirv.SC_UNIFORM,
                Tag.Spirv.MEM_NON_PRIVATE, Tag.Spirv.DEVICE), store.getTags());
    }

    @Test
    public void testStoreWithTags() {
        // given
        String input = "OpStore %ptr %value MakePointerAvailable %scope";
        IntegerType iType = builder.mockIntType("%int", 32);
        builder.mockPtrType("%int_ptr", "%int", "Workgroup");
        MemoryObject memObj = builder.mockVariable("%ptr", "%int_ptr");
        Expression value = builder.mockConstant("%value", "%int", 123);
        builder.mockConstant("%scope", "%int", 2);

        // when
        parse(input);

        // then
        Store store = (Store) builder.getLastEvent();
        assertNotNull(store);
        assertEquals(memObj, store.getAddress());
        assertEquals(iType, store.getAccessType());
        assertEquals(value, store.getMemValue());
        assertEquals(Set.of(Tag.VISIBLE, Tag.MEMORY, Tag.WRITE, Tag.Spirv.WORKGROUP,
                Tag.Spirv.MEM_AVAILABLE, Tag.Spirv.MEM_NON_PRIVATE,
                Tag.Spirv.SC_WORKGROUP), store.getTags());
    }

    @Test
    public void testStoreWithIllegalTags() {
        // given
        String input = "OpStore %ptr %value MakePointerVisible %scope";
        builder.mockIntType("%int", 32);
        builder.mockPtrType("%int_ptr", "%int", "Uniform");
        builder.mockVariable("%ptr", "%int_ptr");
        builder.mockConstant("%value", "%int", 123);
        builder.mockConstant("%scope", "%int", 2);

        try {
            // when
            parse(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals(String.format("OpStore cannot contain tag '%s'",
                    Tag.Spirv.MEM_VISIBLE), e.getMessage());
        }
    }

    @Test
    public void testVariable() {
        // given
        String input = """
                %v1 = OpVariable %b_ptr Uniform
                %v2 = OpVariable %i_ptr Uniform
                %v3 = OpVariable %v3int_ptr Uniform
                %v4 = OpVariable %struct_ptr Uniform
                """;

        Type[] types = {
                builder.mockBoolType("%bool"),
                builder.mockIntType("%int", 32),
                builder.mockVectorType("%v3int", "%int", 3),
                builder.mockAggregateType("%struct", "%bool", "%int", "%v3int")
        };

        builder.mockPtrType("%b_ptr", "%bool", "Uniform");
        builder.mockPtrType("%i_ptr", "%int", "Uniform");
        builder.mockPtrType("%v3int_ptr", "%v3int", "Uniform");
        builder.mockPtrType("%struct_ptr", "%struct", "Uniform");

        // when
        parse(input);

        // then
        String[] variables = {"%v1", "%v2", "%v3", "%v4"};
        for (int i = 0; i < 4; i++) {
            MemoryObject memObj = (MemoryObject) builder.getExpression(variables[i]);
            assertNotNull(memObj);
            assertEquals(TYPE_FACTORY.getMemorySizeInBytes(types[i]), memObj.size());
        }
    }

    @Test
    public void testInitializedVariableConstant() {
        String input = """
                %v1 = OpVariable %b_ptr Uniform %b_const
                %v2 = OpVariable %i_ptr Uniform %i_const
                %v3 = OpVariable %v3int_ptr Uniform %v3int_const
                %v4 = OpVariable %struct_ptr Uniform %struct_const
                """;

        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 32);
        builder.mockVectorType("%v3int", "%int", 3);
        builder.mockAggregateType("%struct", "%bool", "%int", "%v3int");

        builder.mockConstant("%b_const", "%bool", true);
        builder.mockConstant("%i_const", "%int", 7890);
        builder.mockConstant("%v3int_const", "%v3int", List.of(1, 2, 3));
        builder.mockConstant("%struct_const", "%struct", List.of("%b_const", "%i_const", "%v3int_const"));

        doTestInitializedVariable(input);
    }

    @Test
    public void testInitializedVariableInput() {
        String input = """
                %v1 = OpVariable %b_ptr Uniform
                %v2 = OpVariable %i_ptr Uniform
                %v3 = OpVariable %v3int_ptr Uniform
                %v4 = OpVariable %struct_ptr Uniform
                """;

        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 32);
        builder.mockVectorType("%v3int", "%int", 3);
        builder.mockAggregateType("%struct", "%bool", "%int", "%v3int");

        IntegerType archType = TYPE_FACTORY.getArchType();
        Expression i1 = EXPR_FACTORY.makeValue(1, archType);
        Expression i2 = EXPR_FACTORY.makeValue(7890, archType);
        List<Expression> iValues = Stream.of(1, 2, 3).map(i -> (Expression) EXPR_FACTORY.makeValue(i, archType)).toList();
        Expression i3 = EXPR_FACTORY.makeArray(archType, iValues, true);
        Expression i4 = EXPR_FACTORY.makeConstruct(List.of(i1, i2, i3));

        builder.addInput("%v1", i1);
        builder.addInput("%v2", i2);
        builder.addInput("%v3", i3);
        builder.addInput("%v4", i4);

        doTestInitializedVariable(input);
    }

    private void doTestInitializedVariable(String input) {
        // given
        builder.mockPtrType("%b_ptr", "%bool", "Uniform");
        builder.mockPtrType("%i_ptr", "%int", "Uniform");
        builder.mockPtrType("%v3int_ptr", "%v3int", "Uniform");
        builder.mockPtrType("%struct_ptr", "%struct", "Uniform");

        // when
        parse(input);

        // then
        IntegerType iType = (IntegerType) builder.getType("%int");
        Expression o1 = EXPR_FACTORY.makeTrue();
        Expression o2 = EXPR_FACTORY.makeValue(7890, iType);
        List<Expression> oValues = Stream.of(1, 2, 3).map(i -> (Expression) EXPR_FACTORY.makeValue(i, iType)).toList();
        ConstructExpr o3 = EXPR_FACTORY.makeArray(iType, oValues, true);
        ConstructExpr o4 = EXPR_FACTORY.makeConstruct(List.of(o1, o2, o3));

        MemoryObject v1 = (MemoryObject) builder.getExpression("%v1");
        assertNotNull(v1);
        assertEquals(TYPE_FACTORY.getMemorySizeInBytes(builder.getType("%bool")), v1.size());
        assertEquals(o1, v1.getInitialValue(0));

        MemoryObject v2 = (MemoryObject) builder.getExpression("%v2");
        assertNotNull(v2);
        assertEquals(TYPE_FACTORY.getMemorySizeInBytes(builder.getType("%int")), v2.size());
        assertEquals(o2, v2.getInitialValue(0));

        MemoryObject v3 = (MemoryObject) builder.getExpression("%v3");
        assertNotNull(v3);
        assertEquals(TYPE_FACTORY.getMemorySizeInBytes(builder.getType("%v3int")), v3.size());
        List<Expression> arrElements = o3.getOperands();
        assertEquals(arrElements.get(0), v3.getInitialValue(0));
        assertEquals(arrElements.get(1), v3.getInitialValue(4));
        assertEquals(arrElements.get(2), v3.getInitialValue(8));

        MemoryObject v4 = (MemoryObject) builder.getExpression("%v4");
        assertNotNull(v4);
        assertEquals(TYPE_FACTORY.getMemorySizeInBytes(builder.getType("%struct")), v4.size());
        List<Expression> structElements = o4.getOperands();
        assertEquals(structElements.get(0), v4.getInitialValue(0));
        assertEquals(structElements.get(1), v4.getInitialValue(1));
        assertEquals(arrElements.get(0), v4.getInitialValue(5));
        assertEquals(arrElements.get(1), v4.getInitialValue(9));
        assertEquals(arrElements.get(2), v4.getInitialValue(13));
    }

    @Test
    public void testRuntimeArray() {
        // given
        String input = """
                %v1 = OpVariable %v1_ptr Uniform
                %v2 = OpVariable %v2_ptr Uniform
                %v3 = OpVariable %v3_ptr Uniform
                """;

        IntegerType iType = builder.mockIntType("%int", 32);
        builder.mockVectorType("%ra", "%int", -1);
        builder.mockVectorType("%v3ra", "%ra", 3);
        builder.mockAggregateType("%s1i1ra", "%int", "%ra");

        builder.mockPtrType("%v1_ptr", "%ra", "Uniform");
        builder.mockPtrType("%v2_ptr", "%v3ra", "Uniform");
        builder.mockPtrType("%v3_ptr", "%s1i1ra", "Uniform");

        IntegerType archType = TYPE_FACTORY.getArchType();
        Type aType = TYPE_FACTORY.getArrayType(archType, 2);

        Expression i1 = EXPR_FACTORY.makeValue(1, archType);
        Expression i2 = EXPR_FACTORY.makeValue(2, archType);
        Expression i3 = EXPR_FACTORY.makeValue(3, archType);
        Expression i4 = EXPR_FACTORY.makeValue(4, archType);
        Expression i5 = EXPR_FACTORY.makeValue(5, archType);
        Expression i6 = EXPR_FACTORY.makeValue(6, archType);

        Expression a1 = EXPR_FACTORY.makeArray(archType, List.of(i1, i2), true);
        Expression a2 = EXPR_FACTORY.makeArray(archType, List.of(i3, i4), true);
        Expression a3 = EXPR_FACTORY.makeArray(archType, List.of(i5, i6), true);

        Expression a3a = EXPR_FACTORY.makeArray(aType, List.of(a1, a2, a3), true);
        Expression s = EXPR_FACTORY.makeConstruct(List.of(i1, a1));

        builder.addInput("%v1", a1);
        builder.addInput("%v2", a3a);
        builder.addInput("%v3", s);

        // when
        parse(input);

        // then
        Expression o1 = EXPR_FACTORY.makeValue(1, iType);
        Expression o2 = EXPR_FACTORY.makeValue(2, iType);
        Expression o3 = EXPR_FACTORY.makeValue(3, iType);
        Expression o4 = EXPR_FACTORY.makeValue(4, iType);
        Expression o5 = EXPR_FACTORY.makeValue(5, iType);
        Expression o6 = EXPR_FACTORY.makeValue(6, iType);

        Type ot1 = TYPE_FACTORY.getArrayType(iType, 2);
        Type ot2 = TYPE_FACTORY.getArrayType(ot1, 3);
        Type ot3 = TYPE_FACTORY.getAggregateType(List.of(iType, ot1));

        MemoryObject v1 = (MemoryObject) builder.getExpression("%v1");
        assertEquals(TYPE_FACTORY.getMemorySizeInBytes(ot1), v1.size());
        assertEquals(o1, v1.getInitialValue(0));
        assertEquals(o2, v1.getInitialValue(4));

        MemoryObject v2 = (MemoryObject) builder.getExpression("%v2");
        assertEquals(TYPE_FACTORY.getMemorySizeInBytes(ot2), v2.size());
        assertEquals(o1, v2.getInitialValue(0));
        assertEquals(o2, v2.getInitialValue(4));
        assertEquals(o3, v2.getInitialValue(8));
        assertEquals(o4, v2.getInitialValue(12));
        assertEquals(o5, v2.getInitialValue(16));
        assertEquals(o6, v2.getInitialValue(20));

        MemoryObject v3 = (MemoryObject) builder.getExpression("%v3");
        assertEquals(TYPE_FACTORY.getMemorySizeInBytes(ot3), v3.size());
        assertEquals(o1, v3.getInitialValue(0));
        assertEquals(o1, v3.getInitialValue(4));
        assertEquals(o2, v3.getInitialValue(8));
    }

    @Test
    public void testRuntimeArrayFromConstant() {
        // given
        String input = "%v = OpVariable %ra_ptr Uniform %value";

        builder.mockIntType("%int", 32);
        builder.mockVectorType("%ra", "%int", -1);
        builder.mockVectorType("%i2a", "%int", 2);
        builder.mockPtrType("%ra_ptr", "%ra", "Uniform");

        ConstructExpr arr = (ConstructExpr) builder.mockConstant("%value", "%i2a", List.of(1, 2));

        // when
        parse(input);

        // then
        MemoryObject v = (MemoryObject) builder.getExpression("%v");
        assertNotNull(v);
        assertEquals(TYPE_FACTORY.getMemorySizeInBytes(arr.getType()), v.size());
        assertEquals(arr.getOperands().get(0), v.getInitialValue(0));
        assertEquals(arr.getOperands().get(1), v.getInitialValue(4));
    }

    @Test
    public void testReusingRuntimeArrayType() {
        // given
        String input = """
                %v1 = OpVariable %v1_ptr Uniform
                %v2 = OpVariable %v2_ptr Uniform
                """;

        IntegerType iType = builder.mockIntType("%int", 64);
        builder.mockVectorType("%ra", "%int", -1);
        builder.mockPtrType("%v1_ptr", "%ra", "Uniform");
        builder.mockPtrType("%v2_ptr", "%ra", "Uniform");

        Expression i1 = EXPR_FACTORY.makeValue(1, iType);
        Expression i2 = EXPR_FACTORY.makeValue(2, iType);
        Expression i3 = EXPR_FACTORY.makeValue(3, iType);

        Expression a1 = EXPR_FACTORY.makeArray(iType, List.of(i1, i2), true);
        Expression a2 = EXPR_FACTORY.makeArray(iType, List.of(i1, i2, i3), true);

        builder.addInput("%v1", a1);
        builder.addInput("%v2", a2);

        // when
        parse(input);

        // then
        MemoryObject v1 = (MemoryObject) builder.getExpression("%v1");
        assertNotNull(v1);
        assertEquals(TYPE_FACTORY.getMemorySizeInBytes(a1.getType()), v1.size());
        assertEquals(i1, v1.getInitialValue(0));
        assertEquals(i2, v1.getInitialValue(8));

        MemoryObject v2 = (MemoryObject) builder.getExpression("%v2");
        assertNotNull(v2);
        assertEquals(TYPE_FACTORY.getMemorySizeInBytes(a2.getType()), v2.size());
        assertEquals(i1, v2.getInitialValue(0));
        assertEquals(i2, v2.getInitialValue(8));
        assertEquals(i3, v2.getInitialValue(16));
    }

    @Test
    public void testUninitializedRuntimeVariable() {
        // given
        String input = "%v = OpVariable %arr_ptr Uniform";
        builder.mockIntType("%int", 32);
        builder.mockVectorType("%arr", "%int", -1);
        builder.mockPtrType("%arr_ptr", "%arr", "Uniform");

        try {
            // when
            parse(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Missing initial value for runtime variable '%v'",
                    e.getMessage());
        }
    }

    @Test
    public void testVariableNotPointerType() {
        // given
        String input = "%v = OpVariable %int Uniform";
        builder.mockIntType("%int", 32);

        try {
            // when
            parse(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Type '%int' is not a pointer type", e.getMessage());
        }
    }

    @Test
    public void testMismatchingValueTypeConstant() {
        // given
        String input = "%v = OpVariable %i_ptr Uniform %const";

        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 32);
        builder.mockPtrType("%i_ptr", "%int", "Uniform");
        builder.mockConstant("%const", "%bool", true);

        try {
            // when
            parse(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Mismatching value type for variable '%v', " +
                    "expected 'bv32' but received 'bool'", e.getMessage());
        }
    }

    @Test
    public void testMismatchingValueTypeInput() {
        // given
        String input = "%v = OpVariable %i_ptr Uniform";

        IntegerType iType = builder.mockIntType("%int", 32);
        builder.mockVectorType("%v2i", "%int", 2);
        builder.mockPtrType("%i_ptr", "%int", "Uniform");

        Expression i1 = EXPR_FACTORY.makeValue(1, iType);
        Expression i2 = EXPR_FACTORY.makeValue(2, iType);
        Expression a = EXPR_FACTORY.makeArray(iType, List.of(i1, i2), true);

        builder.addInput("%v", a);

        try {
            // when
            parse(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Mismatching value type for variable '%v', " +
                    "expected 'bv32' but received '[2 x bv32]'", e.getMessage());
        }
    }

    @Test
    public void testMismatchingValueTypeInNestedArray() {
        // given
        String input = "%v = OpVariable %arr2int_ptr Uniform %const";

        Type bType = builder.mockBoolType("%bool");
        Type a1Type = builder.mockVectorType("%arr1bool", "%bool", 2);
        builder.mockVectorType("%arr2bool", "%arr1bool", 2);

        builder.mockIntType("%int", 32);
        builder.mockVectorType("%arr1int", "%int", 2);
        builder.mockVectorType("%arr2int", "%arr1int", 2);

        builder.mockPtrType("%arr2int_ptr", "%arr2int", "Uniform");

        Expression bool = EXPR_FACTORY.makeTrue();
        Expression arr1 = EXPR_FACTORY.makeArray(bType, List.of(bool, bool), true);
        Expression arr2 = EXPR_FACTORY.makeArray(a1Type, List.of(arr1, arr1), true);

        builder.addConstant("%const", arr2);

        try {
            // when
            parse(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Mismatching value type for variable '%v', " +
                    "expected 'bv32' but received 'bool'", e.getMessage());
        }
    }

    @Test
    public void testMismatchingValueTypeInNestedStruct() {
        // given
        String input = "%v = OpVariable %struct2_ptr Uniform %const";

        builder.mockBoolType("%bool");
        builder.mockIntType("%int16", 16);
        IntegerType i32Type = builder.mockIntType("%int32", 32);

        builder.mockAggregateType("%struct1", "%bool", "%int16");
        builder.mockAggregateType("%struct2", "%bool", "%struct1");

        builder.mockPtrType("%struct2_ptr", "%struct2", "Uniform");

        Expression bool = EXPR_FACTORY.makeTrue();
        Expression int32 = EXPR_FACTORY.makeValue(1, i32Type);
        Expression struct1 = EXPR_FACTORY.makeConstruct(List.of(bool, int32));
        Expression struct2 = EXPR_FACTORY.makeConstruct(List.of(bool, struct1));

        builder.addConstant("%const", struct2);

        try {
            // when
            parse(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Mismatching value type for variable '%v', " +
                    "expected 'bv16' but received 'bv32'", e.getMessage());
        }
    }

    @Test
    public void testInputForInitializedVariable() {
        // given
        String input = "%v = OpVariable %i_ptr Uniform %i_const";

        IntegerType iType = builder.mockIntType("%int", 32);
        builder.mockPtrType("%i_ptr", "%int", "Uniform");

        builder.mockConstant("%i_const", "%int", 1);
        builder.addInput("%v", EXPR_FACTORY.makeValue(2, iType));

        try {
            // when
            parse(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("The original value of variable '%v' " +
                    "cannot be overwritten by an external input", e.getMessage());
        }
    }

    @Test
    public void testAccessChainArray() {
        // given
        String input = """
                %variable = OpVariable %v2v2v2i_ptr Uniform %const
                %element = OpAccessChain %i_ptr %variable %1 %0 %1
                """;

        IntegerType iType = builder.mockIntType("%int", 32);
        ArrayType v2iType = builder.mockVectorType("%v2i", "%int", 2);
        ArrayType v2v2iType = builder.mockVectorType("%v2v2i", "%v2i", 2);
        builder.mockVectorType("%v2v2v2i", "%v2v2i", 2);
        builder.mockPtrType("%i_ptr", "%int", "Uniform");
        builder.mockPtrType("%v2v2v2i_ptr", "%v2v2v2i", "Uniform");

        Expression i32 = EXPR_FACTORY.makeValue(1, iType);
        Expression arr1 = EXPR_FACTORY.makeArray(iType, List.of(i32, i32), true);
        Expression arr2 = EXPR_FACTORY.makeArray(v2iType, List.of(arr1, arr1), true);
        Expression arr3 = EXPR_FACTORY.makeArray(v2v2iType, List.of(arr2, arr2), true);

        builder.addConstant("%const", arr3);

        Expression i0 = builder.addConstant("%0", EXPR_FACTORY.makeValue(0, iType));
        Expression i1 = builder.addConstant("%1", EXPR_FACTORY.makeValue(1, iType));

        // when
        parse(input);

        // then
        IntBinaryExpr e1 = (IntBinaryExpr) builder.getExpression("%element");
        assertEquals(TYPE_FACTORY.getArchType(), e1.getType());
        assertEquals(builder.getExpression("%variable"), e1.getLeft());

        IntBinaryExpr e2 = (IntBinaryExpr) e1.getRight();
        assertEquals(makeOffset(i1, 16), e2.getLeft());

        IntBinaryExpr e3 = (IntBinaryExpr) e2.getRight();
        assertEquals(makeOffset(i0, 8), e3.getLeft());
        assertEquals(makeOffset(i1, 4), e3.getRight());
    }

    @Test
    public void testAccessChainStruct() {
        // given
        String input = """
                %variable = OpVariable %agg2_ptr Uniform %const
                %element = OpAccessChain %i32_ptr %variable %4 %2
                """;

        builder.mockBoolType("%bool");
        IntegerType i16Type = builder.mockIntType("%int16", 16);
        IntegerType i32Type = builder.mockIntType("%int32", 32);
        IntegerType i64Type = builder.mockIntType("%int64", 64);

        builder.mockAggregateType("%agg1", "%bool", "%int16", "%int32", "%int64");
        builder.mockAggregateType("%agg2", "%bool", "%int16", "%int32", "%int64", "%agg1");
        builder.mockPtrType("%i32_ptr", "%int32", "Uniform");
        builder.mockPtrType("%agg2_ptr", "%agg2", "Uniform");

        Expression b = EXPR_FACTORY.makeFalse();
        Expression i16 = EXPR_FACTORY.makeValue(1, i16Type);
        Expression i32 = EXPR_FACTORY.makeValue(11, i32Type);
        Expression i64 = EXPR_FACTORY.makeValue(111, i64Type);
        Expression agg1 = EXPR_FACTORY.makeConstruct(List.of(b, i16, i32, i64));
        Expression agg2 = EXPR_FACTORY.makeConstruct(List.of(b, i16, i32, i64, agg1));

        builder.addConstant("%const", agg2);

        builder.addConstant("%2", EXPR_FACTORY.makeValue(2, i32Type));
        builder.addConstant("%4", EXPR_FACTORY.makeValue(4, i32Type));

        // when
        parse(input);

        // then
        IntBinaryExpr e1 = (IntBinaryExpr) builder.getExpression("%element");
        assertEquals(TYPE_FACTORY.getArchType(), e1.getType());
        assertEquals(builder.getExpression("%variable"), e1.getLeft());

        IntBinaryExpr e2 = (IntBinaryExpr) e1.getRight();
        assertEquals(EXPR_FACTORY.makeValue(15, i64Type), e2.getLeft());
        assertEquals(EXPR_FACTORY.makeValue(3, i64Type), e2.getRight());
    }

    @Test
    public void testAccessChainArrayRegister() {
        // given
        String input = """
                %variable = OpVariable %v2i_ptr Uniform %const
                %element = OpAccessChain %i_ptr %variable %register
                """;

        IntegerType i32Type = builder.mockIntType("%int", 32);
        builder.mockVectorType("%v2i", "%int", 2);
        builder.mockPtrType("%v2i_ptr", "%v2i", "Uniform");
        builder.mockPtrType("%i_ptr", "%int", "Uniform");

        Expression i1 = EXPR_FACTORY.makeValue(1, i32Type);
        Expression i2 = EXPR_FACTORY.makeValue(2, i32Type);
        Expression arr = EXPR_FACTORY.makeArray(i32Type, List.of(i1, i2), true);

        builder.addConstant("%const", arr);

        // when
        builder.mockFunctionStart();
        builder.mockLabel();
        Register register = builder.mockRegister("%register", "%int");
        new MockSpirvParser(input).spv().accept(new VisitorOpsMemory(builder));

        // then
        IntBinaryExpr e = (IntBinaryExpr) builder.getExpression("%element");
        assertEquals(TYPE_FACTORY.getArchType(), e.getType());
        assertEquals(builder.getExpression("%variable"), e.getLeft());
        assertEquals(makeOffset(register, 4), e.getRight());
    }

    @Test
    public void testAccessChainStructureRegister() {
        // given
        String input = """
                %variable = OpVariable %agg_ptr Uniform %const
                %element = OpAccessChain %i16_ptr %variable %register
                """;

        IntegerType i16Type = builder.mockIntType("%int16", 16);
        IntegerType i32Type = builder.mockIntType("%int32", 32);
        builder.mockAggregateType("%agg", "%int16", "%int32");

        builder.mockPtrType("%i16_ptr", "%int16", "Uniform");
        builder.mockPtrType("%agg_ptr", "%agg", "Uniform");

        Expression i1 = EXPR_FACTORY.makeValue(1, i16Type);
        Expression i2 = EXPR_FACTORY.makeValue(2, i32Type);
        Expression arr = EXPR_FACTORY.makeConstruct(List.of(i1, i2));

        builder.addConstant("%const", arr);
        builder.mockFunctionStart();
        builder.mockLabel();
        builder.mockRegister("%register", "%int32");
        VisitorOpsMemory visitor = new VisitorOpsMemory(builder);
        SpirvParser.SpvContext ctx = new MockSpirvParser(input).spv();

        try {
            // when
            ctx.accept(visitor);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Unsupported non-constant offset in access chain '%element'",
                    e.getMessage());
        }
    }

    @Test
    public void testAccessChainWrongDepth() {
        // given
        String input = """
                %variable = OpVariable %v2i_ptr Uniform %const
                %element = OpAccessChain %i_ptr %variable %0 %0
                """;

        IntegerType iType = builder.mockIntType("%int", 32);
        builder.mockVectorType("%v2i", "%int", 2);
        builder.mockPtrType("%i_ptr", "%int", "Uniform");
        builder.mockPtrType("%v2i_ptr", "%v2i", "Uniform");

        Expression i1 = EXPR_FACTORY.makeValue(1, iType);
        Expression i2 = EXPR_FACTORY.makeValue(2, iType);
        Expression arr = EXPR_FACTORY.makeArray(iType, List.of(i1, i2), true);

        builder.addConstant("%const", arr);
        builder.addConstant("%0", EXPR_FACTORY.makeValue(0, iType));

        try {
            // when
            parse(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Referring to a scalar type in access chain '%element'", e.getMessage());
        }
    }

    @Test
    public void testAccessChainMismatchingTypeArray() {
        // given
        String input = """
                %variable = OpVariable %v2i_ptr Uniform %const
                %element = OpAccessChain %i16_ptr %variable %0
                """;

        IntegerType i32Type = builder.mockIntType("%int32", 32);
        builder.mockVectorType("%v2i", "%int32", 2);
        builder.mockPtrType("%v2i_ptr", "%v2i", "Uniform");
        builder.mockIntType("%int16", 16);
        builder.mockPtrType("%i16_ptr", "%int16", "Uniform");

        Expression i1 = EXPR_FACTORY.makeValue(1, i32Type);
        Expression i2 = EXPR_FACTORY.makeValue(2, i32Type);
        Expression arr = EXPR_FACTORY.makeArray(i32Type, List.of(i1, i2), true);

        builder.addConstant("%const", arr);
        builder.addConstant("%0", EXPR_FACTORY.makeValue(0, i32Type));

        try {
            // when
            parse(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Invalid value type in access chain '%element', " +
                    "expected 'bv16' but received 'bv32'", e.getMessage());
        }
    }

    @Test
    public void testAccessChainMismatchingTypeStructure() {
        // given
        String input = """
                %variable = OpVariable %agg_ptr Uniform %const
                %element = OpAccessChain %i16_ptr %variable %1
                """;

        IntegerType i16Type = builder.mockIntType("%int16", 16);
        IntegerType i32Type = builder.mockIntType("%int32", 32);
        builder.mockAggregateType("%agg", "%int16", "%int32");

        builder.mockPtrType("%i16_ptr", "%int16", "Uniform");
        builder.mockPtrType("%agg_ptr", "%agg", "Uniform");

        Expression i1 = EXPR_FACTORY.makeValue(1, i16Type);
        Expression i2 = EXPR_FACTORY.makeValue(2, i32Type);
        Expression arr = EXPR_FACTORY.makeConstruct(List.of(i1, i2));

        builder.addConstant("%const", arr);
        builder.addConstant("%1", EXPR_FACTORY.makeValue(1, i32Type));

        try {
            // when
            parse(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Invalid value type in access chain '%element', " +
                    "expected 'bv16' but received 'bv32'", e.getMessage());
        }
    }

    private Expression makeOffset(Expression stepExpr, int stepSize) {
        IntegerType archType = TYPE_FACTORY.getArchType();
        Expression stepCastExpr = EXPR_FACTORY.makeCast(stepExpr, archType);
        return EXPR_FACTORY.makeBinary(EXPR_FACTORY.makeValue(stepSize, archType), MUL, stepCastExpr);
    }

    private void parse(String input) {
        builder.mockFunctionStart();
        builder.mockLabel();
        new MockSpirvParser(input).spv().accept(new VisitorOpsMemory(builder));
    }
}
