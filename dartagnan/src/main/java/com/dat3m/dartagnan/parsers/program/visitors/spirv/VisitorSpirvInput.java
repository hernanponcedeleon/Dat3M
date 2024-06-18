package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;

import java.util.HashMap;
import java.util.Map;

public class VisitorSpirvInput extends SpirvBaseVisitor<Expression> {
    private static final TypeFactory TYPE_FACTORY = TypeFactory.getInstance();
    private static final ExpressionFactory EXPR_FACTORY = ExpressionFactory.getInstance();

    private final Map<String, Expression> inputs = new HashMap<>();

    public Map<String, Expression> getInputs() {
        return inputs;
    }

    @Override
    public Expression visitInit(SpirvParser.InitContext ctx) {
        String varName = ctx.varName().getText();
        Expression expr = visit(ctx.initValue());
        addInput(varName, expr);
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

    private void addInput(String name, Expression value) {
        if (inputs.containsKey(name)) {
            throw new ParsingException("Duplicated definition '%s'", name);
        }
        inputs.put(name, value);
    }
}
