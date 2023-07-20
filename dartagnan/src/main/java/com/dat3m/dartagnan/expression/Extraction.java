package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.Type;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

public final class Extraction implements Expression {

    private final Type type;
    private final int index;
    private final Expression object;

    Extraction(int index, Expression object) {
        checkNotNull(object);
        final Type objectType = object.getType();
        if (objectType instanceof AggregateType aggregateType) {
            this.type = aggregateType.getDirectFields().get(index);
        } else {
            checkArgument(objectType instanceof ArrayType, "Extracting field from a non-aggregate expression.");
            final var arrayType = (ArrayType) objectType;
            checkArgument(0 <= index && (!arrayType.hasKnownNumElements() || index < arrayType.getNumElements()),
                    "Index %s out of bounds [0,%s].", index, arrayType.getNumElements() - 1);
            this.type = ((ArrayType) object.getType()).getElementType();
        }
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
