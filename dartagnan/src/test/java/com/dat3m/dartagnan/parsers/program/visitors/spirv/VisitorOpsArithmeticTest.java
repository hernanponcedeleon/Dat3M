package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.IExprUn;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.expression.op.IOpUn;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilderSpv;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import org.junit.Test;

import java.util.List;

import static com.dat3m.dartagnan.expression.op.IOpBin.*;
import static com.dat3m.dartagnan.expression.op.IOpUn.MINUS;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class VisitorOpsArithmeticTest {

    @Test
    public void testOpsIntegerUn() {
        doTestOpsIntegerUn("OpSNegate", MINUS, 0);
        doTestOpsIntegerUn("OpSNegate", MINUS, 1);
        doTestOpsIntegerUn("OpSNegate", MINUS, -2);
    }

    private void doTestOpsIntegerUn(String name, IOpUn op, int value) {
        // given
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
        builder.mockIntType("%int", 64);
        builder.mockConstant("%value", "%int", value);
        String input = String.format("%%expr = %s %%int %%value", name);

        // when
        IExprUn expr = (IExprUn) visit(builder, input);

        // then
        assertEquals(builder.getExpression("%expr"), expr);
        assertEquals(builder.getExpression("%value"), expr.getInner());
        assertEquals(op, expr.getOp());
    }

    @Test
    public void testOpsIntegerBin() {
        doTestOpsIntegerBin("OpIAdd", ADD, 1, 2);
        doTestOpsIntegerBin("OpISub", SUB, 2, 1);
        doTestOpsIntegerBin("OpIMul", MUL, 2, 3);
        doTestOpsIntegerBin("OpUDiv", UDIV, 4, 2);
        doTestOpsIntegerBin("OpSDiv", DIV, 4, -2);
    }

    private void doTestOpsIntegerBin(String name, IOpBin op, int v1, int v2) {
        // given
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
        builder.mockIntType("%int", 64);
        builder.mockConstant("%v1", "%int", v1);
        builder.mockConstant("%v2", "%int", v2);
        String input = String.format("%%expr = %s %%int %%v1 %%v2", name);

        // when
        IExprBin expr = (IExprBin) visit(builder, input);

        // then
        assertEquals(builder.getExpression("%expr"), expr);
        assertEquals(builder.getExpression("%v1"), expr.getLHS());
        assertEquals(builder.getExpression("%v2"), expr.getRHS());
        assertEquals(op, expr.getOp());
    }

    @Test
    public void testOnUnMismatchingResultType() {
        // given
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
        builder.mockIntType("%int32", 32);
        builder.mockIntType("%int64", 64);
        builder.mockConstant("%value", "%int32", -1);
        String input = "%expr = OpSNegate %int64 %value";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal definition for '%expr', " +
                            "types do not match: '%value' is 'bv32' and '%int64' is 'bv64'",
                    e.getMessage());
        }
    }

    @Test
    public void testOnBinMismatchingResultType() {
        // given
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
        builder.mockIntType("%int32", 32);
        builder.mockIntType("%int64", 64);
        builder.mockConstant("%v1", "%int32", 1);
        builder.mockConstant("%v2", "%int32", 2);
        String input = "%expr = OpIAdd %int64 %v1 %v2";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal definition for '%expr', " +
                    "types do not match: '%v1' is 'bv32', '%v2' is 'bv32' " +
                    "and '%int64' is 'bv64'", e.getMessage());
        }
    }

    @Test
    public void testMismatchingOperandTypes() {
        // given
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
        builder.mockIntType("%int32", 32);
        builder.mockIntType("%int64", 64);
        builder.mockConstant("%v1", "%int32", 1);
        builder.mockConstant("%v2", "%int64", 2);
        String input = "%expr = OpIAdd %int32 %v1 %v2";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal definition for '%expr', " +
                    "types do not match: '%v1' is 'bv32', '%v2' is 'bv64' " +
                    "and '%int32' is 'bv32'", e.getMessage());
        }
    }

    @Test
    public void testUnsupportedResultType() {
        // given
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
        builder.mockIntType("%int", 64);
        builder.mockVectorType("%vector", "%int", 4);
        builder.mockConstant("%v1", "%vector", List.of(1, 2, 3, 4));
        builder.mockConstant("%v2", "%vector", List.of(5, 6, 7, 8));
        String input = "%expr = OpIAdd %vector %v1 %v2";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Unsupported result type for '%expr', " +
                    "vector types are not supported", e.getMessage());
        }
    }

    @Test
    public void testIllegalResultType() {
        // given
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 64);
        builder.mockConstant("%v1", "%int", 1);
        builder.mockConstant("%v2", "%int", 2);
        String input = "%expr = OpIAdd %bool %v1 %v2";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal result type for '%expr'", e.getMessage());
        }
    }

    private Expression visit(ProgramBuilderSpv builder, String input) {
        return new MockSpirvParser(input).op().accept(new VisitorOpsArithmetic(builder));
    }
}
