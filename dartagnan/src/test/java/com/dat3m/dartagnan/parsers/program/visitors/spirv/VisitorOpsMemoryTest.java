package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.misc.GEPExpr;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.memory.ScopedPointer;
import com.dat3m.dartagnan.program.memory.ScopedPointerVariable;
import org.junit.Test;

import java.util.List;
import java.util.Set;
import java.util.stream.Stream;

import static org.junit.Assert.*;

public class VisitorOpsMemoryTest {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private MockProgramBuilder builder = new MockProgramBuilder();

    @Test
    public void testLoad() {
        // given
        String input = "%result = OpLoad %int %ptr";
        IntegerType iType = builder.mockIntType("%int", 32);
        builder.mockPtrType("%int_ptr", "%int", "Uniform");
        ScopedPointerVariable pointer = builder.mockVariable("%ptr", "%int_ptr");

        // when
        parse(input);

        // then
        Load load = (Load) getLastEvent();
        assertNotNull(load);
        assertEquals(pointer, load.getAddress());
        assertEquals(iType, load.getAccessType());
        assertEquals(Set.of(Tag.VISIBLE, Tag.MEMORY, Tag.READ, Tag.Spirv.SC_UNIFORM), load.getTags());

        Register register = load.getResultRegister();
        assertEquals("%result", register.getName());
        assertEquals(register, builder.getExpression("%result"));
    }

