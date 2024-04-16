package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Local;

import java.util.Set;
import java.util.function.Function;

public class VisitorOpsBits extends SpirvBaseVisitor<Event> {

    private static final ExpressionFactory EXPR_FACTORY = ExpressionFactory.getInstance();

    private final ProgramBuilderSpv builder;

    public VisitorOpsBits(ProgramBuilderSpv builder) {
        this.builder = builder;
    }

    @Override
    public Event visitOpShiftLeftLogical(SpirvParser.OpShiftLeftLogicalContext ctx) {
        return visitShiftBinExpression(ctx.idResult(), ctx.idResultType(), ctx.base(), ctx.shift(), IntBinaryOp.LSHIFT);
    }

    @Override
    public Event visitOpShiftRightLogical(SpirvParser.OpShiftRightLogicalContext ctx) {
        return visitShiftBinExpression(ctx.idResult(), ctx.idResultType(), ctx.base(), ctx.shift(), IntBinaryOp.RSHIFT);
    }

    @Override
    public Event visitOpShiftRightArithmetic(SpirvParser.OpShiftRightArithmeticContext ctx) {
        return visitShiftBinExpression(ctx.idResult(), ctx.idResultType(), ctx.base(), ctx.shift(), IntBinaryOp.ARSHIFT);
    }

    @Override
    public Event visitOpBitwiseAnd(SpirvParser.OpBitwiseAndContext ctx) {
        return visitBitwiseExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), IntBinaryOp.AND);
    }

    @Override
    public Event visitOpBitwiseOr(SpirvParser.OpBitwiseOrContext ctx) {
        return visitBitwiseExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), IntBinaryOp.OR);
    }

    @Override
    public Event visitOpBitwiseXor(SpirvParser.OpBitwiseXorContext ctx) {
        return visitBitwiseExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), IntBinaryOp.XOR);
    }

    private Event visitShiftBinExpression(
            SpirvParser.IdResultContext idCtx,
            SpirvParser.IdResultTypeContext typeCtx,
            SpirvParser.BaseContext op1Ctx,
            SpirvParser.ShiftContext op2Ctx,
            IntBinaryOp op) {
        String id = idCtx.getText();
        return forType(id, typeCtx.getText(), bType -> {
            Expression op1 = getOperandInteger(id, op1Ctx.getText());
            Expression op2 = getOperandInteger(id, op2Ctx.getText());
            return EXPR_FACTORY.makeBinary(op1, op, op2);
        });
    }

    private Event visitBitwiseExpression(
            SpirvParser.IdResultContext idCtx,
            SpirvParser.IdResultTypeContext typeCtx,
            SpirvParser.Operand1Context op1Ctx,
            SpirvParser.Operand2Context op2Ctx,
            IntBinaryOp op) {
        String id = idCtx.getText();
        return forType(id, typeCtx.getText(), bType -> {
            Expression op1 = getOperandInteger(id, op1Ctx.getText());
            Expression op2 = getOperandInteger(id, op2Ctx.getText());
            return EXPR_FACTORY.makeBinary(op1, op, op2);
        });
    }

    private Event forType(String id, String typeId, Function<IntegerType, Expression> f) {
        Type type = builder.getType(typeId);
        if (type instanceof IntegerType bType) {
            Register register = builder.addRegister(id, typeId);
            Local event = EventFactory.newLocal(register, f.apply(bType));
            return builder.addEvent(event);
        }
        if (type instanceof ArrayType) {
            throw new ParsingException("Unsupported result type for '%s', " +
                    "vector types are not supported", id);
        }
        throw new ParsingException("Illegal result type for '%s'", id);
    }

    private Expression getOperandInteger(String id, String opId) {
        Expression op = builder.getExpression(opId);
        if (op.getType() instanceof IntegerType) {
            return op;
        }
        throw new ParsingException("Illegal definition for '%s', " +
                "operand '%s' must be an integer", id, opId);
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpShiftLeftLogical",
                "OpShiftRightLogical",
                "opShiftRightArithmetic",
                "OpBitwiseAnd",
                "OpBitwiseOr",
                "OpBitwiseXor"
        );
    }
}
