package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.floats.FloatSizeCast;
import com.dat3m.dartagnan.expression.floats.IntToFloatCast;
import com.dat3m.dartagnan.expression.integers.FloatToIntCast;
import com.dat3m.dartagnan.expression.integers.IntSizeCast;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import com.dat3m.dartagnan.program.memory.ScopedPointer;
import com.dat3m.dartagnan.program.event.core.Local;
import org.junit.Test;

import java.util.List;

import static org.junit.Assert.*;

public class VisitorOpsConversionTest {
    private final MockProgramBuilder builder = new MockProgramBuilder();

    @Test
    public void testOpBitcastValidPointerToPointer() {
        // given
        String input = "%value2 = OpBitcast %_ptr_Function_uchar %value1";
        builder.mockIntType("%uint", 32);
        builder.mockIntType("%uchar", 8);
        builder.mockPtrType("%_ptr_Function_uint", "%uint", "Function");
        builder.mockPtrType("%_ptr_Function_uchar", "%uchar", "Function");
        builder.mockVariable("%value1", "%_ptr_Function_uint");
        builder.mockFunctionStart(true);

        // when
        visit(input);

        // then
        Expression reg = builder.getExpression("%value2");
        assertEquals(builder.getType("%_ptr_Function_uchar"), reg.getType());
    }

    @Test
    public void testOpBitcastValidScalarToScalar() {
        // given
        String input = "%value2 = OpBitcast %uchar %value1";
        builder.mockIntType("%uint", 32);
        builder.mockIntType("%uchar", 8);
        builder.mockConstant("%value1", "%uint", 1);
        builder.mockFunctionStart(true);

        // when
        visit(input);

        // then
        Expression reg = builder.getExpression("%value2");
        assertEquals(builder.getType("%uchar"), reg.getType());
    }

    @Test
    public void testOpBitcastScalarToPointer() {
        // given
        String input = "%value2 = OpBitcast %_ptr_Function_uint %value1";
        builder.mockIntType("%uint", 32);
        builder.mockPtrType("%_ptr_Function_uint", "%uint", "Function");
        builder.mockConstant("%value1", "%uint", 1);
        builder.mockFunctionStart(true);

        // when
        visit(input);

        // then
        Expression reg = builder.getExpression("%value2");
        assertEquals(builder.getType("%_ptr_Function_uint"), reg.getType());
    }

