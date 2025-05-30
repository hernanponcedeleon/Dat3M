package com.dat3m.dartagnan.expression.misc;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.base.NaryExpressionBase;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableList;

import java.util.List;

import static com.dat3m.dartagnan.expression.utils.ExpressionHelper.isAggregateLike;

public final class GEPExpr extends NaryExpressionBase<Type, ExpressionKind.Other> {

    private final Type indexingType;
    private final Integer stride;

    public GEPExpr(Type indexType, Expression base, List<? extends Expression> offsets, Integer stride) {
        super(base.getType(), ExpressionKind.Other.GEP, concat(base, offsets));
        ExpressionHelper.checkExpectedType(base, IntegerType.class);
        if (offsets.size() > 1) {
            Preconditions.checkArgument(isAggregateLike(indexType), "Indexing with multiple indices into non-aggregate type.");
        }
        this.indexingType = indexType;
        this.stride = stride;
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

    public Integer getStride() {
        return stride;
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitGEPExpression(this);
    }
}
