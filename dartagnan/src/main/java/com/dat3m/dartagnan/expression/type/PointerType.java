package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;

import java.util.Objects;

public class PointerType  extends IntegerType {

    private static final int ARCH_SIZE = TypeFactory.getInstance().getArchType().getBitWidth();

    protected final Type pointedType;

    PointerType(Type pointedType) {
        super(ARCH_SIZE);
        this.pointedType = pointedType;
    }

    public Type getPointedType() {
        return pointedType;
    }

    @Override
    public String toString() {
        return pointedType.toString() + "*";
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o instanceof PointerType that) {
            return Objects.equals(pointedType, that.pointedType);
        }
        return super.equals(o);
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), pointedType);
    }
}
