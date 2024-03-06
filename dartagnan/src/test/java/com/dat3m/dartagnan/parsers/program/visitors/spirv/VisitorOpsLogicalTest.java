package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.BExprBin;
import com.dat3m.dartagnan.expression.BExprUn;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.op.BOpBin;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilderSpv;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import org.junit.Test;

import java.util.List;

import static com.dat3m.dartagnan.expression.op.BOpBin.AND;
import static com.dat3m.dartagnan.expression.op.BOpBin.OR;
import static com.dat3m.dartagnan.expression.op.BOpUn.NOT;
import static com.dat3m.dartagnan.expression.op.COpBin.*;
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
        String input = "%expr = OpLogicalNot %bool %value";

        // when
        BExprUn expr = (BExprUn) visit(builder, input);

        // then
        assertEquals(builder.getExpression("%expr"), expr);
        assertEquals(builder.getExpression("%value"), expr.getInner());
        assertEquals(NOT, expr.getOp());
    }

    @Test
    public void testOpsLogicalBin() {
        doTestOpsLogicalBin("OpLogicalAnd", AND, true, true);
        doTestOpsLogicalBin("OpLogicalAnd", AND, false, true);
        doTestOpsLogicalBin("OpLogicalOr", OR, true, false);
        doTestOpsLogicalBin("OpLogicalOr", OR, true, true);
    }

    private void doTestOpsLogicalBin(String name, BOpBin op, boolean v1, boolean v2) {
        // given
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
        builder.mockBoolType("%bool");
        builder.mockConstant("%v1", "%bool", v1);
        builder.mockConstant("%v2", "%bool", v2);
        String input = String.format("%%expr = %s %%bool %%v1 %%v2", name);

        // when
        BExprBin expr = (BExprBin) visit(builder, input);

        // then
        assertEquals(builder.getExpression("%expr"), expr);
        assertEquals(builder.getExpression("%v1"), expr.getLHS());
        assertEquals(builder.getExpression("%v2"), expr.getRHS());
        assertEquals(op, expr.getOp());
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

    private void doTestOpsIntegerBin(String name, COpBin op, int v1, int v2) {
        // given
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 64);
        builder.mockConstant("%v1", "%int", v1);
        builder.mockConstant("%v2", "%int", v2);
        String input = String.format("%%expr = %s %%bool %%v1 %%v2", name);

        // when
        Atom expr = (Atom) visit(builder, input);

        // then
        assertEquals(builder.getExpression("%expr"), expr);
        assertEquals(builder.getExpression("%v1"), expr.getLHS());
        assertEquals(builder.getExpression("%v2"), expr.getRHS());
        assertEquals(op, expr.getOp());
    }

    @Test
    public void testOpsLogicalUnIllegalOperandType() {
        // given
        MockProgramBuilderSpv builder = new MockProgramBuilderSpv();
        builder.mockBoolType("%bool");
        builder.mockIntType("%int", 64);
        builder.mockConstant("%value", "%int", 123);
        String input = "%expr = OpLogicalNot %bool %value";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal definition for '%expr', " +
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
        String input = "%expr = OpLogicalAnd %bool %v1 %v2";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal definition for '%expr', " +
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
        String input = "%expr = OpIEqual %bool %v1 %v2";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal definition for '%expr', " +
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
        String input = "%expr = OpIEqual %bool %v1 %v2";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal definition for '%expr', " +
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
        String input = "%expr = OpLogicalNot %vector %value";

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
        builder.mockConstant("%value", "%bool", true);
        String input = "%expr = OpLogicalNot %int %value";

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
        return new MockSpirvParser(input).op().accept(new VisitorOpsLogical(builder));
    }
}
