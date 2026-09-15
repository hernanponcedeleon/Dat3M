package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.booleans.BoolBinaryExpr;
import com.dat3m.dartagnan.expression.booleans.BoolBinaryOp;
import com.dat3m.dartagnan.expression.booleans.BoolUnaryExpr;
import com.dat3m.dartagnan.expression.floats.FloatCmpExpr;
import com.dat3m.dartagnan.expression.floats.FloatCmpOp;
import com.dat3m.dartagnan.expression.integers.IntCmpExpr;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import com.dat3m.dartagnan.program.event.core.Local;
import org.junit.Test;

import java.util.List;

import static com.dat3m.dartagnan.expression.booleans.BoolBinaryOp.AND;
import static com.dat3m.dartagnan.expression.booleans.BoolBinaryOp.OR;
import static com.dat3m.dartagnan.expression.booleans.BoolUnaryOp.NOT;
import static com.dat3m.dartagnan.expression.integers.IntCmpOp.*;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class VisitorOpsLogicalTest {

    @Test
    public void testOpsLogicalUn() {
        doTestOpsLogicalUn(false);
        doTestOpsLogicalUn(true);
    }

    private void doTestOpsLogicalUn(boolean value) {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockBoolType("%bool");
        builder.mockConstant("%value", "%bool", value);
        String input = "%reg = OpLogicalNot %bool %value";

        // when
        Local local = visit(builder, input);
        BoolUnaryExpr expr = (BoolUnaryExpr) local.getExpr();

        // then
        assertEquals(builder.getExpression("%reg"), local.getResultRegister());
        assertEquals(builder.getExpression("%value"), expr.getOperand());
        assertEquals(NOT, expr.getKind());
    }

    @Test
    public void testOpSelect() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 64);
        builder.mockConstant("%cond", "%bool", true);
        builder.mockConstant("%v1", "%int", 123);
        builder.mockConstant("%v2", "%int", 456);
        String input = "%reg = OpSelect %int %cond %v1 %v2";

        // when
        Local local = visit(builder, input);
        ITEExpr expr = (ITEExpr) local.getExpr();

        // then
        assertEquals(builder.getExpression("%reg"), local.getResultRegister());
        assertEquals(builder.getExpression("%cond"), expr.getCondition());
        assertEquals(builder.getExpression("%v1"), expr.getTrueCase());
        assertEquals(builder.getExpression("%v2"), expr.getFalseCase());
    }

    @Test
    public void testOpSelectMismatchingOperandType() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 64);
        builder.mockConstant("%cond", "%bool", true);
        builder.mockConstant("%v1", "%bool", false);
        builder.mockConstant("%v2", "%int", 456);
        String input = "%reg = OpSelect %int %cond %v1 %v2";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal definition for '%reg', " +
                    "expected two operands type 'bv64 but received 'bool' and 'bv64'", e.getMessage());
        }
    }

    @Test
    public void testOpsLogicalBin() {
        doTestOpsLogicalBin("OpLogicalAnd", AND, true, true);
        doTestOpsLogicalBin("OpLogicalAnd", AND, false, true);
        doTestOpsLogicalBin("OpLogicalOr", OR, true, false);
        doTestOpsLogicalBin("OpLogicalOr", OR, true, true);
    }

    private void doTestOpsLogicalBin(String name, BoolBinaryOp op, boolean v1, boolean v2) {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockBoolType("%bool");
        builder.mockConstant("%v1", "%bool", v1);
        builder.mockConstant("%v2", "%bool", v2);
        String input = String.format("%%reg = %s %%bool %%v1 %%v2", name);

        // when
        Local local = visit(builder, input);
        BoolBinaryExpr expr = (BoolBinaryExpr) local.getExpr();

        // then
        assertEquals(builder.getExpression("%reg"), local.getResultRegister());
        assertEquals(builder.getExpression("%v1"), expr.getLeft());
        assertEquals(builder.getExpression("%v2"), expr.getRight());
        assertEquals(op, expr.getKind());
    }

    @Test
    public void testOpsIntegerBin() {
        doTestOpsIntegerBin("OpIEqual", EQ, 1, 2);
        doTestOpsIntegerBin("OpINotEqual", NEQ, 2, 1);
        doTestOpsIntegerBin("OpUGreaterThan", UGT, 0, 1);
        doTestOpsIntegerBin("OpSGreaterThan", GT, 0, -1);
        doTestOpsIntegerBin("OpUGreaterThanEqual", UGTE, 1, 1);
        doTestOpsIntegerBin("OpSGreaterThanEqual", GTE, 1, -1);
        doTestOpsIntegerBin("OpULessThan", ULT, 0, 1);
        doTestOpsIntegerBin("OpSLessThan", LT, 0, -1);
        doTestOpsIntegerBin("OpULessThanEqual", ULTE, 1, 1);
        doTestOpsIntegerBin("OpSLessThanEqual", LTE, 1, -1);
    }

    private void doTestOpsIntegerBin(String name, IntCmpOp op, int v1, int v2) {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 64);
        builder.mockConstant("%v1", "%int", v1);
        builder.mockConstant("%v2", "%int", v2);
        String input = String.format("%%reg = %s %%bool %%v1 %%v2", name);

        // when
        Local local = visit(builder, input);
        IntCmpExpr expr = (IntCmpExpr) local.getExpr();

        // then
        assertEquals(builder.getExpression("%reg"), local.getResultRegister());
        assertEquals(builder.getExpression("%v1"), expr.getLeft());
        assertEquals(builder.getExpression("%v2"), expr.getRight());
        assertEquals(op, expr.getKind());
    }

    @Test
    public void testOpsLogicalUnIllegalOperandType() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 64);
        builder.mockConstant("%value", "%int", 123);
        String input = "%reg = OpLogicalNot %bool %value";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal definition for '%reg', " +
                    "operand '%value' must be a boolean", e.getMessage());
        }
    }

    @Test
    public void testOpsLogicalBinIllegalOperandType() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 64);
        builder.mockConstant("%v1", "%int", 123);
        builder.mockConstant("%v2", "%bool", true);
        String input = "%reg = OpLogicalAnd %bool %v1 %v2";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal definition for '%reg', " +
                    "operand '%v1' must be a boolean", e.getMessage());
        }
    }

    @Test
    public void testOpsIntegerBinIllegalOperandType() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 64);
        builder.mockConstant("%v1", "%int", 123);
        builder.mockConstant("%v2", "%bool", true);
        String input = "%reg = OpIEqual %bool %v1 %v2";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal definition for '%reg', " +
                    "operand '%v2' must be an integer", e.getMessage());
        }
    }

    @Test
    public void testOpsIntegerBinMismatchingOperandTypes() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockBoolType("%bool");
        builder.mockIntType("%int32", 32);
        builder.mockIntType("%int64", 64);
        builder.mockConstant("%v1", "%int32", 123);
        builder.mockConstant("%v2", "%int64", 456);
        String input = "%reg = OpIEqual %bool %v1 %v2";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal definition for '%reg', " +
                    "operands have different types: " +
                    "'%v1' is 'bv32' and '%v2' is 'bv64'", e.getMessage());
        }
    }

    @Test
    public void testUnsupportedResultType() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockBoolType("%bool");
        builder.mockVectorType("%vector", "%bool", 4);
        builder.mockConstant("%value", "%vector", List.of(true, false, true, false));
        String input = "%reg = OpLogicalNot %vector %value";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Unsupported result type for '%reg', " +
                    "vector types are not supported", e.getMessage());
        }
    }

    @Test
    public void testIllegalResultType() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 64);
        builder.mockConstant("%value", "%bool", true);
        String input = "%reg = OpLogicalNot %int %value";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal result type for '%reg'", e.getMessage());
        }
    }

    @Test
    public void testOpSelectFloat() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockBoolType("%bool");
        builder.mockFloatType("%float", 32);
        builder.mockConstant("%cond", "%bool", true);
        builder.mockConstant("%v1", "%float", 1.0);
        builder.mockConstant("%v2", "%float", 2.0);
        String input = "%reg = OpSelect %float %cond %v1 %v2";

        // when
        Local local = visit(builder, input);
        ITEExpr expr = (ITEExpr) local.getExpr();

        // then
        assertEquals(builder.getExpression("%reg"), local.getResultRegister());
        assertEquals(builder.getExpression("%cond"), expr.getCondition());
        assertEquals(builder.getExpression("%v1"), expr.getTrueCase());
        assertEquals(builder.getExpression("%v2"), expr.getFalseCase());
    }

    @Test
    public void testFloatComparisons() {
        doTestFloatComparison("OpFOrdEqual", FloatCmpOp.OEQ);
        doTestFloatComparison("OpFUnordEqual", FloatCmpOp.UEQ);
        doTestFloatComparison("OpFOrdNotEqual", FloatCmpOp.ONEQ);
        doTestFloatComparison("OpFUnordNotEqual", FloatCmpOp.UNEQ);
        doTestFloatComparison("OpFOrdLessThan", FloatCmpOp.OLT);
        doTestFloatComparison("OpFUnordLessThan", FloatCmpOp.ULT);
        doTestFloatComparison("OpFOrdGreaterThan", FloatCmpOp.OGT);
        doTestFloatComparison("OpFUnordGreaterThan", FloatCmpOp.UGT);
        doTestFloatComparison("OpFOrdLessThanEqual", FloatCmpOp.OLTE);
        doTestFloatComparison("OpFUnordLessThanEqual", FloatCmpOp.ULTE);
        doTestFloatComparison("OpFOrdGreaterThanEqual", FloatCmpOp.OGTE);
        doTestFloatComparison("OpFUnordGreaterThanEqual", FloatCmpOp.UGTE);
    }

    private void doTestFloatComparison(String name, FloatCmpOp op) {
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockBoolType("%bool");
        builder.mockFloatType("%float", 32);
        builder.mockConstant("%left", "%float", 1.0);
        builder.mockConstant("%right", "%float", 2.0);

        Local local = visit(builder, String.format("%%reg = %s %%bool %%left %%right", name));

        FloatCmpExpr expr = (FloatCmpExpr) local.getExpr();
        assertEquals(op, expr.getKind());
        assertEquals(builder.getExpression("%left"), expr.getLeft());
        assertEquals(builder.getExpression("%right"), expr.getRight());
    }

    @Test
    public void testFloatVectorComparison() {
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockBoolType("%bool");
        builder.mockFloatType("%float", 32);
        builder.mockVectorType("%boolVector", "%bool", 2);
        builder.mockVectorType("%floatVector", "%float", 2);
        builder.mockConstant("%left", "%floatVector", List.of(1.0, 2.0));
        builder.mockConstant("%right", "%floatVector", List.of(3.0, 4.0));

        Local local = visit(builder, "%reg = OpFOrdEqual %boolVector %left %right");

        ConstructExpr result = (ConstructExpr) local.getExpr();
        assertEquals(2, result.getOperands().size());
        for (Expression element : result.getOperands()) {
            assertEquals(FloatCmpOp.OEQ, element.getKind());
        }
    }

    @Test
    public void testFloatComparisonRequiresMatchingOperandTypes() {
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockBoolType("%bool");
        builder.mockFloatType("%float32", 32);
        builder.mockFloatType("%float64", 64);
        builder.mockConstant("%left", "%float32", 1.0);
        builder.mockConstant("%right", "%float64", 2.0);

        try {
            visit(builder, "%reg = OpFOrdEqual %bool %left %right");
            fail("Should throw exception");
        } catch (ParsingException e) {
            assertEquals("Illegal floating-point comparison for '%reg': operand types must match", e.getMessage());
        }
    }

    private Local visit(MockProgramBuilder builder, String input) {
        builder.mockFunctionStart(true);
        return (Local) new MockSpirvParser(input).op().accept(new VisitorOpsLogical(builder));
    }
}
