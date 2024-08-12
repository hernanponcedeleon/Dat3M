package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.base.LeafExpressionBase;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;

import java.util.Objects;

public class ScopedPointer extends LeafExpressionBase<IntegerType> {

    private final String id;
    private final String scopeId;
    private final Type innerType;
    private final Expression address;

    public ScopedPointer(String id, String scopeId, Type innerType, Expression address) {
        super(TypeFactory.getInstance().getArchType());
        this.id = id;
        this.scopeId = scopeId;
        this.innerType = innerType;
        this.address = address;
    }

    public String getId() {
        return id;
    }

    public String getScopeId() {
        return scopeId;
    }

    public Type getInnerType() {
        return innerType;
    }

    public Expression getAddress() {
        return address;
    }

    @Override
    public ExpressionKind getKind() {
        return ExpressionKind.Other.MEMORY_ADDR;
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return getAddress().accept(visitor);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ScopedPointer that)) return false;
        if (!super.equals(o)) return false;
        return Objects.equals(id, that.id) && Objects.equals(scopeId, that.scopeId) && Objects.equals(innerType, that.innerType) && Objects.equals(address, that.address);
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), id, scopeId, innerType, address);
    }
}