    @Test
    public void testLoadWithTags() {
        // given
        String input = "%result = OpLoad %int %ptr MakePointerVisible|NonPrivatePointer %scope";
        IntegerType iType = builder.mockIntType("%int", 32);
        builder.mockPtrType("%int_ptr", "%int", "Workgroup");
        ScopedPointerVariable pointer = builder.mockVariable("%ptr", "%int_ptr");
        builder.mockConstant("%scope", "%int", 2);

        // when
        parse(input);

        // then
        Load load = (Load) getLastEvent();
        assertNotNull(load);
        assertEquals(pointer, load.getAddress());
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
        String input = "%result = OpLoad %int %ptr NonPrivatePointer|MakePointerAvailable %scope";
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
    public void testLoadVector() {
        // given
        IntegerType integerType = builder.mockIntType("%int", 32);
        builder.mockVectorType("%v4int4", "%int", 4);
        builder.mockPtrType("%ptr_v4int4", "%int", "Uniform");
        String input = """
                %ptr = OpVariable %ptr_v4int4 Uniform
                %result = OpLoad %v4int4 %ptr
                """;

        // when
        parse(input);

        // then
        ConstructExpr pointerVariable = (ConstructExpr) builder.getExpression("%result");
        assertNotNull(pointerVariable);
        assertEquals(4, pointerVariable.getOperands().size());
        assertEquals(integerType, pointerVariable.getOperands().get(0).getType());
    }

    @Test
    public void testStore() {
        // given
        String input = "OpStore %ptr %value";
        IntegerType iType = builder.mockIntType("%int", 32);
        builder.mockPtrType("%int_ptr", "%int", "Uniform");
        ScopedPointerVariable pointer = builder.mockVariable("%ptr", "%int_ptr");
        Expression value = builder.mockConstant("%value", "%int", 123);

        // when
        parse(input);

        // then
        Store store = (Store) getLastEvent();
        assertNotNull(store);
        assertEquals(pointer, store.getAddress());
        assertEquals(iType, store.getAccessType());
        assertEquals(value, store.getMemValue());
        assertEquals(Set.of(Tag.VISIBLE, Tag.MEMORY, Tag.WRITE, Tag.Spirv.SC_UNIFORM), store.getTags());
    }

    @Test
    public void testStoreWithTags() {
        // given
        String input = "OpStore %ptr %value MakePointerAvailable|NonPrivatePointer %scope";
        IntegerType iType = builder.mockIntType("%int", 32);
        builder.mockPtrType("%int_ptr", "%int", "Workgroup");
        ScopedPointerVariable pointer = builder.mockVariable("%ptr", "%int_ptr");
        Expression value = builder.mockConstant("%value", "%int", 123);
        builder.mockConstant("%scope", "%int", 2);

        // when
        parse(input);

        // then
        Store store = (Store) getLastEvent();
        assertNotNull(store);
        assertEquals(pointer, store.getAddress());
        assertEquals(iType, store.getAccessType());
        assertEquals(value, store.getMemValue());
        assertEquals(Set.of(Tag.VISIBLE, Tag.MEMORY, Tag.WRITE, Tag.Spirv.WORKGROUP,
                Tag.Spirv.MEM_AVAILABLE, Tag.Spirv.MEM_NON_PRIVATE,
                Tag.Spirv.SC_WORKGROUP), store.getTags());
    }

    @Test
    public void testStoreWithIllegalTags() {
        // given
        String input = "OpStore %ptr %value NonPrivatePointer|MakePointerVisible %scope";
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
            ScopedPointerVariable pointer = (ScopedPointerVariable) builder.getExpression(variables[i]);
            assertNotNull(pointer);
            assertEquals(VisitorOpsMemoryTest.types.getMemorySizeInBytes(types[i]), pointer.getAddress().getKnownSize());
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

        IntegerType archType = types.getArchType();
        Expression i1 = expressions.makeValue(1, archType);
        Expression i2 = expressions.makeValue(7890, archType);
        List<Expression> iValues = Stream.of(1, 2, 3).map(i -> (Expression) expressions.makeValue(i, archType)).toList();
        ArrayType arType = types.getArrayType(archType, 3);
        Expression i3 = expressions.makeArray(arType, iValues);
        AggregateType agType = types.getAggregateType(List.of(i1.getType(), i2.getType(), i3.getType()));
        Expression i4 = expressions.makeConstruct(agType, List.of(i1, i2, i3));

        builder = new MockProgramBuilder();
        builder.addInput("%v1", i1);
        builder.addInput("%v2", i2);
        builder.addInput("%v3", i3);
        builder.addInput("%v4", i4);

        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 32);
        builder.mockVectorType("%v3int", "%int", 3);
        builder.mockAggregateType("%struct", "%bool", "%int", "%v3int");

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
        Expression o1 = expressions.makeTrue();
        Expression o2 = expressions.makeValue(7890, iType);
        List<Expression> oValues = Stream.of(1, 2, 3).map(i -> (Expression) expressions.makeValue(i, iType)).toList();
        ArrayType arType = types.getArrayType(iType, 3);
        Expression o3 = expressions.makeArray(arType, oValues);
        AggregateType agType = types.getAggregateType(List.of(o1.getType(), o2.getType(), o3.getType()));
        Expression o4 = expressions.makeConstruct(agType, List.of(o1, o2, o3));

        ScopedPointerVariable v1 = (ScopedPointerVariable) builder.getExpression("%v1");
        assertNotNull(v1);
        assertEquals(types.getMemorySizeInBytes(builder.getType("%bool")), v1.getAddress().getKnownSize());
        assertEquals(o1, v1.getAddress().getInitialValue(0));

        ScopedPointerVariable v2 = (ScopedPointerVariable) builder.getExpression("%v2");
        assertNotNull(v2);
        assertEquals(types.getMemorySizeInBytes(builder.getType("%int")), v2.getAddress().getKnownSize());
        assertEquals(o2, v2.getAddress().getInitialValue(0));

        ScopedPointerVariable v3 = (ScopedPointerVariable) builder.getExpression("%v3");
        assertNotNull(v3);
        assertEquals(types.getMemorySizeInBytes(builder.getType("%v3int")), v3.getAddress().getKnownSize());
        List<Expression> arrElements = o3.getOperands();
        assertEquals(arrElements.get(0), v3.getAddress().getInitialValue(0));
        assertEquals(arrElements.get(1), v3.getAddress().getInitialValue(4));
        assertEquals(arrElements.get(2), v3.getAddress().getInitialValue(8));

        ScopedPointerVariable v4 = (ScopedPointerVariable) builder.getExpression("%v4");
        assertNotNull(v4);
        assertEquals(types.getMemorySizeInBytes(builder.getType("%struct")), v4.getAddress().getKnownSize());
        List<Expression> structElements = o4.getOperands();
        assertEquals(structElements.get(0), v4.getAddress().getInitialValue(0));
        assertEquals(structElements.get(1), v4.getAddress().getInitialValue(4));
        assertEquals(arrElements.get(0), v4.getAddress().getInitialValue(8));
        assertEquals(arrElements.get(1), v4.getAddress().getInitialValue(12));
        assertEquals(arrElements.get(2), v4.getAddress().getInitialValue(16));
    }

