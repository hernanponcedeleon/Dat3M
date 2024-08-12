package com.dat3m.dartagnan.expression.misc;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.base.NaryExpressionBase;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.ArrayType;

import java.util.List;
import java.util.stream.Collectors;

import static com.google.common.base.Preconditions.checkArgument;

public final class ConstructExpr extends NaryExpressionBase<Type, ExpressionKind.Other> {

    public ConstructExpr(Type type, List<Expression> arguments) {
        super(type, ExpressionKind.Other.CONSTRUCT, List.copyOf(arguments));
        checkArgument(type instanceof AggregateType || type instanceof ArrayType,
                "Non-constructible type %s.", type);
        checkArgument(!(type instanceof AggregateType a) ||
                arguments.stream().map(Expression::getType).toList().equals(a.getDirectFields()),
                "Arguments do not match the constructor signature.");
        checkArgument(!(type instanceof ArrayType a) ||
                !a.hasKnownNumElements() ||
                arguments.size() <= a.getNumElements(),
                "Initializing a shorter array from given items.");
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitConstructExpression(this);
    }

    @Override
    public String toString() {
        return operands.stream().map(Expression::toString).collect(Collectors.joining(", ", "{ ", " }"));
    }
}