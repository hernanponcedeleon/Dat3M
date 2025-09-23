package com.dat3m.dartagnan.parsers.program.visitors.spirv.extenstions;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;

import java.util.Set;
import java.util.ArrayList;
import java.util.List;

public class VisitorExtensionGlslStd extends VisitorExtension<Expression> {

    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private final ProgramBuilder builder;

    public VisitorExtensionGlslStd(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Expression visitOpExtInst(SpirvParser.OpExtInstContext ctx) {
        String result = ctx.idResult().getText();
        Expression expr = this.visit(ctx.instruction());
        builder.addExpression(result, expr);
        return null;
    }

    @Override
    public Expression visitGlsl_findILsb(SpirvParser.Glsl_findILsbContext ctx) {
        Expression value = builder.getExpression(ctx.valueIdRef().getText());
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
        throw new ParsingException("Value type %s of FindILsb is not integer scalar or integer vector", type);
    }

    @Override
    public Set<String> getSupportedInstructions() {
        return Set.of(
            "FindILsb"
        );
    }
}