    @Test
    public void testRuntimeArray() {
        // given
        String input = """
                %v1 = OpVariable %v1_ptr Uniform
                %v2 = OpVariable %v2_ptr Uniform
                %v3 = OpVariable %v3_ptr Uniform
                """;

        IntegerType archType = types.getArchType();
        ArrayType arr1Type = types.getArrayType(archType, 2);
        ArrayType arr2Type = types.getArrayType(arr1Type, 3);
        AggregateType aggType = types.getAggregateType(List.of(archType, arr1Type));

        Expression i1 = expressions.makeValue(1, archType);
        Expression i2 = expressions.makeValue(2, archType);
        Expression i3 = expressions.makeValue(3, archType);
        Expression i4 = expressions.makeValue(4, archType);
        Expression i5 = expressions.makeValue(5, archType);
        Expression i6 = expressions.makeValue(6, archType);

        Expression a1 = expressions.makeArray(arr1Type, List.of(i1, i2));
        Expression a2 = expressions.makeArray(arr1Type, List.of(i3, i4));
        Expression a3 = expressions.makeArray(arr1Type, List.of(i5, i6));

        Expression a3a = expressions.makeArray(arr2Type, List.of(a1, a2, a3));
        Expression s = expressions.makeConstruct(aggType, List.of(i1, a1));

        builder = new MockProgramBuilder();
        builder.addInput("%v1", a1);
        builder.addInput("%v2", a3a);
        builder.addInput("%v3", s);

        IntegerType iType = builder.mockIntType("%int", 32);
        builder.mockVectorType("%ra", "%int", -1);
        builder.mockVectorType("%v3ra", "%ra", 3);
        builder.mockAggregateType("%s1i1ra", "%int", "%ra");

        builder.mockPtrType("%v1_ptr", "%ra", "Uniform");
        builder.mockPtrType("%v2_ptr", "%v3ra", "Uniform");
        builder.mockPtrType("%v3_ptr", "%s1i1ra", "Uniform");

        // when
        parse(input);

        // then
        Expression o1 = expressions.makeValue(1, iType);
        Expression o2 = expressions.makeValue(2, iType);
        Expression o3 = expressions.makeValue(3, iType);
        Expression o4 = expressions.makeValue(4, iType);
        Expression o5 = expressions.makeValue(5, iType);
        Expression o6 = expressions.makeValue(6, iType);

        Type ot1 = types.getArrayType(iType, 2);
        Type ot2 = types.getArrayType(ot1, 3);
        Type ot3 = types.getAggregateType(List.of(iType, ot1));

        ScopedPointerVariable v1 = (ScopedPointerVariable) builder.getExpression("%v1");
        assertEquals(types.getMemorySizeInBytes(ot1), v1.getAddress().getKnownSize());
        assertEquals(o1, v1.getAddress().getInitialValue(0));
        assertEquals(o2, v1.getAddress().getInitialValue(4));

        ScopedPointerVariable v2 = (ScopedPointerVariable) builder.getExpression("%v2");
        assertEquals(types.getMemorySizeInBytes(ot2), v2.getAddress().getKnownSize());
        assertEquals(o1, v2.getAddress().getInitialValue(0));
        assertEquals(o2, v2.getAddress().getInitialValue(4));
        assertEquals(o3, v2.getAddress().getInitialValue(8));
        assertEquals(o4, v2.getAddress().getInitialValue(12));
        assertEquals(o5, v2.getAddress().getInitialValue(16));
        assertEquals(o6, v2.getAddress().getInitialValue(20));

        ScopedPointerVariable v3 = (ScopedPointerVariable) builder.getExpression("%v3");
        assertEquals(types.getMemorySizeInBytes(ot3), v3.getAddress().getKnownSize());
        assertEquals(o1, v3.getAddress().getInitialValue(0));
        assertEquals(o1, v3.getAddress().getInitialValue(4));
        assertEquals(o2, v3.getAddress().getInitialValue(8));
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
        ScopedPointerVariable v = (ScopedPointerVariable) builder.getExpression("%v");
        assertNotNull(v);
        assertEquals(types.getMemorySizeInBytes(arr.getType()), v.getAddress().getKnownSize());
        assertEquals(arr.getOperands().get(0), v.getAddress().getInitialValue(0));
        assertEquals(arr.getOperands().get(1), v.getAddress().getInitialValue(4));
    }

