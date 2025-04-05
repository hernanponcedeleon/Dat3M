package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;

import java.util.Objects;

public class ScopedPointerType extends PointerType {

    private final String scopeId;

    ScopedPointerType(String scopeId, Type pointedType) {
        super(pointedType);
        this.scopeId = scopeId;
    }

    public String getScopeId() {
        return scopeId;
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
        return Objects.equals(scopeId, that.scopeId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), scopeId);
    }
}
