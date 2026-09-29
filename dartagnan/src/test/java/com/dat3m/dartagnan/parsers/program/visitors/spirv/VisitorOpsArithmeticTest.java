package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntBinaryExpr;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.integers.IntUnaryExpr;
import com.dat3m.dartagnan.expression.integers.IntUnaryOp;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.floats.FloatBinaryExpr;
import com.dat3m.dartagnan.expression.floats.FloatBinaryOp;
import com.dat3m.dartagnan.expression.floats.FloatUnaryExpr;
import com.dat3m.dartagnan.expression.floats.FloatUnaryOp;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import com.dat3m.dartagnan.program.event.core.Local;
import org.junit.Test;

import java.util.List;

import static com.dat3m.dartagnan.expression.floats.FloatBinaryOp.*;
import static com.dat3m.dartagnan.expression.floats.FloatUnaryOp.NEG;
import static com.dat3m.dartagnan.expression.integers.IntBinaryOp.*;
import static com.dat3m.dartagnan.expression.integers.IntUnaryOp.MINUS;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class VisitorOpsArithmeticTest {

    @Test
    public void testOpsIntegerUn() {
        doTestOpsIntegerUn("OpSNegate", MINUS, 0);
        doTestOpsIntegerUn("OpSNegate", MINUS, 1);
        doTestOpsIntegerUn("OpSNegate", MINUS, -2);
    }

    private void doTestOpsIntegerUn(String name, IntUnaryOp op, int value) {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockIntType("%int", 64);
        builder.mockConstant("%value", "%int", value);
        String input = String.format("%%reg = %s %%int %%value", name);

        // when
        Local local = visit(builder, input);

        // then
        assertEquals(builder.getExpression("%reg"), local.getResultRegister());
        IntUnaryExpr expr = (IntUnaryExpr) local.getExpr();
        assertEquals(builder.getExpression("%value"), expr.getOperand());
        assertEquals(op, expr.getKind());
    }

    @Test
    public void testOpsIntegerBin() {
        doTestOpsIntegerBin("OpIAdd", ADD, 1, 2);
        doTestOpsIntegerBin("OpISub", SUB, 2, 1);
        doTestOpsIntegerBin("OpIMul", MUL, 2, 3);
        doTestOpsIntegerBin("OpUDiv", UDIV, 4, 2);
        doTestOpsIntegerBin("OpSDiv", DIV, 4, -2);
    }

    private void doTestOpsIntegerBin(String name, IntBinaryOp op, int v1, int v2) {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockIntType("%int", 64);
        builder.mockConstant("%v1", "%int", v1);
        builder.mockConstant("%v2", "%int", v2);
        String input = String.format("%%reg = %s %%int %%v1 %%v2", name);

        // when
        Local local = visit(builder, input);

        // then
        assertEquals(builder.getExpression("%reg"), local.getResultRegister());
        IntBinaryExpr expr = (IntBinaryExpr) local.getExpr();
        assertEquals(builder.getExpression("%v1"), expr.getLeft());
        assertEquals(builder.getExpression("%v2"), expr.getRight());
        assertEquals(op, expr.getKind());
    }

    @Test
    public void testOpsIntegerVectorBin() {
        doTestOpsIntegerVectorBin("OpIAdd", ADD);
        doTestOpsIntegerVectorBin("OpISub", SUB);
        doTestOpsIntegerVectorBin("OpIMul", MUL);
        doTestOpsIntegerVectorBin("OpUDiv", UDIV);
        doTestOpsIntegerVectorBin("OpSDiv", DIV);
    }

    private void doTestOpsIntegerVectorBin(String name, IntBinaryOp op) {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockIntType("%int", 64);
        builder.mockVectorType("%vector", "%int", 4);
        builder.mockConstant("%v1", "%vector", List.of(1, 2, 3, 4));
        builder.mockConstant("%v2", "%vector", List.of(5, 6, 7, 8));
        String input = String.format("%%reg = %s %%vector %%v1 %%v2", name);

        // when
        Local local = visit(builder, input);

        // then
        assertEquals(builder.getExpression("%reg"), local.getResultRegister());
        ConstructExpr expr = (ConstructExpr) local.getExpr();
        for (Expression operand : expr.getOperands()) {
            assertEquals(op, operand.getKind());
        }
    }

    @Test
    public void testOnIntegerUnMismatchingResultType() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockIntType("%int32", 32);
        builder.mockIntType("%int64", 64);
        builder.mockConstant("%value", "%int32", -1);
        String input = "%reg = OpSNegate %int64 %value";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal definition for '%reg', " +
                            "types do not match: '%value' is 'bv32' and '%int64' is 'bv64'",
                    e.getMessage());
        }
    }

    @Test
    public void testOnIntegerBinMismatchingResultType() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockIntType("%int32", 32);
        builder.mockIntType("%int64", 64);
        builder.mockConstant("%v1", "%int32", 1);
        builder.mockConstant("%v2", "%int32", 2);
        String input = "%reg = OpIAdd %int64 %v1 %v2";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal definition for '%reg', " +
                    "types do not match: '%v1' is 'bv32', '%v2' is 'bv32' " +
                    "and '%int64' is 'bv64'", e.getMessage());
        }
    }

    @Test
    public void testIntegerMismatchingOperandTypes() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockIntType("%int32", 32);
        builder.mockIntType("%int64", 64);
        builder.mockConstant("%v1", "%int32", 1);
        builder.mockConstant("%v2", "%int64", 2);
        String input = "%reg = OpIAdd %int32 %v1 %v2";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal definition for '%reg', " +
                    "types do not match: '%v1' is 'bv32', '%v2' is 'bv64' " +
                    "and '%int32' is 'bv32'", e.getMessage());
        }
    }

    @Test
    public void testIntegerIllegalResultType() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 64);
        builder.mockConstant("%v1", "%int", 1);
        builder.mockConstant("%v2", "%int", 2);
        String input = "%reg = OpIAdd %bool %v1 %v2";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal definition for '%reg', " +
                    "types do not match: '%v1' is 'bv64', '%v2' is 'bv64' " +
                    "and '%bool' is 'bool'", e.getMessage());
        }
    }

    @Test
    public void testOpsFloatUn() {
        doTestOpsFloatUn("OpFNegate", NEG, 0.0);
        doTestOpsFloatUn("OpFNegate", NEG, 1.5);
        doTestOpsFloatUn("OpFNegate", NEG, -2.0);
    }

    private void doTestOpsFloatUn(String name, FloatUnaryOp op, double value) {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockFloatType("%float", 32);
        builder.mockConstant("%value", "%float", value);
        String input = String.format("%%reg = %s %%float %%value", name);

        // when
        Local local = visit(builder, input);

        // then
        assertEquals(builder.getExpression("%reg"), local.getResultRegister());
        FloatUnaryExpr expr = (FloatUnaryExpr) local.getExpr();
        assertEquals(builder.getExpression("%value"), expr.getOperand());
        assertEquals(op, expr.getKind());
    }

    @Test
    public void testOpsFloatBin() {
        doTestOpsFloatBin("OpFAdd", FADD, 1.5, 2.0);
        doTestOpsFloatBin("OpFSub", FSUB, 2.0, 1.5);
        doTestOpsFloatBin("OpFMul", FMUL, 2.0, 3.0);
        doTestOpsFloatBin("OpFDiv", FDIV, 4.0, 2.0);
    }

    private void doTestOpsFloatBin(String name, FloatBinaryOp op, double v1, double v2) {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockFloatType("%float", 32);
        builder.mockConstant("%v1", "%float", v1);
        builder.mockConstant("%v2", "%float", v2);
        String input = String.format("%%reg = %s %%float %%v1 %%v2", name);

        // when
        Local local = visit(builder, input);

        // then
        assertEquals(builder.getExpression("%reg"), local.getResultRegister());
        FloatBinaryExpr expr = (FloatBinaryExpr) local.getExpr();
        assertEquals(op, expr.getKind());
        assertEquals(builder.getExpression("%v1"), expr.getLeft());
        assertEquals(builder.getExpression("%v2"), expr.getRight());
    }

    @Test
    public void testOpsFloatVectorUn() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockFloatType("%float", 32);
        builder.mockVectorType("%vector", "%float", 2);
        builder.mockConstant("%value", "%vector", List.of(1.0, 2.0));
        String input = "%reg = OpFNegate %vector %value";

        // when
        Local local = visit(builder, input);

        // then
        assertEquals(builder.getExpression("%reg"), local.getResultRegister());
        ConstructExpr expr = (ConstructExpr) local.getExpr();
        assertEquals(2, expr.getOperands().size());
        for (Expression operand : expr.getOperands()) {
            assertEquals(NEG, operand.getKind());
        }
    }

    @Test
    public void testOpsFloatVectorBin() {
        doTestOpsFloatVectorBin("OpFAdd", FADD);
        doTestOpsFloatVectorBin("OpFSub", FSUB);
        doTestOpsFloatVectorBin("OpFMul", FMUL);
        doTestOpsFloatVectorBin("OpFDiv", FDIV);
    }

    private void doTestOpsFloatVectorBin(String name, FloatBinaryOp op) {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockFloatType("%float", 32);
        builder.mockVectorType("%vector", "%float", 2);
        builder.mockConstant("%v1", "%vector", List.of(1.0, 2.0));
        builder.mockConstant("%v2", "%vector", List.of(3.0, 4.0));
        String input = String.format("%%reg = %s %%vector %%v1 %%v2", name);

        // when
        Local local = visit(builder, input);

        // then
        assertEquals(builder.getExpression("%reg"), local.getResultRegister());
        ConstructExpr expr = (ConstructExpr) local.getExpr();
        assertEquals(2, expr.getOperands().size());
        for (Expression operand : expr.getOperands()) {
            assertEquals(op, operand.getKind());
        }
    }

    @Test
    public void testOnFloatUnMismatchingResultType() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockFloatType("%float32", 32);
        builder.mockFloatType("%float64", 64);
        builder.mockConstant("%value", "%float32", -1.0);
        String input = "%reg = OpFNegate %float64 %value";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal floating-point definition for '%reg': result and operand types must match",
                    e.getMessage());
        }
    }

    @Test
    public void testOnFloatBinMismatchingResultType() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockFloatType("%float32", 32);
        builder.mockFloatType("%float64", 64);
        builder.mockConstant("%v1", "%float32", 1.0);
        builder.mockConstant("%v2", "%float32", 2.0);
        String input = "%reg = OpFAdd %float64 %v1 %v2";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal floating-point definition for '%reg': result and operand types must match",
                    e.getMessage());
        }
    }

    @Test
    public void testFloatMismatchingOperandTypes() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockFloatType("%float32", 32);
        builder.mockFloatType("%float64", 64);
        builder.mockConstant("%left", "%float32", 1.0);
        builder.mockConstant("%right", "%float64", 2.0);
        String input = "%reg = OpFAdd %float32 %left %right";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal floating-point definition for '%reg': result and operand types must match",
                    e.getMessage());
        }
    }

    @Test
    public void testFloatIllegalResultType() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockBoolType("%bool");
        builder.mockFloatType("%float", 32);
        builder.mockConstant("%v1", "%float", 1.0);
        builder.mockConstant("%v2", "%float", 2.0);
        String input = "%reg = OpFAdd %bool %v1 %v2";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal floating-point definition for '%reg': result and operand types must match",
                    e.getMessage());
        }
    }

    private Local visit(MockProgramBuilder builder, String input) {
        builder.mockFunctionStart(true);
        return (Local) new MockSpirvParser(input).op().accept(new VisitorOpsArithmetic(builder));
    }
}
