package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.Type;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

public final class Extraction implements Expression {

    private final Type type;
    private final int index;
    private final Expression object;

    Extraction(int index, Expression object) {
        checkNotNull(object);
        checkArgument(object.getType() instanceof AggregateType, "Extracting field from a non-aggregate expression.");
        final var aggregateType = (AggregateType) object.getType();
        this.type = aggregateType.getDirectFields().get(index);
        this.index = index;
        this.object = object;
    }

    public int getFieldIndex() {
        return index;
    }

    public Expression getObject() {
        return object;
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
        return object + "[" + index + "]";
    }
}
