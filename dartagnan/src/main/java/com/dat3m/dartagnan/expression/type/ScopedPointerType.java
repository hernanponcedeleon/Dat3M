package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;

import java.util.Objects;

public class ScopedPointerType extends IntegerType {

    private final String scopeId;
    private final Type pointedType;

    ScopedPointerType(String scopeId, Type pointedType) {
        super(64);
        this.scopeId = scopeId;
        this.pointedType = pointedType;
    }

    public String getScopeId() {
        return scopeId;
    }

    public Type getPointedType() {
        return pointedType;
    }

    @Override
    public String toString() {
        return String.format("%s(%s)*", pointedType.toString(), scopeId);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ScopedPointerType that)) return false;
        if (!super.equals(o)) return false;
        return Objects.equals(scopeId, that.scopeId) && Objects.equals(pointedType, that.pointedType);
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), scopeId, pointedType);
    }
}
