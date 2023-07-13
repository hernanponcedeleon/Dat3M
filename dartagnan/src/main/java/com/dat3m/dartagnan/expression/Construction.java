package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.TypeFactory;

import java.util.List;
import java.util.stream.Collectors;

import static com.google.common.base.Preconditions.checkNotNull;

public final class Construction implements Expression {

    private final AggregateType type;
    private final List<Expression> arguments;

    Construction(TypeFactory types, List<Expression> arguments) {
        checkNotNull(arguments);
        this.type = types.getAggregateType(arguments.stream().map(Expression::getType).toList());
        this.arguments = List.copyOf(arguments);
    }

    public List<Expression> getArguments() {
        return arguments;
    }

    @Override
    public AggregateType getType() {
        return type;
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        return String.format("{ %s }", arguments.stream().map(Expression::toString).collect(Collectors.joining(", ")));
    }
}
