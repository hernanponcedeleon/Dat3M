package com.dat3m.dartagnan.parsers.program.visitors.spirv.extenstions;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

public class VisitorExtensionOpenClStd extends VisitorExtension<Expression> {

    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private final ProgramBuilder builder;

    public VisitorExtensionOpenClStd(ProgramBuilder builder) {
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
    public Expression visitOpencl_s_add_sat(SpirvParser.Opencl_s_add_satContext ctx) {
        Expression x = getExpression(ctx.x().getText());
        Expression y = getExpression(ctx.y().getText());
        if (x.getType() instanceof IntegerType && y.getType() instanceof IntegerType) {
            return expressions.makeAdd(x, y);
        } else if (x.getType() instanceof ArrayType xType && y.getType() instanceof ArrayType yType) {
            if (xType.getNumElements() != yType.getNumElements() || !xType.getElementType().equals(yType.getElementType())) {
                throw new ParsingException("Array types must have the same number of elements");
            }
            List<Expression> sums = new ArrayList<>();
            for (int i = 0; i < xType.getNumElements(); i++) {
                sums.add(expressions.makeAdd(
                        expressions.makeExtract(i, x),
                        expressions.makeExtract(i, y)
                ));
            }
            return expressions.makeArray(xType.getElementType(), sums, true);
        }
        throw new ParsingException("Unsupported types for s_add_sat: %s and %s", x.getType(), y.getType());
    }

    @Override
    public Expression visitOpencl_s_sub_sat(SpirvParser.Opencl_s_sub_satContext ctx) {
        Expression x = getExpression(ctx.x().getText());
        Expression y = getExpression(ctx.y().getText());
        if (x.getType() instanceof IntegerType && y.getType() instanceof IntegerType) {
            return expressions.makeSub(x, y);
        } else if (x.getType() instanceof ArrayType xType && y.getType() instanceof ArrayType yType) {
            if (xType.getNumElements() != yType.getNumElements() || !xType.getElementType().equals(yType.getElementType())) {
                throw new ParsingException("Array types must have the same number of elements");
            }
            List<Expression> subs = new ArrayList<>();
            for (int i = 0; i < xType.getNumElements(); i++) {
                subs.add(expressions.makeSub(
                        expressions.makeExtract(i, x),
                        expressions.makeExtract(i, y)
                ));
            }
            return expressions.makeArray(xType.getElementType(), subs, true);
        }
        throw new ParsingException("Unsupported types for s_sub_sat: %s and %s", x.getType(), y.getType());
    }

    private Expression getExpression(String id) {
        Expression expression = builder.getExpression(id);
        if (expression == null) {
            throw new ParsingException("Expression '%s' is not defined", id);
        }
        return expression;
    }

    @Override
    public Set<String> getSupportedInstructions() {
        return Set.of(
                "s_add_sat",
                "s_sub_sat"
        );
    }
}
