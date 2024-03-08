package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.Type;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

public final class Construction implements Expression {

    private final Type type;
    private final List<Expression> arguments;

    Construction(Type type, List<Expression> arguments) {
        this.type = checkNotNull(type);
        checkArgument(type instanceof AggregateType || type instanceof ArrayType,
                "Non-constructible type %s.", type);
        checkArgument(!(type instanceof AggregateType a) ||
                arguments.stream().map(Expression::getType).toList().equals(a.getDirectFields()),
                "Arguments do not match the constructor signature.");
        checkArgument(!(type instanceof ArrayType a) ||
                !a.hasKnownNumElements() ||
                arguments.size() <= a.getNumElements(),
                "Initializing a shorter array from given items");
        this.arguments = List.copyOf(checkNotNull(arguments));
    }

    public List<Expression> getArguments() {
        return arguments;
    }

    @Override
    public Type getType() {
        return type;
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        return arguments.stream().map(Expression::toString).collect(Collectors.joining(", ", "{ ", " }"));
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Construction that = (Construction) o;
        return Objects.equals(type, that.type) && Objects.equals(arguments, that.arguments);
    }

    @Override
    public int hashCode() {
        return Objects.hash(type, arguments);
    }
}
