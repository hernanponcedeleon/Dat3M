package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.ArrayList;
import java.util.List;

public class VisitorSpirvInit extends SpirvBaseVisitor<Object> {
    private static final TypeFactory TYPE_FACTORY = TypeFactory.getInstance();
    private static final ExpressionFactory EXPR_FACTORY = ExpressionFactory.getInstance();
    private final ProgramBuilderSpv builder;

    public VisitorSpirvInit(ProgramBuilderSpv builder) {
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
        Type type = expr.getType();
        if (type instanceof IntegerType || type instanceof BConst) {
            MemoryObject memObj = builder.allocateMemory(TYPE_FACTORY.getMemorySizeInBytes(type));
            memObj.setCVar(varName);
            memObj.setInitialValue(0, expr);
        } else if (type instanceof ArrayType) {
            MemoryObject memObj = builder.allocateMemory(TYPE_FACTORY.getMemorySizeInBytes(type));
            memObj.setCVar(varName);
            for (int i = 0; i < ((ArrayType) type).getNumElements(); i++) {
                memObj.setInitialValue(i, ((Construction) expr).getArguments().get(i));
            }
        } else if (type instanceof AggregateType) { // TODO: RuntimeArray should not allocate memory
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

    @Override
    public Object visitInitBaseValue(SpirvParser.InitBaseValueContext ctx) {
        IntegerType type = TYPE_FACTORY.getIntegerType(64);
        try {
            return EXPR_FACTORY.makeValue(Long.parseLong(ctx.getText()), type);
        } catch (ParsingException e) {
            throw new ParsingException("Unsupported value " + ctx.getText());
        }
    }

    @Override
    public Object visitInitCollectionValue(SpirvParser.InitCollectionValueContext ctx) {
        List<Expression> values = new ArrayList<>();
        if (ctx.ModeHeader_TypeVector() != null) {
            for (SpirvParser.InitBaseValueContext initValue : ctx.initBaseValues().initBaseValue()) {
                values.add((Expression) visitInitBaseValue(initValue));
            }
            if (values.stream().map(Expression::getType).distinct().count() != 1) {
                throw new ParsingException("All values in a Vector must have the same type");
            }
        } else {
            for (SpirvParser.InitValueContext initValue : ctx.initValues().initValue()) {
                values.add((Expression) visitInitValue(initValue));
            }
        }
        return EXPR_FACTORY.makeConstruct(values);
    }
}
