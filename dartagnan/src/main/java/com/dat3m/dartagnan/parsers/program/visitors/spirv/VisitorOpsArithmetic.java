package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.integers.IntUnaryOp;
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

import static com.dat3m.dartagnan.expression.integers.IntBinaryOp.*;
import static com.dat3m.dartagnan.expression.integers.IntUnaryOp.MINUS;

public class VisitorOpsArithmetic extends SpirvBaseVisitor<Event> {

    private static final ExpressionFactory EXPR_FACTORY = ExpressionFactory.getInstance();

    private final ProgramBuilderSpv builder;

    public VisitorOpsArithmetic(ProgramBuilderSpv builder) {
        this.builder = builder;
    }

    @Override
    public Event visitOpSNegate(SpirvParser.OpSNegateContext ctx) {
        return visitIntegerUnExpression(ctx.idResult(), ctx.idResultType(), ctx.operand(), MINUS);
    }

    @Override
    public Event visitOpIAdd(SpirvParser.OpIAddContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), ADD);
    }

    @Override
    public Event visitOpISub(SpirvParser.OpISubContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), SUB);
    }

    @Override
    public Event visitOpIMul(SpirvParser.OpIMulContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), MUL);
    }

    @Override
    public Event visitOpUDiv(SpirvParser.OpUDivContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), UDIV);
    }

    @Override
    public Event visitOpSDiv(SpirvParser.OpSDivContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), DIV);
    }

    private Event visitIntegerUnExpression(
            SpirvParser.IdResultContext idCtx,
            SpirvParser.IdResultTypeContext typeCtx,
            SpirvParser.OperandContext opCtx,
            IntUnaryOp op
    ) {
        String id = idCtx.getText();
        return forType(id, typeCtx.getText(), iType -> {
            Expression left = builder.getExpression(opCtx.getText());
            if (iType.equals(left.getType())) {
                return EXPR_FACTORY.makeUnary(op, left);
            }
            throw new ParsingException("Illegal definition for '%s', " +
                    "types do not match: '%s' is '%s' and '%s' is '%s'",
                    id, opCtx.getText(), left.getType(), typeCtx.getText(), iType);
        });
    }

    private Event visitIntegerBinExpression(
            SpirvParser.IdResultContext idCtx,
            SpirvParser.IdResultTypeContext typeCtx,
            SpirvParser.Operand1Context op1Ctx,
            SpirvParser.Operand2Context op2Ctx,
            IntBinaryOp op
    ) {
        String id = idCtx.getText();
        return forType(id, typeCtx.getText(), iType -> {
            Expression op1 = builder.getExpression(op1Ctx.getText());
            Expression op2 = builder.getExpression(op2Ctx.getText());
            if (iType.equals(op1.getType()) && op1.getType().equals(op2.getType())) {
                return EXPR_FACTORY.makeBinary(op1, op, op2);
            }
            throw new ParsingException("Illegal definition for '%s', " +
                    "types do not match: '%s' is '%s', '%s' is '%s' and '%s' is '%s'",
                    id, op1Ctx.getText(), op1.getType(), op2Ctx.getText(), op2.getType(),
                    typeCtx.getText(), iType);
        });
    }

    private Event forType(String id, String typeId, Function<IntegerType, Expression> f) {
        Type type = builder.getType(typeId);
        if (type instanceof IntegerType iType) {
            Register register = builder.addRegister(id, typeId);
            Local event = EventFactory.newLocal(register, f.apply(iType));
            return builder.addEvent(event);
        }
        if (type instanceof ArrayType) {
            throw new ParsingException("Unsupported result type for '%s', " +
                    "vector types are not supported", id);
        }
        throw new ParsingException("Illegal result type for '%s'", id);
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpSNegate",
                "OpIAdd",
                "OpISub",
                "OpIMul",
                "OpUDiv",
                "OpSDiv"
        );
    }
}