    @Test
    public void testOpBitcastStorageClassMismatch() {
        // given
        String input = "%value2 = OpBitcast %_ptr_Workgroup_uint %value1";
        builder.mockIntType("%uint", 32);
        builder.mockPtrType("%_ptr_Function_uint", "%uint", "Function");
        builder.mockPtrType("%_ptr_Workgroup_uint", "%uint", "Workgroup");
        builder.mockVariable("%value1", "%_ptr_Function_uint");
        builder.mockFunctionStart(true);

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Storage class mismatch in OpBitcast between '%_ptr_Workgroup_uint' and '%value1' for id '%value2'", e.getMessage());
        }
    }

    @Test
    public void testOpUConvertValidConstant() {
        // given
        String input = "%value2 = OpUConvert %uint64 %value1";
        builder.mockIntType("%uint", 32);
        builder.mockIntType("%uint64", 64);
        builder.mockConstant("%value1", "%uint", 1);
        builder.mockFunctionStart(true);

        // when
        visit(input);

        // then
        Expression reg = builder.getExpression("%value2");
        assertEquals(builder.getType("%uint64"), reg.getType());
    }

    @Test
    public void testOpSConvertValidConstant() {
        // given
        String input = "%value2 = OpSConvert %uint64 %value1";
        builder.mockIntType("%uint", 32);
        builder.mockIntType("%uint64", 64);
        builder.mockConstant("%value1", "%uint", 1);
        builder.mockFunctionStart(true);

        // when
        visit(input);

        // then
        Expression reg = builder.getExpression("%value2");
        assertEquals(builder.getType("%uint64"), reg.getType());
    }

    @Test
    public void testOpUConvertValidRegister() {
        // given
        String input = "%value2 = OpUConvert %uint64 %r1";
        builder.mockIntType("%uint", 32);
        builder.mockIntType("%uint64", 64);
        builder.mockFunctionStart(true);
        builder.addRegister("%r1", "%uint");
        builder.addExpression("%r1", builder.mockConstant("%value1", "%uint", 99));

        // when
        visit(input);

        // then
        Expression reg = builder.getExpression("%value2");
        assertEquals(builder.getType("%uint64"), reg.getType());
    }

    @Test
    public void testOpUConvertInvalidType() {
        // given
        String input = "%value2 = OpUConvert %uint2 %value1";
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%uint2", "%uint", 2);
        builder.mockConstant("%value1", "%uint", 1);
        builder.mockFunctionStart(true);

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal conversion for '%value2' from 'bv32' to '[2 x bv32]'", e.getMessage());
        }
    }

    @Test
    public void testOpUConvertInvalidOperand() {
        // given
        String input = "%value2 = OpUConvert %uint %value1";
        builder.mockIntType("%uint", 32);
        builder.mockVectorType("%uint2", "%uint", 2);
        builder.mockConstant("%value1", "%uint2", List.of(1, 2));

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal conversion for '%value2' from '[2 x bv32]' to 'bv32'", e.getMessage());
        }
    }

    @Test
    public void testOpConvertPtrToU() {
        // given
        String input = "%value = OpConvertPtrToU %uint %pointer";
        builder.mockIntType("%uint", 32);
        builder.mockPtrType("%pointerType", "%uint", "CrossWorkgroup");
        builder.mockConstant("%pointer", "%pointerType", 0);
        builder.mockFunctionStart(true);

        // when
        visit(input);

        // then
        Expression value = builder.getExpression("%value");
        assertEquals(builder.getType("%uint"), value.getType());
    }

    @Test
    public void testOpConvertPtrToUDifferentSize() {
        // given
        String input = """
            %value16 = OpConvertPtrToU %uint16 %pointer
            %value64 = OpConvertPtrToU %uint64 %pointer
            """;
        builder.mockIntType("%uint16", 16);
        builder.mockIntType("%uint32", 32);
        builder.mockIntType("%uint64", 64);
        builder.mockPtrType("%pointerType", "%uint32", "CrossWorkgroup");
        builder.mockConstant("%pointer", "%pointerType", 0);
        builder.mockFunctionStart(true);

        // when
        visit(input);

        // then
        Expression value16 = builder.getExpression("%value16");
        assertEquals(builder.getType("%uint16"), value16.getType());
        Expression value64 = builder.getExpression("%value64");
        assertEquals(builder.getType("%uint64"), value64.getType());
    }

    @Test
    public void testOpConvertPtrToUNonPointerArgument() {
        // given
        String input = "%value = OpConvertPtrToU %uint %nonPointer";
        builder.mockIntType("%uint", 32);
        builder.mockConstant("%nonPointer", "%uint", 0);

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal OpConvertPtrToU for '%value', " +
                    "attempt to apply conversion on a non-pointer type", e.getMessage());
        }
    }

    @Test
    public void testOpConvertPtrToUNonIntegerResultType() {
        // given
        String input = "%value = OpConvertPtrToU %bool %pointer";
        builder.mockBoolType("%bool");
        builder.mockPtrType("%pointerType", "%bool", "CrossWorkgroup");
        builder.mockConstant("%pointer", "%pointerType", 0);

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal OpConvertPtrToU for '%value', " +
                    "attempt to convent into a non-integer type", e.getMessage());
        }
    }

    @Test
    public void testOpConvertUToPtr() {
        // given
        String input = "%pointer = OpConvertUToPtr %pointerType %value";
        builder.mockIntType("%uint", 32);
        builder.mockPtrType("%pointerType", "%uint", "CrossWorkgroup");
        builder.mockConstant("%value", "%uint", 0);
        builder.mockFunctionStart(true);

        // when
        visit(input);

        // then
        Expression pointer = builder.getExpression("%pointer");
        assertEquals(builder.getType("%pointerType"), pointer.getType());
    }

    @Test
    public void testOpConvertUToPtrDifferentSize() {
        // given
        String input = """
            %pointer1 = OpConvertUToPtr %pointerType %value16
            %pointer2 = OpConvertUToPtr %pointerType %value64
            """;
        builder.mockIntType("%uint16", 16);
        builder.mockIntType("%uint32", 32);
        builder.mockIntType("%uint64", 64);
        builder.mockConstant("%value16", "%uint16", 0);
        builder.mockConstant("%value64", "%uint64", 0);
        builder.mockPtrType("%pointerType", "%uint32", "CrossWorkgroup");
        builder.mockFunctionStart(true);

        // when
        visit(input);

        // then
        Expression pointer1 = builder.getExpression("%pointer1");
        assertEquals(builder.getType("%pointerType"), pointer1.getType());
        Expression pointer2 = builder.getExpression("%pointer2");
        assertEquals(builder.getType("%pointerType"), pointer2.getType());
    }

    @Test
    public void testOpConvertUToPtrNonIntegerArgument() {
        // given
        String input = "%pointer = OpConvertUToPtr %pointerType %value";
        builder.mockBoolType("%bool");
        builder.mockPtrType("%pointerType", "%bool", "CrossWorkgroup");
        builder.mockConstant("%value", "%bool", false);

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal OpConvertUToPtr for '%pointer', " +
                    "attempt to apply conversion on a non-integer value", e.getMessage());
        }
    }

    @Test
    public void testOpConvertUToPtrNonPointerResultType() {
        // given
        String input = "%pointer = OpConvertUToPtr %uint %value";
        builder.mockIntType("%uint", 32);
        builder.mockConstant("%value", "%uint", 0);

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal OpConvertUToPtr for '%pointer', " +
                    "attempt to convent into a non-pointer type", e.getMessage());
        }
    }

    @Test
    public void testOpPtrCastToGeneric() {
        // given
        String input = "%newPointer = OpPtrCastToGeneric %newType %oldPointer";
        builder.mockIntType("%uint", 32);
        builder.mockPtrType("%oldType", "%uint", "CrossWorkgroup");
        builder.mockPtrType("%newType", "%uint", "Generic");
        builder.mockConstant("%oldPointer", "%oldType", 0);

        // when
        visit(input);

        // then
        ScopedPointer newPointer = (ScopedPointer) builder.getExpression("%newPointer");
        assertEquals(builder.getType("%newType"), newPointer.getType());
        assertEquals(builder.getExpression("%oldPointer"), newPointer.getAddress());
    }

    @Test
    public void testOpPtrCastToGenericDiffInnerTypes() {
        // given
        String input = "%newPointer = OpPtrCastToGeneric %newType %oldPointer";
        builder.mockIntType("%uint32", 32);
        builder.mockIntType("%uint64", 64);
        builder.mockPtrType("%oldType", "%uint32", "CrossWorkgroup");
        builder.mockPtrType("%newType", "%uint64", "Generic");
        builder.mockConstant("%oldPointer", "%oldType", 0);

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal OpPointerCastToGeneric for '%newPointer', " +
                    "result and original pointers point to different types", e.getMessage());
        }
    }

    @Test
    public void testOpPtrCastToGenericNonPointerArgument() {
        // given
        String input = "%newPointer = OpPtrCastToGeneric %newType %oldValue";
        builder.mockIntType("%uint", 32);
        builder.mockPtrType("%newType", "%uint", "Generic");
        builder.mockConstant("%oldValue", "%uint", 0);

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal OpPointerCastToGeneric for '%newPointer', " +
                    "attempt to apply cast to a non-pointer", e.getMessage());
        }
    }

    @Test
    public void testOpPtrCastToGenericNonPointerResultType() {
        // given
        String input = "%newPointer = OpPtrCastToGeneric %uint %oldPointer";
        builder.mockIntType("%uint", 32);
        builder.mockPtrType("%oldType", "%uint", "CrossWorkgroup");
        builder.mockConstant("%oldPointer", "%oldType", 0);

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal OpPointerCastToGeneric for '%newPointer', " +
                    "attempt to apply cast to a non-pointer", e.getMessage());
        }
    }

    @Test
    public void testOpPtrCastToGenericNonGenericResultType() {
        // given
        String input = "%newPointer = OpPtrCastToGeneric %newType %oldPointer";
        builder.mockIntType("%uint", 32);
        builder.mockPtrType("%oldType", "%uint", "CrossWorkgroup");
        builder.mockPtrType("%newType", "%uint", "Workgroup");
        builder.mockConstant("%oldPointer", "%oldType", 0);

        try {
            // when
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal OpPointerCastToGeneric for '%newPointer', " +
                    "attempt to cast into a non-generic pointer", e.getMessage());
        }
    }

    @Test
    public void testFloatToIntegerConversions() {
        builder.mockFloatType("%float", 32);
        builder.mockIntType("%int", 32);
        builder.mockConstant("%value", "%float", 1.5);
        builder.mockFunctionStart(true);

        visit("""
                %signed = OpConvertFToS %int %value
                %unsigned = OpConvertFToU %int %value
                """);

        FloatToIntCast signed = (FloatToIntCast) getLocal(0).getExpr();
        FloatToIntCast unsigned = (FloatToIntCast) getLocal(1).getExpr();
        assertTrue(signed.isSigned());
        assertFalse(unsigned.isSigned());
    }

    @Test
    public void testIntegerToFloatConversionsPreserveSignedness() {
        builder.mockIntType("%int", 32);
        builder.mockFloatType("%float", 32);
        builder.mockConstant("%value", "%int", -1);
        builder.mockFunctionStart(true);

        visit("""
                %signed = OpConvertSToF %float %value
                %unsigned = OpConvertUToF %float %value
                """);

        IntToFloatCast signed = (IntToFloatCast) getLocal(0).getExpr();
        IntToFloatCast unsigned = (IntToFloatCast) getLocal(1).getExpr();
        assertTrue(signed.isSigned());
        assertFalse(unsigned.isSigned());
    }

    @Test
    public void testFloatSizeConversion() {
        builder.mockFloatType("%float", 32);
        builder.mockFloatType("%double", 64);
        builder.mockConstant("%value", "%float", 1.5);
        builder.mockFunctionStart(true);

        visit("%converted = OpFConvert %double %value");

        FloatSizeCast cast = (FloatSizeCast) getLocal(0).getExpr();
        assertEquals(builder.getType("%float"), cast.getSourceType());
        assertEquals(builder.getType("%double"), cast.getTargetType());
    }

    @Test
    public void testVectorIntegerToFloatConversion() {
        builder.mockIntType("%int", 32);
        builder.mockFloatType("%float", 32);
        builder.mockVectorType("%intVector", "%int", 2);
        builder.mockVectorType("%floatVector", "%float", 2);
        builder.mockConstant("%value", "%intVector", List.of(1, 2));
        builder.mockFunctionStart(true);

        visit("%converted = OpConvertSToF %floatVector %value");

        ConstructExpr result = (ConstructExpr) getLocal(0).getExpr();
        assertEquals(2, result.getOperands().size());
        for (Expression element : result.getOperands()) {
            assertEquals(IntToFloatCast.class, element.getClass());
        }
    }

    @Test
    public void testFloatConversionRequiresCompatibleShapes() {
        builder.mockIntType("%int", 32);
        builder.mockFloatType("%float", 32);
        builder.mockVectorType("%vector", "%float", 2);
        builder.mockConstant("%value", "%int", 1);

        try {
            visit("%converted = OpConvertSToF %vector %value");
            fail("Should throw exception");
        } catch (ParsingException e) {
            assertEquals("Illegal conversion for '%converted' from 'bv32' to '[2 x float32]'", e.getMessage());
        }
    }

    @Test
    public void testVectorIntegerConversions() {
        builder.mockIntType("%int", 32);
        builder.mockIntType("%long", 64);
        builder.mockVectorType("%intVector", "%int", 2);
        builder.mockVectorType("%longVector", "%long", 2);
        builder.mockConstant("%value", "%intVector", List.of(1, 2));
        builder.mockFunctionStart(true);

        visit("""
                %signed = OpSConvert %longVector %value
                %unsigned = OpUConvert %longVector %value
                """);

        ConstructExpr signed = (ConstructExpr) getLocal(0).getExpr();
        ConstructExpr unsigned = (ConstructExpr) getLocal(1).getExpr();
        assertEquals(2, signed.getOperands().size());
        assertEquals(2, unsigned.getOperands().size());
        signed.getOperands().forEach(element -> {
            IntSizeCast cast = (IntSizeCast) element;
            assertEquals(builder.getType("%long"), cast.getType());
            assertTrue(cast.preservesSign());
        });
        unsigned.getOperands().forEach(element -> {
            IntSizeCast cast = (IntSizeCast) element;
            assertEquals(builder.getType("%long"), cast.getType());
            assertFalse(cast.preservesSign());
        });
    }

    private Local getLocal(int index) {
        return builder.getCurrentFunction().getEvents().stream()
                .filter(Local.class::isInstance)
                .map(Local.class::cast)
                .skip(index)
                .findFirst()
                .orElseThrow();
    }

    private void visit(String input) {
        new MockSpirvParser(input).spv().accept(new VisitorOpsConversion(builder));
    }
}
