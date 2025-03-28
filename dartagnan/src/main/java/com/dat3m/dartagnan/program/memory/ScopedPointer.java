package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.LeafExpressionBase;
import com.dat3m.dartagnan.expression.type.ScopedPointerType;

import java.util.Objects;

public class ScopedPointer extends LeafExpressionBase<ScopedPointerType> {

    private final String id;
    private final Expression address;

    public ScopedPointer(String id, ScopedPointerType type, Expression address) {
        super(type);
        this.id = id;
        this.address = address;
    }

    public String getId() {
        return id;
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
        return Objects.equals(id, that.id) && Objects.equals(address, that.address);
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), id, address);
    }
}
