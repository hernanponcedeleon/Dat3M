package com.dat3m.dartagnan.expression.misc;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.base.NaryExpressionBase;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;
import com.google.common.base.Preconditions;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public final class GEPExpr extends NaryExpressionBase<Type, ExpressionKind.Other> {

    private final Type indexingType;

    public GEPExpr(Type indexType, Expression base, List<Expression> offsets) {
        super(base.getType(), ExpressionKind.Other.GEP, concat(base, offsets));
        ExpressionHelper.checkExpectedType(base, IntegerType.class);
        if (offsets.size() > 1) {
            Preconditions.checkArgument(indexType instanceof AggregateType || indexType instanceof ArrayType,
                    "Indexing with multiple indices into non-aggregate type.");
        }
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
