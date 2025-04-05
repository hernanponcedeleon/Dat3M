package com.dat3m.dartagnan.expression.misc;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.base.NaryExpressionBase;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableList;

import java.util.List;

public final class GEPExpr extends NaryExpressionBase<Type, ExpressionKind.Other> {

    private final Type indexingType;

    public GEPExpr(PointerType type, Type indexType, Expression base, List<? extends Expression> offsets) {
        super(type, ExpressionKind.Other.GEP, concat(base, offsets));
        ExpressionHelper.checkExpectedType(base, IntegerType.class);
        if (offsets.size() > 1) {
            Preconditions.checkArgument(indexType instanceof AggregateType || indexType instanceof ArrayType,
                    "Indexing with multiple indices into non-aggregate type.");
        }
        this.indexingType = indexType;
    }

    private static ImmutableList<Expression> concat(Expression base, List<? extends Expression> offsets) {
        return ImmutableList.<Expression>builderWithExpectedSize(offsets.size() + 1)
                .add(base)
                .addAll(offsets)
                .build();
    }

    public Type getIndexingType() {
        return indexingType;
    }

    public Expression getBase() {
        return operands.get(0);
    }

    public ImmutableList<Expression> getOffsets() {
        return operands.subList(1, operands.size());
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitGEPExpression(this);
    }
}
