package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;

import java.util.ArrayList;
import java.util.List;

public class VisitorSpirvInput extends SpirvBaseVisitor<Object> {
    private static final TypeFactory TYPE_FACTORY = TypeFactory.getInstance();
    private static final ExpressionFactory EXPR_FACTORY = ExpressionFactory.getInstance();
    private final ProgramBuilderSpv builder;

    public VisitorSpirvInput(ProgramBuilderSpv builder) {
        this.builder = builder;
    }

    @Override
    public Object visitInitList(SpirvParser.InitListContext ctx) {
        for (SpirvParser.InitContext init : ctx.init()) {
            visit(init);
        }
        return null;
    }

    @Override
    public Object visitInit(SpirvParser.InitContext ctx) {
        String varName = ctx.varName().getText();
        Expression expr = (Expression) visit(ctx.initValue());
        builder.addInputs(varName, expr);
        return visitChildren(ctx);
    }

    @Override
    public Object visitInitBaseValue(SpirvParser.InitBaseValueContext ctx) {
        IntegerType mockType = TYPE_FACTORY.getIntegerType();
        try {
            return EXPR_FACTORY.makeValue(Long.parseLong(ctx.getText()), mockType);
        } catch (ParsingException e) {
            throw new ParsingException("Unsupported value " + ctx.getText());
        }
    }

    @Override
    public Object visitInitCollectionValue(SpirvParser.InitCollectionValueContext ctx) {
        List<Expression> values = new ArrayList<>();
        if (ctx.ModeHeader_TypeVector() != null) {
            // Vector
            for (SpirvParser.InitBaseValueContext initValue : ctx.initBaseValues().initBaseValue()) {
                values.add((Expression) visitInitBaseValue(initValue));
            }
            if (values.stream().map(Expression::getType).distinct().count() != 1) {
                throw new ParsingException("All values in a Vector must have the same type");
            }
            return EXPR_FACTORY.makeArray(values.get(0).getType(), values, false);
        } else {
            // Array, RuntimeArray, or Struct
            for (SpirvParser.InitValueContext initValue : ctx.initValues().initValue()) {
                values.add((Expression) visitInitValue(initValue));
            }
            return EXPR_FACTORY.makeConstruct(values);
        }
    }
}
