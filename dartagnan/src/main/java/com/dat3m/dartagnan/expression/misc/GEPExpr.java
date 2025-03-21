package com.dat3m.dartagnan.expression.misc;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.base.NaryExpressionBase;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;
import com.google.common.collect.ImmutableList;

import java.util.List;

public final class GEPExpr extends NaryExpressionBase<Type, ExpressionKind.Other> {

    private final Type indexingType;

    public GEPExpr(Type indexType, Expression base, List<? extends Expression> offsets) {
        super(resultType(base.getType(), offsets, 0), ExpressionKind.Other.GEP, concat(base, offsets));
        ExpressionHelper.checkExpectedType(base, IntegerType.class);
        this.indexingType = indexType;
    }

    private static Type resultType(Type baseType, List<? extends Expression> offsets, int idx) {
        if (idx == offsets.size()) {
            return baseType;
        }
        if (baseType instanceof ScopedPointerType pType) {
            Type innerType = resultType(pType.getPointedType(), offsets, idx + 1);
            return TypeFactory.getInstance().getScopedPointerType(pType.getScopeId(), innerType);
        }
        if (baseType instanceof ArrayType aType) {
            return resultType(aType.getElementType(), offsets, idx + 1);
        }
        Expression offset = offsets.get(idx);
        if (baseType instanceof AggregateType aType && offset instanceof IntLiteral lit) {
            return resultType(aType.getFields().get(lit.getValueAsInt()).type(), offsets, idx + 1);
        }
        throw new IllegalArgumentException("Indexing with multiple indices into non-aggregate type");
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
