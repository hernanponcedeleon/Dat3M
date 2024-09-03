package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;

public class VisitorSpirvInput extends SpirvBaseVisitor<Expression> {
    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private final ProgramBuilder builder;

    public VisitorSpirvInput(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Expression visitSpvHeaders(SpirvParser.SpvHeadersContext ctx) {
        for (SpirvParser.SpvHeaderContext header : ctx.spvHeader()) {
            if (header.inputHeader() != null && header.inputHeader().initList() != null) {
                visitInitList(header.inputHeader().initList());
            }
        }
        return null;
    }

    @Override
    public Expression visitInit(SpirvParser.InitContext ctx) {
        String id = ctx.varName().getText();
        Expression value = visit(ctx.initValue());
        builder.addInput(id, value);
        return null;
    }

    @Override
    public Expression visitInitBaseValue(SpirvParser.InitBaseValueContext ctx) {
        IntegerType mockType = types.getArchType();
        try {
            return expressions.makeValue(Long.parseLong(ctx.getText()), mockType);
        } catch (ParsingException e) {
            throw new ParsingException("Unsupported value " + ctx.getText());
        }
    }

    @Override
    public Expression visitInitCollectionValue(SpirvParser.InitCollectionValueContext ctx) {
        return expressions.makeConstruct(ctx.initValues().initValue().stream()
                .map(this::visitInitValue)
                .toList());
    }
}
