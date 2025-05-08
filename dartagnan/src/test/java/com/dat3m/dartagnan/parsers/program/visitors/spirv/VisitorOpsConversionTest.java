package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import org.junit.Test;

import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class VisitorOpsConversionTest {
    private final MockProgramBuilder builder = new MockProgramBuilder();

    @Test
    public void opBitcastValidPointerToPointer() {
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
    public void opBitcastValidScalarToScalar() {
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
    public void opBitcastScalarToPointer() {
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
    public void opBitcastStorageClassMismatch() {
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
    public void opConvertPtrToUValid() {
        // given
        String input = "%value2 = OpConvertPtrToU %uint %value1";
        builder.mockIntType("%uint", 32);
        builder.mockPtrType("%_ptr_Function_uint", "%uint", "Function");
        builder.mockVariable("%value1", "%_ptr_Function_uint");
        builder.mockFunctionStart(true);

        // when
        visit(input);

        // then
        Expression reg = builder.getExpression("%value2");
        assertEquals(builder.getType("%uint"), reg.getType());
    }

    @Test
    public void opUConvertValidConstant() {
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
    public void opSConvertValidConstant() {
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
    public void opUConvertValidRegister() {
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
    public void opUConvertInvalidType() {
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
            assertEquals("Unsupported conversion to type '%uint2' for id '%value2'", e.getMessage());
        }
    }

    @Test
    public void opUConvertInvalidOperand() {
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
            assertEquals("Unsupported conversion to type '%uint' for id '%value2'", e.getMessage());
        }
    }

    private void visit(String input) {
        new MockSpirvParser(input).op().accept(new VisitorOpsConversion(builder));
    }
}