    @Test
    public void testReusingRuntimeArrayType() {
        // given
        String input = """
                %v1 = OpVariable %v1_ptr Uniform
                %v2 = OpVariable %v2_ptr Uniform
                """;

        IntegerType archType = types.getArchType();
        ArrayType arr1Type = types.getArrayType(archType, 2);
        ArrayType arr2Type = types.getArrayType(archType, 3);
        Expression i1 = expressions.makeValue(1, archType);
        Expression i2 = expressions.makeValue(2, archType);
        Expression i3 = expressions.makeValue(3, archType);

        Expression a1 = expressions.makeArray(arr1Type, List.of(i1, i2));
        Expression a2 = expressions.makeArray(arr2Type, List.of(i1, i2, i3));

        builder = new MockProgramBuilder();
        builder.addInput("%v1", a1);
        builder.addInput("%v2", a2);

        builder.mockIntType("%int", 64);
        builder.mockVectorType("%ra", "%int", -1);
        builder.mockPtrType("%v1_ptr", "%ra", "Uniform");
        builder.mockPtrType("%v2_ptr", "%ra", "Uniform");

        // when
        parse(input);

        // then
        ScopedPointerVariable v1 = (ScopedPointerVariable) builder.getExpression("%v1");
        assertNotNull(v1);
        assertEquals(types.getMemorySizeInBytes(a1.getType()), v1.getAddress().getKnownSize());
        assertEquals(i1, v1.getAddress().getInitialValue(0));
        assertEquals(i2, v1.getAddress().getInitialValue(8));

        ScopedPointerVariable v2 = (ScopedPointerVariable) builder.getExpression("%v2");
        assertNotNull(v2);
        assertEquals(types.getMemorySizeInBytes(a2.getType()), v2.getAddress().getKnownSize());
        assertEquals(i1, v2.getAddress().getInitialValue(0));
        assertEquals(i2, v2.getAddress().getInitialValue(8));
        assertEquals(i3, v2.getAddress().getInitialValue(16));
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
    public void testVariableMismatchingStorageClass() {
        // given
        String input = "%v = OpVariable %int_ptr Workgroup";
        builder.mockIntType("%int", 64);
        builder.mockPtrType("%int_ptr", "%int", "Uniform");

        try {
            // when
            parse(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Storage class of variable '%v' " +
                    "does not match the pointer storage class", e.getMessage());
        }
    }

    @Test
    public void testVariableIllegalStorageClass() {
        // given
        String input = "%v = OpVariable %int_ptr Generic";
        builder.mockIntType("%int", 64);
        builder.mockPtrType("%int_ptr", "%int", "Generic");

        try {
            // when
            parse(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Variable '%v' has illegal storage class 'Generic'", e.getMessage());
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

        IntegerType archType = types.getArchType();
        ArrayType arrayType = types.getArrayType(archType, 2);
        Expression i1 = expressions.makeValue(1, archType);
        Expression i2 = expressions.makeValue(2, archType);
        Expression a = expressions.makeArray(arrayType, List.of(i1, i2));

        builder = new MockProgramBuilder();
        builder.addInput("%v", a);

        builder.mockIntType("%int", 32);
        builder.mockVectorType("%v2i", "%int", 2);
        builder.mockPtrType("%i_ptr", "%int", "Uniform");

        try {
            // when
            parse(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Mismatching value type for variable '%v', " +
                    "expected 'bv32' but received '[2 x bv64]'", e.getMessage());
        }
    }

    @Test
    public void testMismatchingValueTypeInNestedArray() {
        // given
        String input = "%v = OpVariable %arr2int_ptr Uniform %const";

        builder.mockBoolType("%bool");
        ArrayType a1Type = builder.mockVectorType("%arr1bool", "%bool", 2);
        ArrayType a2Type = builder.mockVectorType("%arr2bool", "%arr1bool", 2);

        builder.mockIntType("%int", 32);
        builder.mockVectorType("%arr1int", "%int", 2);
        builder.mockVectorType("%arr2int", "%arr1int", 2);

        builder.mockPtrType("%arr2int_ptr", "%arr2int", "Uniform");

        Expression bool = expressions.makeTrue();
        Expression arr1 = expressions.makeArray(a1Type, List.of(bool, bool));
        Expression arr2 = expressions.makeArray(a2Type, List.of(arr1, arr1));

        builder.addExpression("%const", arr2);

        try {
            // when
            parse(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Mismatching value type for variable '%v', " +
                    "expected '[2 x [2 x bv32]]' but received '[2 x [2 x bool]]'", e.getMessage());
        }
    }

    @Test
    public void testMismatchingValueTypeInNestedStruct() {
        // given
        String input = "%v = OpVariable %struct2_ptr Uniform %const";

        BooleanType boolType = builder.mockBoolType("%bool");
        builder.mockIntType("%int16", 16);
        IntegerType i32Type = builder.mockIntType("%int32", 32);
        AggregateType a1Type = types.getAggregateType(List.of(boolType, i32Type));
        AggregateType a2Type = types.getAggregateType(List.of(boolType, a1Type));

        builder.mockAggregateType("%struct1", "%bool", "%int16");
        builder.mockAggregateType("%struct2", "%bool", "%struct1");

        builder.mockPtrType("%struct2_ptr", "%struct2", "Uniform");

        Expression bool = expressions.makeTrue();
        Expression int32 = expressions.makeValue(1, i32Type);
        Expression struct1 = expressions.makeConstruct(a1Type, List.of(bool, int32));
        Expression struct2 = expressions.makeConstruct(a2Type, List.of(bool, struct1));

        builder.addExpression("%const", struct2);

        try {
            // when
            parse(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Mismatching value type for variable '%v', " +
                    "expected '{ 0: bool, 2: { 0: bool, 2: bv16 } }' " +
                    "but received '{ 0: bool, 4: { 0: bool, 4: bv32 } }'",
                    e.getMessage());
        }
    }

    @Test
    public void testInputForInitializedVariable() {
        // given
        String input = "%v = OpVariable %i_ptr Uniform %i_const";

        IntegerType archType = types.getArchType();
        Expression v = expressions.makeValue(2, archType);

        builder = new MockProgramBuilder();
        builder.addInput("%v", v);
        builder.mockIntType("%int", 32);
        builder.mockPtrType("%i_ptr", "%int", "Uniform");
        builder.mockConstant("%i_const", "%int", 1);

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
                %variable = OpVariable %v3_ptr Uniform %a3
                %element = OpAccessChain %i_ptr %variable %1 %0 %1
                """;

        builder.mockIntType("%int", 32);
        builder.mockVectorType("%v1", "%int", 2);
        builder.mockVectorType("%v2", "%v1", 2);
        builder.mockVectorType("%v3", "%v2", 2);
        builder.mockPtrType("%v3_ptr", "%v3", "Uniform");
        builder.mockPtrType("%i_ptr", "%int", "Uniform");

        Expression i0 = builder.mockConstant("%0", "%int", 0);
        Expression i1 = builder.mockConstant("%1", "%int", 1);
        builder.mockConstant("%a1", "%v1", List.of("%1", "%0"));
        builder.mockConstant("%a2", "%v2", List.of("%a1", "%a1"));
        builder.mockConstant("%a3", "%v3", List.of("%a2", "%a2"));

        // when
        parse(input);

        // then
        ScopedPointer pointer = (ScopedPointer) builder.getExpression("%element");
        assertEquals(builder.getType("%i_ptr"), pointer.getType());

        GEPExpr gep = (GEPExpr) pointer.getAddress();
        assertEquals(builder.getExpression("%variable"), gep.getBase());
        assertEquals(builder.getType("%v3_ptr"), gep.getType());
        assertEquals(builder.getType("%v3"), gep.getIndexingType());
        assertEquals(List.of(i0, i1, i0, i1), gep.getOffsets());
    }

    @Test
    public void testAccessChainStruct() {
        // given
        String input = """
                %variable = OpVariable %agg2_ptr Uniform %s2
                %element = OpAccessChain %i32_ptr %variable %4 %2
                """;

        builder.mockBoolType("%bool");
        builder.mockIntType("%int16", 16);
        builder.mockIntType("%int32", 32);
        builder.mockIntType("%int64", 64);
        builder.mockAggregateType("%agg1", "%bool", "%int16", "%int32", "%int64");
        builder.mockAggregateType("%agg2", "%bool", "%int16", "%int32", "%int64", "%agg1");
        builder.mockPtrType("%i32_ptr", "%int32", "Uniform");
        builder.mockPtrType("%agg2_ptr", "%agg2", "Uniform");

        builder.mockConstant("%false", "%bool", false);
        builder.mockConstant("%int_1", "%int16", 1);
        builder.mockConstant("%int_11", "%int32", 11);
        builder.mockConstant("%int_111", "%int64", 111);
        builder.mockConstant("%s1", "%agg1", List.of("%false", "%int_1", "%int_11", "%int_111"));
        builder.mockConstant("%s2", "%agg2", List.of("%false", "%int_1", "%int_11", "%int_111", "%s1"));

        Expression i0 = builder.mockConstant("%0", "%int32", 0);
        Expression i2 = builder.mockConstant("%2", "%int32", 2);
        Expression i4 = builder.mockConstant("%4", "%int32", 4);

        // when
        parse(input);

        // then
        ScopedPointer pointer = (ScopedPointer) builder.getExpression("%element");
        assertEquals(builder.getType("%i32_ptr"), pointer.getType());

        GEPExpr gep = (GEPExpr) pointer.getAddress();
        assertEquals(builder.getExpression("%variable"), gep.getBase());
        assertEquals(builder.getType("%agg2_ptr"), gep.getType());
        assertEquals(builder.getType("%agg2"), gep.getIndexingType());
        assertEquals(List.of(i0, i4, i2), gep.getOffsets());
    }

    @Test
    public void testAccessChainArrayRegister() {
        // given
        String input = """
                %variable = OpVariable %v2i_ptr Uniform %const
                %element = OpAccessChain %i_ptr %variable %register
                """;

        builder.mockIntType("%int", 32);
        builder.mockVectorType("%v2i", "%int", 2);
        builder.mockPtrType("%v2i_ptr", "%v2i", "Uniform");
        builder.mockPtrType("%i_ptr", "%int", "Uniform");

        Expression i0 = builder.mockConstant("%i0", "%int", 0);
        Expression i1 = builder.mockConstant("%i1", "%int", 1);
        Expression i2 = builder.mockConstant("%i2", "%int", 2);
        builder.mockConstant("%const", "%v2i", List.of(i1, i2));

        // when
        builder.mockFunctionStart(true);
        builder.addExpression("%register", builder.addRegister("%register", "%int"));
        new MockSpirvParser(input).spv().accept(new VisitorOpsMemory(builder));

        // then
        ScopedPointer pointer = (ScopedPointer) builder.getExpression("%element");
        assertEquals(builder.getType("%i_ptr"), pointer.getType());

        GEPExpr gep = (GEPExpr) pointer.getAddress();
        assertEquals(builder.getExpression("%variable"), gep.getBase());
        assertEquals(builder.getType("%v2i_ptr"), gep.getType());
        assertEquals(builder.getType("%v2i"), gep.getIndexingType());
        assertEquals(List.of(i0, builder.getExpression("%register")), gep.getOffsets());
    }

    @Test
    public void testAccessChainStructureRegister() {
        // given
        String input = """
                %variable = OpVariable %agg_ptr Uniform %const
                %element = OpAccessChain %i16_ptr %variable %register
                """;

        builder.mockIntType("%int16", 16);
        builder.mockIntType("%int32", 32);
        builder.mockAggregateType("%agg", "%int16", "%int32");
        builder.mockPtrType("%i16_ptr", "%int16", "Uniform");
        builder.mockPtrType("%agg_ptr", "%agg", "Uniform");

        builder.mockConstant("%i1", "%int16", 1);
        builder.mockConstant("%i2", "%int32", 2);
        builder.mockConstant("%const", "%agg", List.of("%i1", "%i2"));

        builder.mockFunctionStart(true);
        builder.addExpression("%register", builder.addRegister("%register", "%int32"));
        VisitorOpsMemory visitor = new VisitorOpsMemory(builder);
        SpirvParser.SpvContext ctx = new MockSpirvParser(input).spv();

        try {
            // when
            ctx.accept(visitor);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Index of a struct member is non-constant for variable '%variable[-1]'",
                    e.getMessage());
        }
    }

    @Test
    public void testPtrAccessChainPointer() {
        // given
        String input = """
                %variable = OpVariable %i_ptr Workgroup
                %element = OpPtrAccessChain %i_ptr %variable %1
                """;

        builder.mockIntType("%int", 32);
        builder.mockPtrType("%i_ptr", "%int", "Workgroup");
        Expression i1 = builder.mockConstant("%1", "%i_ptr", 1);

        // when
        parse(input);

        // then
        ScopedPointer pointer = (ScopedPointer) builder.getExpression("%element");
        assertEquals(builder.getType("%i_ptr"), pointer.getType());

        GEPExpr gep = (GEPExpr) pointer.getAddress();
        assertEquals(builder.getExpression("%variable"), gep.getBase());
        assertEquals(builder.getType("%i_ptr"), gep.getType());
        assertEquals(builder.getType("%int"), gep.getIndexingType());
        assertEquals(List.of(i1), gep.getOffsets());
    }

    @Test
    public void testPtrAccessChainArray() {
        // given
        String input = """
                %variable = OpVariable %v2_ptr Workgroup
                %element = OpPtrAccessChain %i_ptr %variable %1 %2 %3
                """;

        builder.mockIntType("%int", 32);
        builder.mockVectorType("%v1", "%int", 4);
        builder.mockVectorType("%v2", "%v1", 3);
        builder.mockPtrType("%v2_ptr", "%v2", "Workgroup");
        builder.mockPtrType("%i_ptr", "%int", "Workgroup");


        Expression i1 = builder.mockConstant("%1", "%i_ptr", 1);
        Expression i2 = builder.mockConstant("%2", "%i_ptr", 2);
        Expression i3 = builder.mockConstant("%3", "%i_ptr", 3);

        // when
        parse(input);

        // then
        ScopedPointer pointer = (ScopedPointer) builder.getExpression("%element");
        assertEquals(builder.getType("%i_ptr"), pointer.getType());

        GEPExpr gep = (GEPExpr) pointer.getAddress();
        assertEquals(builder.getExpression("%variable"), gep.getBase());
        assertEquals(builder.getType("%v2_ptr"), gep.getType());
        assertEquals(builder.getType("%v2"), gep.getIndexingType());
        assertEquals(List.of(i1, i2, i3), gep.getOffsets());
    }

    @Test
    public void testAccessChainWrongDepth() {
        // given
        String input = """
                %variable = OpVariable %v2i_ptr Uniform %const
                %element = OpAccessChain %i_ptr %variable %0 %0
                """;

        builder.mockIntType("%int", 32);
        builder.mockVectorType("%v2i", "%int", 2);
        builder.mockPtrType("%i_ptr", "%int", "Uniform");
        builder.mockPtrType("%v2i_ptr", "%v2i", "Uniform");

        builder.mockConstant("%0", "%int", 0);
        builder.mockConstant("%1", "%int", 1);
        builder.mockConstant("%2", "%int", 2);
        builder.mockConstant("%const", "%v2i", List.of("%1", "%2"));

        try {
            // when
            parse(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Index is too deep for variable '%variable[0][0]'", e.getMessage());
        }
    }

    @Test
    public void testAccessChainMismatchingTypeArray() {
        // given
        String input = """
                %variable = OpVariable %v2i_ptr Uniform %const
                %element = OpAccessChain %i16_ptr %variable %0
                """;

        builder.mockIntType("%int32", 32);
        builder.mockVectorType("%v2i", "%int32", 2);
        builder.mockPtrType("%v2i_ptr", "%v2i", "Uniform");
        builder.mockIntType("%int16", 16);
        builder.mockPtrType("%i16_ptr", "%int16", "Uniform");

        builder.mockConstant("%0", "%int32", 0);
        builder.mockConstant("%1", "%int32", 1);
        builder.mockConstant("%2", "%int32", 2);
        builder.mockConstant("%const", "%v2i", List.of("%1", "%2"));

        try {
            // when
            parse(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Invalid result type in access chain '%element', " +
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

        builder.mockIntType("%int16", 16);
        builder.mockIntType("%int32", 32);
        builder.mockAggregateType("%agg", "%int16", "%int32");
        builder.mockPtrType("%i16_ptr", "%int16", "Uniform");
        builder.mockPtrType("%agg_ptr", "%agg", "Uniform");

        builder.mockConstant("%1", "%int16", 1);
        builder.mockConstant("%2", "%int32", 2);
        builder.mockConstant("%const", "%agg", List.of("%1", "%2"));

        try {
            // when
            parse(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Invalid result type in access chain '%element', " +
                    "expected 'bv16' but received 'bv32'", e.getMessage());
        }
    }

    private Event getLastEvent() {
        List<Event> events = builder.getCurrentFunction().getEvents();
        if (!events.isEmpty()) {
            return events.get(events.size() - 1);
        }
        return null;
    }

    private void parse(String input) {
        builder.mockFunctionStart(true);
        new MockSpirvParser(input).spv().accept(new VisitorOpsMemory(builder));
    }
}
