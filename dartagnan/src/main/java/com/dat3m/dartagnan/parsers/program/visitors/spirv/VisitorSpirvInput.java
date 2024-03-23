package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;

public class VisitorSpirvInput extends SpirvBaseVisitor<Expression> {
    private static final TypeFactory TYPE_FACTORY = TypeFactory.getInstance();
    private static final ExpressionFactory EXPR_FACTORY = ExpressionFactory.getInstance();
    private final ProgramBuilderSpv builder;

    public VisitorSpirvInput(ProgramBuilderSpv builder) {
        this.builder = builder;
    }

    @Override
    public Expression visitInit(SpirvParser.InitContext ctx) {
        String varName = ctx.varName().getText();
        Expression expr = visit(ctx.initValue());
        builder.addInput(varName, expr);
        return null;
    }

    @Override
    public Expression visitInitBaseValue(SpirvParser.InitBaseValueContext ctx) {
        IntegerType mockType = TYPE_FACTORY.getArchType();
        try {
            return EXPR_FACTORY.makeValue(Long.parseLong(ctx.getText()), mockType);
        } catch (ParsingException e) {
            throw new ParsingException("Unsupported value " + ctx.getText());
        }
    }

    @Override
    public Expression visitInitCollectionValue(SpirvParser.InitCollectionValueContext ctx) {
        return EXPR_FACTORY.makeConstruct(ctx.initValues().initValue().stream()
                .map(this::visitInitValue)
                .toList());
    }
}
