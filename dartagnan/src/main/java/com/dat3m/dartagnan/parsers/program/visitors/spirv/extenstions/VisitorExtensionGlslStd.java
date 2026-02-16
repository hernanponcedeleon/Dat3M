package com.dat3m.dartagnan.parsers.program.visitors.spirv.extenstions;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

public class VisitorExtensionGlslStd extends VisitorExtension<Expression> {

    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private final ProgramBuilder builder;

    public VisitorExtensionGlslStd(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Expression visitGlsl_findILsb(SpirvParser.Glsl_findILsbContext ctx) {
        String valueId = ctx.valueIdRef().getText();
        Expression value = builder.getExpression(valueId);
        Type type = value.getType();
        if (type instanceof IntegerType iType) {
            Expression zero = expressions.makeValue(0, iType);
            Expression mOne = expressions.makeValue(-1, iType);
            Expression trailingZeros = expressions.makeCTTZ(value);
            Expression valueIsZero = expressions.makeEQ(value, zero);
            return expressions.makeITE(valueIsZero, mOne, trailingZeros);
        }
        if (type instanceof ArrayType aType && aType.getElementType() instanceof IntegerType eType) {
            List<Expression> elements = new ArrayList<>();
            for (int i = 0; i < aType.getNumElements(); i++) {
                Expression elementValue = value instanceof ConstructExpr ? value.getOperands().get(i) : expressions.makeExtract(value, i);
                Expression zero = expressions.makeValue(0, eType);
                Expression mOne = expressions.makeValue(-1, eType);
                Expression trailingZeros = expressions.makeCTTZ(elementValue);
                Expression valueIsZero = expressions.makeEQ(elementValue, zero);
                elements.add(expressions.makeITE(valueIsZero, mOne, trailingZeros));
            }
            return expressions.makeArray(aType, elements);
        }
        throw new ParsingException("Value type %s in %s of FindILsb is not integer scalar or integer vector", type, valueId);
    }

    @Override
    public Expression visitGlsl_sMax(SpirvParser.Glsl_sMaxContext ctx) {
        Expression x = builder.getExpression(ctx.x().getText());
        Expression y = builder.getExpression(ctx.y().getText());
        return intBinExpression(x, IntBinaryOp.SMAX, y, "SMax");
    }

    @Override
    public Expression visitGlsl_uMax(SpirvParser.Glsl_uMaxContext ctx) {
        Expression x = builder.getExpression(ctx.x().getText());
        Expression y = builder.getExpression(ctx.y().getText());
        return intBinExpression(x, IntBinaryOp.UMAX, y, "UMax");
    }

    @Override
    public Expression visitGlsl_sMin(SpirvParser.Glsl_sMinContext ctx) {
        Expression x = builder.getExpression(ctx.x().getText());
        Expression y = builder.getExpression(ctx.y().getText());
        return intBinExpression(x, IntBinaryOp.SMIN, y, "SMin");
    }

    @Override
    public Expression visitGlsl_uMin(SpirvParser.Glsl_uMinContext ctx) {
        Expression x = builder.getExpression(ctx.x().getText());
        Expression y = builder.getExpression(ctx.y().getText());
        return intBinExpression(x, IntBinaryOp.UMIN, y, "UMin");
    }

    private Expression intBinExpression(Expression x, IntBinaryOp op, Expression y, String spirvOpName) {
        Type xType = x.getType();
        Type yType = y.getType();
        if (!xType.equals(yType)) {
            throw new ParsingException("Illegal definition for %s, " +
                    "types do not match: '%s' is '%s' and '%s' is '%s'", spirvOpName, x, xType, y, yType);
        }
        if (xType instanceof IntegerType) {
            return expressions.makeIntBinary(x, op, y);
        }
        if (xType instanceof ArrayType aType && aType.getElementType() instanceof IntegerType) {
            List<Expression> elements = new ArrayList<>();
            for (int i = 0; i < aType.getNumElements(); i++) {
                Expression elementOp1 = x instanceof ConstructExpr ? x.getOperands().get(i) : expressions.makeExtract(x, i);
                Expression elementOp2 = y instanceof ConstructExpr ? y.getOperands().get(i) : expressions.makeExtract(y, i);
                elements.add(expressions.makeIntBinary(elementOp1, op, elementOp2));
            }
            return expressions.makeArray(aType, elements);
        }
        throw new ParsingException("Illegal definition for %s, " +
                "type %s is not scalar or vector of scalar", spirvOpName,  xType);
    }

    @Override
    public Set<String> getSupportedInstructions() {
        return Set.of(
            "FindILsb",
            "SMax",
            "UMax",
            "SMin",
            "UMin"
        );
    }
}
