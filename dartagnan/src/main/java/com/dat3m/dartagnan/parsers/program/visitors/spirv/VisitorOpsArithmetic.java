package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.expression.op.IOpUn;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;

import java.util.Set;
import java.util.function.Function;

import static com.dat3m.dartagnan.expression.op.IOpBin.*;
import static com.dat3m.dartagnan.expression.op.IOpUn.MINUS;

public class VisitorOpsArithmetic extends SpirvBaseVisitor<Expression> {

    private static final ExpressionFactory EXPR_FACTORY = ExpressionFactory.getInstance();

    private final ProgramBuilderSpv builder;

    public VisitorOpsArithmetic(ProgramBuilderSpv builder) {
        this.builder = builder;
    }

    @Override
    public Expression visitOpSNegate(SpirvParser.OpSNegateContext ctx) {
        return visitIntegerUnExpression(ctx.idResult(), ctx.idResultType(), ctx.operand(), MINUS);
    }

    @Override
    public Expression visitOpIAdd(SpirvParser.OpIAddContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), ADD);
    }

    @Override
    public Expression visitOpISub(SpirvParser.OpISubContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), SUB);
    }

    @Override
    public Expression visitOpIMul(SpirvParser.OpIMulContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), MUL);
    }

    @Override
    public Expression visitOpUDiv(SpirvParser.OpUDivContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), UDIV);
    }

    @Override
    public Expression visitOpSDiv(SpirvParser.OpSDivContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), DIV);
    }

    @Override
    public Expression visitOpUMod(SpirvParser.OpUModContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), MOD);
    }

    private Expression visitIntegerUnExpression(
            SpirvParser.IdResultContext idCtx,
            SpirvParser.IdResultTypeContext typeCtx,
            SpirvParser.OperandContext opCtx,
            IOpUn op
    ) {
        String id = idCtx.getText();
        return forType(id, typeCtx.getText(), iType -> {
            Expression left = builder.getExpression(opCtx.getText());
            if (iType.equals(left.getType())) {
                return EXPR_FACTORY.makeUnary(op, left, iType);
            }
            throw new ParsingException("Illegal definition for '%s', " +
                    "types do not match: '%s' is '%s' and '%s' is '%s'",
                    id, opCtx.getText(), left.getType(), typeCtx.getText(), iType);
        });
    }

    private Expression visitIntegerBinExpression(
            SpirvParser.IdResultContext idCtx,
            SpirvParser.IdResultTypeContext typeCtx,
            SpirvParser.Operand1Context op1Ctx,
            SpirvParser.Operand2Context op2Ctx,
            IOpBin op
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

    private Expression forType(String id, String typeId, Function<IntegerType, Expression> f) {
        Type type = builder.getType(typeId);
        if (type instanceof IntegerType iType) {
            return builder.addExpression(id, f.apply(iType));
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
                "OpSDiv",
                "OpUMod"
        );
    }
}
