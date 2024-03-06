package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.program.Register;

import java.math.BigInteger;
import java.util.List;
import java.util.Set;

public class VisitorOpsConstant extends SpirvBaseVisitor<Expression> {

    private static final ExpressionFactory EXPR_FACTORY = ExpressionFactory.getInstance();

    private final ProgramBuilderSpv builder;

    public VisitorOpsConstant(ProgramBuilderSpv builder) {
        this.builder = builder;
    }

    @Override
    public Expression visitOpConstantTrue(SpirvParser.OpConstantTrueContext ctx) {
        return builder.addExpression(ctx.idResult().getText(), EXPR_FACTORY.makeTrue());
    }

    @Override
    public Expression visitOpConstantFalse(SpirvParser.OpConstantFalseContext ctx) {
        return builder.addExpression(ctx.idResult().getText(), EXPR_FACTORY.makeFalse());
    }

    @Override
    public Expression visitOpConstant(SpirvParser.OpConstantContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getType(ctx.idResultType().getText());
        if (type instanceof IntegerType iType) {
            BigInteger value = new BigInteger(ctx.valueLiteralContextDependentNumber().getText());
            Expression expression = EXPR_FACTORY.makeValue(value, iType);
            return builder.addExpression(id, expression);
        }
        throw new ParsingException("Illegal constant type '%s'", type);
    }

    @Override
    public Expression visitOpConstantComposite(SpirvParser.OpConstantCompositeContext ctx) {
        // TODO: Check types, tests
        String id = ctx.idResult().getText();
        List<Expression> constituents = ctx.constituents().stream()
                .map(c -> builder.getExpression(c.getText()))
                .toList();
        Expression expression = ExpressionFactory.getInstance().makeConstruct(constituents);
        return builder.addExpression(id, expression);
    }

    @Override
    public Expression visitOpConstantNull(SpirvParser.OpConstantNullContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getType(ctx.idResultType().getText());
        if (type instanceof BooleanType) {
            Expression expression = EXPR_FACTORY.makeFalse();
            return builder.addExpression(id, expression);
        }
        if (type instanceof IntegerType iType) {
            Expression expression = EXPR_FACTORY.makeZero(iType);
            return builder.addExpression(id, expression);
        }
        throw new ParsingException("Illegal NULL constant type '%s'", type);
    }

    @Override
    public Expression visitOpSpecConstant(SpirvParser.OpSpecConstantContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getType(ctx.idResultType().getText());
        if (type instanceof IntegerType iType) {
            BigInteger value = new BigInteger(ctx.valueLiteralContextDependentNumber().getText());
            Expression expression = EXPR_FACTORY.makeValue(value, iType);
            return builder.addExpression(id, expression);
        }
        throw new ParsingException("Illegal constant type '%s'", type);
    }

    // Special handling for OpSpecConstantOp (wrapper for another Op)
    public Type visitOpSpecConstantOp(Register register) {
        // TODO: Handle SpecConstants
        return register.getType();
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpConstantTrue",
                "OpConstantFalse",
                "OpConstant",
                "OpConstantComposite",
                "OpConstantNull",
                "OpSpecConstant"
        );
    }
}
