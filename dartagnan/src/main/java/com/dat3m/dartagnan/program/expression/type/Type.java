package com.dat3m.dartagnan.program.expression.type;

public interface Type {

    default boolean isLeafType() {
        return this instanceof BooleanType ||
                this instanceof NumberType ||
                this instanceof BoundedIntegerType ||
                this instanceof PointerType;
    }
}
