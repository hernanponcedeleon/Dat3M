package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.stream.Collectors;

public class VisitorSpirvInput extends SpirvBaseVisitor<Expression> {
    private static final TypeFactory TYPE_FACTORY = TypeFactory.getInstance();
    private static final ExpressionFactory EXPR_FACTORY = ExpressionFactory.getInstance();
    private final ProgramBuilderSpv builder;

    public VisitorSpirvInput(ProgramBuilderSpv builder) {
        this.builder = builder;
    }

    @Override
    public Expression visitInitList(SpirvParser.InitListContext ctx) {
        for (SpirvParser.InitContext init : ctx.init()) {
            visit(init);
        }
        return null;
    }

    @Override
    public Expression visitInit(SpirvParser.InitContext ctx) {
        String varName = ctx.varName().getText();
        Expression expr = visit(ctx.initValue());
        builder.addInputs(varName, expr);
        return visitChildren(ctx);
    }

    @Override
    public Expression visitInitBaseValue(SpirvParser.InitBaseValueContext ctx) {
        IntegerType mockType = TYPE_FACTORY.getIntegerType();
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
                .collect(Collectors.toList()));
    }
}
