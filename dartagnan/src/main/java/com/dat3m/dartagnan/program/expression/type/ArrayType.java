package com.dat3m.dartagnan.program.expression.type;

import java.util.OptionalInt;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

public final class ArrayType implements Type {

    private final Type elementType;
    private final int elementCount;

    ArrayType(Type elementType, int elementCount) {
        checkArgument(elementCount >= -1);
        this.elementType = checkNotNull(elementType);
        this.elementCount = elementCount;
    }

    public Type getElementType() {
        return elementType;
    }

    public OptionalInt getElementCount() {
        return elementCount < 0 ? OptionalInt.empty() : OptionalInt.of(elementCount);
    }

    @Override
    public String toString() {
        return String.format("[%s x %s]", getElementCount().isPresent() ? Integer.toString(elementCount) : "?", elementType);
    }
}
