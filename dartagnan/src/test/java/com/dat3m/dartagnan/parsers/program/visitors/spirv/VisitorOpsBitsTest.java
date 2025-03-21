package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.BinaryExpression;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.integers.IntBinaryExpr;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import com.dat3m.dartagnan.program.event.core.Local;
import org.junit.Test;

import java.util.List;

import static com.dat3m.dartagnan.expression.integers.IntBinaryOp.*;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class VisitorOpsBitsTest {

    @Test
    public void testScalarOps() {
        doTestScalarOps("OpBitwiseAnd", AND);
        doTestScalarOps("OpBitwiseOr", OR);
        doTestScalarOps("OpBitwiseXor", XOR);
        doTestScalarOps("OpShiftLeftLogical", LSHIFT);
        doTestScalarOps("OpShiftRightLogical", RSHIFT);
        doTestScalarOps("OpShiftRightArithmetic", ARSHIFT);
    }

    private void doTestScalarOps(String name, IntBinaryOp op) {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockIntType("%int", 64);
        builder.mockConstant("%value1", "%int", 4);
        builder.mockConstant("%value2", "%int", 7);
        String input = String.format("%%res = %s %%int %%value1 %%value2", name);

        // when
        Local local = visit(builder, input);

        // then
        IntBinaryExpr result = (IntBinaryExpr) local.getExpr();
        assertEquals(builder.getExpression("%value1"), result.getLeft());
        assertEquals(builder.getExpression("%value2"), result.getRight());
        assertEquals(op, result.getKind());
        assertEquals(builder.getExpression("%res"), local.getResultRegister());
    }

    @Test
    public void testVectorOperations() {
        doTestVectorOperations("OpBitwiseAnd", AND);
        doTestVectorOperations("OpBitwiseOr", OR);
        doTestVectorOperations("OpBitwiseXor", XOR);
        doTestVectorOperations("OpShiftLeftLogical", LSHIFT);
        doTestVectorOperations("OpShiftRightLogical", RSHIFT);
        doTestVectorOperations("OpShiftRightArithmetic", ARSHIFT);
    }

    private void doTestVectorOperations(String name, IntBinaryOp op) {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockIntType("%int", 64);
        builder.mockVectorType("%array", "%int", 3);
        ConstructExpr op1 = (ConstructExpr) builder.mockConstant("%value1", "%array", List.of(0, 1, 2));
        ConstructExpr op2 = (ConstructExpr) builder.mockConstant("%value2", "%array", List.of(3, 4, 5));
        String input = String.format("%%res = %s %%array %%value1 %%value2", name);

        // when
        Local local = visit(builder, input);

        // then
        ConstructExpr result = (ConstructExpr) local.getExpr();
        for (int i = 0; i < 3; i++) {
            BinaryExpression element = (BinaryExpression) result.getOperands().get(i);
            assertEquals(op1.getOperands().get(i), element.getLeft());
            assertEquals(op2.getOperands().get(i), element.getRight());
            assertEquals(op, element.getKind());
        }
        assertEquals(builder.getExpression("%res"), local.getResultRegister());
    }

    @Test
    public void testMismatchingTypes() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockIntType("%int", 64);
        builder.mockVectorType("%vector", "%int", 3);
        builder.mockConstant("%value1", "%int", 1);
        builder.mockConstant("%value2", "%int", 2);
        String input = "%reg = OpShiftLeftLogical %vector %value1 %value2";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal definition for '%reg', " +
                            "result type doesn't match operand types",
                    e.getMessage());
        }
    }

    private Local visit(MockProgramBuilder builder, String input) {
        builder.mockFunctionStart(true);
        return (Local) new MockSpirvParser(input).op().accept(new VisitorOpsBits(builder));
    }
}
