package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
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
    public void testOpsBitwiseInteger() {
        doTestOpsBitwiseInteger("OpBitwiseAnd",1, 0);
        doTestOpsBitwiseInteger("OpBitwiseOr",1, 65);
        doTestOpsBitwiseInteger("OpBitwiseXor",-2, 6);
    }

    private void doTestOpsBitwiseInteger(String name, int op1, int op2) {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockIntType("%int", 64);
        builder.mockConstant("%value1", "%int", op1);
        builder.mockConstant("%value2", "%int", op2);
        String input = String.format("%%res = %s %%int %%value1 %%value2", name);

        // when
        Local local = visit(builder, input);

        // then
        assertEquals(builder.getExpression("%res"), local.getResultRegister());
        IntBinaryExpr expr = (IntBinaryExpr) local.getExpr();
        assertEquals(builder.getExpression("%value1"), expr.getLeft());
        assertEquals(builder.getExpression("%value2"), expr.getRight());
        IntBinaryOp kind = switch (name) {
            case "OpBitwiseAnd" -> AND;
            case "OpBitwiseOr" -> OR;
            case "OpBitwiseXor" -> XOR;
            default -> throw new ParsingException("Unsupported operation " + name);
        };
        assertEquals(kind, expr.getKind());
    }

    @Test
    public void testOpsBitwiseAndVector() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockIntType("%int", 64);
        builder.mockVectorType("%vector", "%int", 3);
        builder.mockConstant("%value1", "%vector", List.of(1, 2, 3));
        builder.mockConstant("%value2", "%vector", List.of(5, 6, 7));
        String input = "%reg = OpBitwiseAnd %vector %value1 %value2";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Unsupported result type for '%reg', " +
                            "vector types are not supported",
                    e.getMessage());
        }
    }

    @Test
    public void testOpsShift() {
        doTestOpsShift("OpShiftLeftLogical",1, 0);
        doTestOpsShift("OpShiftRightLogical",1, 65);
        doTestOpsShift("OpShiftRightArithmetic",-2, 6);
    }

    private void doTestOpsShift(String name, int op1, int op2) {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockIntType("%int", 64);
        builder.mockConstant("%value1", "%int", op1);
        builder.mockConstant("%value2", "%int", op2);
        String input = String.format("%%res = %s %%int %%value1 %%value2", name);

        // when
        Local local = visit(builder, input);

        // then
        assertEquals(builder.getExpression("%res"), local.getResultRegister());
        IntBinaryExpr expr = (IntBinaryExpr) local.getExpr();
        assertEquals(builder.getExpression("%value1"), expr.getLeft());
        assertEquals(builder.getExpression("%value2"), expr.getRight());
        IntBinaryOp kind = switch (name) {
            case "OpShiftLeftLogical" -> LSHIFT;
            case "OpShiftRightLogical" -> RSHIFT;
            case "OpShiftRightArithmetic" -> ARSHIFT;
            default -> throw new ParsingException("Unsupported operation " + name);
        };
        assertEquals(kind, expr.getKind());
    }

    @Test
    public void testOpsShiftInvalidResultType() {
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
            assertEquals("Unsupported result type for '%reg', " +
                            "vector types are not supported",
                    e.getMessage());
        }
    }

    @Test
    public void testOpsShiftInvalidOperandType() {
        // given
        MockProgramBuilder builder = new MockProgramBuilder();
        builder.mockIntType("%int", 64);
        builder.mockVectorType("%vector", "%int", 3);
        builder.mockConstant("%value1", "%vector", List.of(1, 2, 3));
        builder.mockConstant("%value2", "%int", 2);
        String input = "%reg = OpShiftLeftLogical %int %value1 %value2";

        try {
            // when
            visit(builder, input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals("Illegal definition for '%reg', " +
                            "operand '%value1' must be an integer",
                    e.getMessage());
        }
    }

    private Local visit(MockProgramBuilder builder, String input) {
        builder.mockFunctionStart(true);
        return (Local) new MockSpirvParser(input).op().accept(new VisitorOpsBits(builder));
    }
}
