package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.booleans.BoolBinaryOp;
import com.dat3m.dartagnan.expression.booleans.BoolUnaryOp;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;

import java.util.Set;
import java.util.function.Function;

public class VisitorOpsLogical extends SpirvBaseVisitor<Expression> {

    private static final ExpressionFactory EXPR_FACTORY = ExpressionFactory.getInstance();

    private final ProgramBuilderSpv builder;

    public VisitorOpsLogical(ProgramBuilderSpv builder) {
        this.builder = builder;
    }

    @Override
    public Expression visitOpLogicalOr(SpirvParser.OpLogicalOrContext ctx) {
        return visitLogicalBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), BoolBinaryOp.OR);
    }

    @Override
    public Expression visitOpLogicalAnd(SpirvParser.OpLogicalAndContext ctx) {
        return visitLogicalBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), BoolBinaryOp.AND);
    }

    @Override
    public Expression visitOpLogicalNot(SpirvParser.OpLogicalNotContext ctx) {
        return visitLogicalUnExpression(ctx.idResult(), ctx.idResultType(), ctx.operand(), BoolUnaryOp.NOT);
    }

    @Override
    public Expression visitOpIEqual(SpirvParser.OpIEqualContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), IntCmpOp.EQ);
    }

    @Override
    public Expression visitOpINotEqual(SpirvParser.OpINotEqualContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), IntCmpOp.NEQ);
    }

    @Override
    public Expression visitOpUGreaterThan(SpirvParser.OpUGreaterThanContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), IntCmpOp.UGT);
    }

    @Override
    public Expression visitOpSGreaterThan(SpirvParser.OpSGreaterThanContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), IntCmpOp.GT);
    }

    @Override
    public Expression visitOpUGreaterThanEqual(SpirvParser.OpUGreaterThanEqualContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), IntCmpOp.UGTE);
    }

    @Override
    public Expression visitOpSGreaterThanEqual(SpirvParser.OpSGreaterThanEqualContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), IntCmpOp.GTE);
    }

    @Override
    public Expression visitOpULessThan(SpirvParser.OpULessThanContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), IntCmpOp.ULT);
    }

    @Override
    public Expression visitOpSLessThan(SpirvParser.OpSLessThanContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), IntCmpOp.LT);
    }

    @Override
    public Expression visitOpULessThanEqual(SpirvParser.OpULessThanEqualContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), IntCmpOp.ULTE);
    }

    @Override
    public Expression visitOpSLessThanEqual(SpirvParser.OpSLessThanEqualContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), IntCmpOp.LTE);
    }

    private Expression visitLogicalUnExpression(
            SpirvParser.IdResultContext idCtx,
            SpirvParser.IdResultTypeContext typeCtx,
            SpirvParser.OperandContext opCtx,
            BoolUnaryOp op) {
        String id = idCtx.getText();
        return forType(id, typeCtx.getText(), bType -> {
            Expression operand = getOperandBoolean(id, opCtx.getText());
            return EXPR_FACTORY.makeUnary(op, operand);
        });
    }

    private Expression visitLogicalBinExpression(
            SpirvParser.IdResultContext idCtx,
            SpirvParser.IdResultTypeContext typeCtx,
            SpirvParser.Operand1Context op1Ctx,
            SpirvParser.Operand2Context op2Ctx,
            BoolBinaryOp op) {
        String id = idCtx.getText();
        return forType(id, typeCtx.getText(), bType -> {
            Expression op1 = getOperandBoolean(id, op1Ctx.getText());
            Expression op2 = getOperandBoolean(id, op2Ctx.getText());
            return EXPR_FACTORY.makeBinary(op1, op, op2);
        });
    }

    private Expression visitIntegerBinExpression(
            SpirvParser.IdResultContext idCtx,
            SpirvParser.IdResultTypeContext typeCtx,
            SpirvParser.Operand1Context op1Ctx,
            SpirvParser.Operand2Context op2Ctx,
            IntCmpOp op) {
        String id = idCtx.getText();
        return forType(id, typeCtx.getText(), bType -> {
            Expression op1 = getOperandInteger(id, op1Ctx.getText());
            Expression op2 = getOperandInteger(id, op2Ctx.getText());
            if (op1.getType().equals(op2.getType())) {
                return EXPR_FACTORY.makeIntCmp(op1, op, op2);
            }
            throw new ParsingException("Illegal definition for '%s', " +
                    "operands have different types: '%s' is '%s' and '%s' is '%s'",
                    id, op1Ctx.getText(), op1.getType(), op2Ctx.getText(), op2.getType());
        });
    }

    private Expression forType(String id, String typeId, Function<BooleanType, Expression> f) {
        Type type = builder.getType(typeId);
        if (type instanceof BooleanType bType) {
            return builder.addExpression(id, f.apply(bType));
        }
        if (type instanceof ArrayType) {
            throw new ParsingException("Unsupported result type for '%s', " +
                    "vector types are not supported", id);
        }
        throw new ParsingException("Illegal result type for '%s'", id);
    }

    private Expression getOperandBoolean(String id, String opId) {
        Expression op = builder.getExpression(opId);
        if (op.getType() instanceof BooleanType) {
            return op;
        }
        throw new ParsingException("Illegal definition for '%s', " +
                "operand '%s' must be a boolean", id, opId);
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
                "OpLogicalOr",
                "OpLogicalAnd",
                "OpLogicalNot",
                "OpIEqual",
                "OpINotEqual",
                "OpUGreaterThan",
                "OpSGreaterThan",
                "OpUGreaterThanEqual",
                "OpSGreaterThanEqual",
                "OpULessThan",
                "OpSLessThan",
                "OpULessThanEqual",
                "OpSLessThanEqual"
        );
    }
}
