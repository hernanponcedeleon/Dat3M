package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;

import java.util.Objects;

public class ScopedPointerType extends IntegerType {

    private static final int ARCH_SIZE = TypeFactory.getInstance().getArchType().getBitWidth();

    private final String scopeId;
    private final Type pointedType;
    private final Integer stride;

    ScopedPointerType(String scopeId, Type pointedType, Integer stride) {
        super(ARCH_SIZE);
        this.scopeId = scopeId;
        this.pointedType = pointedType;
        this.stride = stride;
    }

    public String getScopeId() {
        return scopeId;
    }

    public Type getPointedType() {
        return pointedType;
    }

    public Integer getStride() {
        return stride;
    }

    @Override
    public String toString() {
        if (stride != null) {
            return String.format("%s(%s:%s)*", pointedType, scopeId, stride);
        }
        return String.format("%s(%s)*", pointedType, scopeId);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!super.equals(o)) return false;
        if (o instanceof ScopedPointerType that) {
            return Objects.equals(scopeId, that.scopeId)
                    && Objects.equals(pointedType, that.pointedType)
                    && Objects.equals(stride, that.stride);
        }
        return super.equals(o);
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), scopeId, pointedType, stride);
    }
}
