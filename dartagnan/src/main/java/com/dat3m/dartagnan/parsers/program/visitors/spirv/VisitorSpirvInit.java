package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.expression.Construction;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.ArrayList;
import java.util.List;

import static com.google.common.base.Preconditions.checkState;

public class VisitorSpirvInit extends SpirvBaseVisitor<Object> {
    private static final TypeFactory TYPE_FACTORY = TypeFactory.getInstance();
    private static final ExpressionFactory EXPR_FACTORY = ExpressionFactory.getInstance();
    private final ProgramBuilderSpv builder;

    public VisitorSpirvInit(ProgramBuilderSpv builder) {
        this.builder = builder;
    }

    @Override
    public Object visitInitList(SpirvParser.InitListContext ctx) {
        return this.visitChildren(ctx);
    }

    @Override
    public Object visitInitBase(SpirvParser.InitBaseContext ctx) {
        String varName = ctx.varName().getText();
        Expression value = (Expression) visit(ctx.initBaseValue());
        MemoryObject memObj = builder.allocateMemory(TYPE_FACTORY.getMemorySizeInBytes(value.getType()));
        memObj.setCVar(varName);
        memObj.setInitialValue(0, value);
        builder.addExpression(varName, memObj);
        return null;
    }

    @Override
    public Object visitInitCollectionVector(SpirvParser.InitCollectionVectorContext ctx) {
        String varName = ctx.varName().getText();
        List<Expression> values = new ArrayList<>();
        for (SpirvParser.InitBaseValueContext initBaseValue : ctx.initCollectionValue().initBaseValue()) {
            values.add((Expression) visitInitBaseValue(initBaseValue));
        }
        checkState(values.stream().map(Expression::getType).distinct().count() == 1,
                "All values in a collection must have the same type");
        Type type = values.get(0).getType();
        Construction expr = EXPR_FACTORY.makeArray(type, values, false);
        builder.addExpression(varName, expr);
        return null;
    }

    @Override
    public Object visitInitCollectionArray(SpirvParser.InitCollectionArrayContext ctx) {
        String varName = ctx.varName().getText();
        List<Expression> values = new ArrayList<>();
        for (SpirvParser.InitBaseValueContext initBaseValue : ctx.initCollectionValue().initBaseValue()) {
            values.add((Expression) visitInitBaseValue(initBaseValue));
        }
        checkState(values.stream().map(Expression::getType).distinct().count() == 1,
                "All values in a collection must have the same type");
        Type type = values.get(0).getType();
        Construction expr = EXPR_FACTORY.makeArray(type, values, true);
        MemoryObject memObj = builder.allocateMemory(TYPE_FACTORY.getMemorySizeInBytes(expr.getType()));
        memObj.setCVar(varName);
        for (int i = 0; i < values.size(); i++) {
            memObj.setInitialValue(i, values.get(i));
        }
        builder.addExpression(varName, memObj);
        return null;
    }

    @Override
    public Object visitInitCollectionRuntimeArray(SpirvParser.InitCollectionRuntimeArrayContext ctx) {
        String varName = ctx.varName().getText();
        List<Expression> values = new ArrayList<>();
        for (SpirvParser.InitBaseValueContext initBaseValue : ctx.initCollectionValue().initBaseValue()) {
            values.add((Expression) visitInitBaseValue(initBaseValue));
        }
        checkState(values.stream().map(Expression::getType).distinct().count() == 1,
                "All values in a collection must have the same type");
        Type type = values.get(0).getType();
        Construction expr = EXPR_FACTORY.makeArray(type, values, false);
        builder.addExpression(varName, expr);
        return null;
    }

    @Override
    public Object visitInitCollectionStruct(SpirvParser.InitCollectionStructContext ctx) {
        String varName = ctx.varName().getText();
        List<Expression> values = new ArrayList<>();
        for (SpirvParser.InitBaseValueContext initBaseValue : ctx.initCollectionValue().initBaseValue()) {
            values.add((Expression) visitInitBaseValue(initBaseValue));
        }
        Construction expr = EXPR_FACTORY.makeConstruct(values);
        MemoryObject memObj = builder.allocateMemory(TYPE_FACTORY.getMemorySizeInBytes(expr.getType()));
        memObj.setCVar(varName);
        for (int i = 0; i < values.size(); i++) {
            memObj.setInitialValue(i, values.get(i));
        }
        builder.addExpression(varName, memObj);
        return null;
    }

    @Override
    public Object visitInitBaseValue(SpirvParser.InitBaseValueContext ctx) {
        if (ctx.literalAnnConstant() != null) {
            IntegerType type = TYPE_FACTORY.getIntegerType(64);
            return EXPR_FACTORY.makeValue(Long.parseLong(ctx.getText()), type);
        } else if (ctx.annotationBoolean() != null) {
            boolean value = ctx.annotationBoolean().getText().equals("true");
            return EXPR_FACTORY.makeValue(value);
        } else {
            throw new UnsupportedOperationException("Unsupported base value" + ctx.getText());
        }
    }
}
