package com.dat3m.dartagnan.expression.misc;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.base.NaryExpressionBase;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.Type;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public final class GEPExpr extends NaryExpressionBase<Type, ExpressionKind.Other> {

    private final Type indexingType;

    public GEPExpr(Type type, Type indexType, Expression base, List<Expression> offsets) {
        super(type, ExpressionKind.Other.GEP, concat(base, offsets));
        this.indexingType = indexType;
    }

    private static List<Expression> concat(Expression base, List<Expression> offsets) {
        final List<Expression> ops = new ArrayList<>(offsets.size() + 1);
        ops.add(base);
        ops.addAll(offsets);
        return ops;
    }

    public Type getIndexingType() {
        return indexingType;
    }

    public Expression getBase() {
        return operands.get(0);
    }

    public List<Expression> getOffsets() {
        return operands.subList(1, operands.size());
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitGEPExpression(this);
    }

    @Override
    public String toString() {
        return operands.stream().map(Object::toString).collect(Collectors.joining(", ", "GEP(", ")"));
    }
}
