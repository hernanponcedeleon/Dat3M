package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.booleans.BoolBinaryExpr;
import com.dat3m.dartagnan.expression.booleans.BoolBinaryOp;
import com.dat3m.dartagnan.expression.booleans.BoolUnaryExpr;
import com.dat3m.dartagnan.expression.integers.IntCmpExpr;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilderSpv;
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
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
        builder.mockBoolType("%bool");
        builder.mockConstant("%value", "%bool", value);
        String input = "%reg = OpLogicalNot %bool %value";

        // when
        Local local = visit(builder, input);

        // then
        assertEquals(builder.getExpression("%reg"), local.getResultRegister());
        BoolUnaryExpr expr = (BoolUnaryExpr) local.getExpr();
        assertEquals(builder.getExpression("%value"), expr.getOperand());
        assertEquals(NOT, expr.getKind());
    }

    @Test
    public void testOpSelect() {
        // given
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 64);
        builder.mockConstant("%cond", "%bool", true);
        builder.mockConstant("%v1", "%int", 123);
        builder.mockConstant("%v2", "%int", 456);
        String input = "%reg = OpSelect %int %cond %v1 %v2";

        // when
        Local local = visit(builder, input);

        // then
        assertEquals(builder.getExpression("%reg"), local.getResultRegister());
        assertEquals(builder.mockITE(builder.getExpression("%cond"), "%v1", "%v2"), local.getExpr());
    }

    @Test
    public void testOpSelectMismatchingOperandType() {
        // given
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
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
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
        builder.mockBoolType("%bool");
        builder.mockConstant("%v1", "%bool", v1);
        builder.mockConstant("%v2", "%bool", v2);
        String input = String.format("%%reg = %s %%bool %%v1 %%v2", name);

        // when
        Local local = visit(builder, input);

        // then
        assertEquals(builder.getExpression("%reg"), local.getResultRegister());
        BoolBinaryExpr expr = (BoolBinaryExpr) local.getExpr();
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
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 64);
        builder.mockConstant("%v1", "%int", v1);
        builder.mockConstant("%v2", "%int", v2);
        String input = String.format("%%reg = %s %%bool %%v1 %%v2", name);

        // when
        Local local = visit(builder, input);

        // then
        assertEquals(builder.getExpression("%reg"), local.getResultRegister());
        IntCmpExpr expr = (IntCmpExpr) local.getExpr();
        assertEquals(builder.getExpression("%v1"), expr.getLeft());
        assertEquals(builder.getExpression("%v2"), expr.getRight());
        assertEquals(op, expr.getKind());
    }

    @Test
    public void testOpsLogicalUnIllegalOperandType() {
        // given
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
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
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
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
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
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
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
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
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
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
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
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

    private Local visit(MockProgramBuilderSpv builder, String input) {
        builder.mockFunctionStart();
        builder.mockLabel();
        return (Local) new MockSpirvParser(input).op().accept(new VisitorOpsLogical(builder));
    }
}
