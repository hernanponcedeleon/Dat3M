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

//    @Override
//    public Expression visitInit(SpirvParser.InitContext ctx) {
//        String varName = ctx.varName().getText();
//        Expression expr = visit(ctx.initValue());
//        builder.addInputs(varName, expr);
//        return visitChildren(ctx);
//    }

    // For Testing purposes -----------------------------------------------------------------------
    @Override
    public Expression visitInit(SpirvParser.InitContext ctx) {
        String varName = ctx.varName().getText();
        Expression expr = visit(ctx.initValue());
        builder.addInputs(varName, expr);
        Type type = expr.getType();
        if (type instanceof IntegerType || type instanceof BConst) {
            MemoryObject memObj = builder.allocateMemory(TYPE_FACTORY.getMemorySizeInBytes(type));
            memObj.setCVar(varName);
            memObj.setInitialValue(0, expr);
        } else if (type instanceof AggregateType) {
            MemoryObject memObj = builder.allocateMemory(TYPE_FACTORY.getMemorySizeInBytes(type));
            memObj.setCVar(varName);
            setAggregateMemory(memObj, 0, (Construction) expr);
        } else {
            throw new ParsingException("Unsupported type " + type);
        }
        builder.addExpression(varName, expr);
        return visitChildren(ctx);
    }
    private int setAggregateMemory(MemoryObject aggregatedMemObj, int cursor, Construction expr) {
        for (Expression e : expr.getArguments()) {
            if (e instanceof Construction) {
                cursor = setAggregateMemory(aggregatedMemObj, cursor, (Construction) e);
            } else {
                aggregatedMemObj.setInitialValue(cursor, e);
                cursor++;
            }
        }
        return cursor;
    }
// --------------------------------------------------------------------------------------------

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
