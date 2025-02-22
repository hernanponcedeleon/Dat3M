package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class VisitorOpsConversionTest {
    private MockProgramBuilder builder = new MockProgramBuilder();

    @Test
    public void opBitcastValidPointerToPointer() {
        builder.mockIntType("%uint", 32);
        builder.mockIntType("%uchar", 8);
        builder.mockPtrType("%_ptr_Function_uint", "%uint", "Function");
        builder.mockPtrType("%_ptr_Function_uchar", "%uchar", "Function");
        builder.mockVariable("%value1", "%_ptr_Function_uint");
        String input = "%value2 = OpBitcast %_ptr_Function_uchar %value1";

        visit(input);
        Expression reg = builder.getExpression("%value2");
        assertEquals(builder.getType("%_ptr_Function_uchar"), reg.getType());
    }

    @Test
    public void opBitcastValidScalarToScalar() {
        builder.mockIntType("%uint", 32);
        builder.mockIntType("%uchar", 8);
        builder.mockConstant("%value1", "%uint", 1);
        String input = "%value2 = OpBitcast %uchar %value1";

        visit(input);
        Expression reg = builder.getExpression("%value2");
        assertEquals(builder.getType("%uchar"), reg.getType());
    }

    @Test
    public void opBitcastScalarToPointer() {
        builder.mockIntType("%uint", 32);
        builder.mockPtrType("%_ptr_Function_uint", "%uint", "Function");
        builder.mockConstant("%value1", "%uint", 1);
        String input = "%value2 = OpBitcast %_ptr_Function_uint %value1";

        visit(input);
        Expression reg = builder.getExpression("%value2");
        assertEquals(builder.getType("%_ptr_Function_uint"), reg.getType());
    }

    @Test
    public void opBitcastStorageClassMismatch() {
        builder.mockIntType("%uint", 32);
        builder.mockPtrType("%_ptr_Function_uint", "%uint", "Function");
        builder.mockPtrType("%_ptr_Workgroup_uint", "%uint", "Workgroup");
        builder.mockVariable("%value1", "%_ptr_Function_uint");
        String input = "%value2 = OpBitcast %_ptr_Workgroup_uint %value1";

        try {
            visit(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            assertEquals("Storage class mismatch in OpBitcast between '%_ptr_Workgroup_uint' and '%value1' for id '%value2'", e.getMessage());
        }
    }

    @Test
    public void opConvertPtrToUValid() {
        builder.mockIntType("%uint", 32);
        builder.mockPtrType("%_ptr_Function_uint", "%uint", "Function");
        builder.mockVariable("%value1", "%_ptr_Function_uint");
        String input = "%value2 = OpConvertPtrToU %uint %value1";

        visit(input);
        Expression reg = builder.getExpression("%value2");
        assertEquals(builder.getType("%uint"), reg.getType());
    }

    private void visit(String input) {
        builder.mockFunctionStart(true);
        new MockSpirvParser(input).op().accept(new VisitorOpsConversion(builder));
    }
}
