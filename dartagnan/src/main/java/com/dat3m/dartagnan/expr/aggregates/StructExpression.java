package com.dat3m.dartagnan.expr.aggregates;

import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.expr.ExpressionKind;
import com.dat3m.dartagnan.expr.ExpressionVisitor;
import com.dat3m.dartagnan.expr.Type;
import com.dat3m.dartagnan.expr.helper.ExpressionBase;
import com.dat3m.dartagnan.expr.types.AggregateType;
import com.google.common.collect.Iterables;

import java.util.Arrays;
import java.util.List;
import java.util.Objects;

public class StructExpression extends ExpressionBase<AggregateType, ExpressionKind.Aggregates> {

    protected StructExpression(AggregateType type, List<Expression> expressions) {
        super(type, ExpressionKind.Aggregates.AGGREGATE, expressions);
    }

    public static StructExpression create(List<Expression> expressions) {
        final Type[] types = expressions.stream().map(Expression::getType).toArray(Type[]::new);
        return new StructExpression(AggregateType.get(types), expressions);
    }

    public static StructExpression create(Expression... expressions) {
        return create(Arrays.asList(expressions));
    }

    @Override
    public String toString() {
        return String.format("(%s)", String.join(", ", Iterables.transform(getOperands(), Objects::toString)));
    }

    @Override
    public <TRet> TRet accept(ExpressionVisitor<TRet> visitor) {
        return visitor.visitStructExpression(this);
    }
}
