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
        if (ctx.literalHeaderConstant() != null) {
            // TODO: Integer bit width is hardcoded
            IntegerType type = TYPE_FACTORY.getIntegerType(64);
            return EXPR_FACTORY.makeValue(Long.parseLong(ctx.getText()), type);
        } else if (ctx.headerBoolean() != null) {
            boolean value = ctx.headerBoolean().getText().equals("true");
            return EXPR_FACTORY.makeValue(value);
        } else {
            throw new ParsingException("Unsupported base value" + ctx.getText());
        }
    }

    @Override
    public Object visitInitCollectionVector(SpirvParser.InitCollectionVectorContext ctx) {
        List<Expression> values = new ArrayList<>();
        for (SpirvParser.InitBaseValueContext initBaseValueContext : ctx.initBaseValues().initBaseValue()) {
            values.add((Expression) visitInitBaseValue(initBaseValueContext));
        }
        if (values.stream().map(Expression::getType).distinct().count() != 1) {
            throw new ParsingException("All values in a collection must have the same type");
        }
        return EXPR_FACTORY.makeConstruct(values);
    }

    @Override
    public Object visitInitCollectionStruct(SpirvParser.InitCollectionStructContext ctx) {
        List<Expression> values = new ArrayList<>();
        for (SpirvParser.InitValueContext initValue : ctx.initValues().initValue()) {
            values.add((Expression) visitInitValue(initValue));
        }
        return EXPR_FACTORY.makeConstruct(values);
    }

    @Override
    public Object visitInitCollectionArray(SpirvParser.InitCollectionArrayContext ctx) {
        List<Expression> values = new ArrayList<>();
        for (SpirvParser.InitValueContext initValue : ctx.initValues().initValue()) {
            values.add((Expression) visitInitValue(initValue));
        }
        return EXPR_FACTORY.makeConstruct(values);
    }

    @Override
    public Object visitInitCollectionRuntimeArray(SpirvParser.InitCollectionRuntimeArrayContext ctx) {
        List<Expression> values = new ArrayList<>();
        for (SpirvParser.InitValueContext initValue : ctx.initValues().initValue()) {
            values.add((Expression) visitInitValue(initValue));
        }
        return EXPR_FACTORY.makeConstruct(values);
    }
}
