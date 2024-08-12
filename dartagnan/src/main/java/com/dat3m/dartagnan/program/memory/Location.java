package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.base.LeafExpressionBase;

// TODO: Should be replaced with a Pointer class
public class Location extends LeafExpressionBase<Type> {

    private final String name;
    private final MemoryObject base;
    private final int offset;

    public Location(String name, Type type, MemoryObject base, int offset) {
        super(type);
        this.name = name;
        this.base = base;
        this.offset = offset;
    }

    public String getName() {
        return name;
    }

    public MemoryObject getMemoryObject() {
        return base;
    }

    public int getOffset() {
        return offset;
    }

    @Override
    public ExpressionKind getKind() {
        return ExpressionKind.Other.MEMORY_ADDR;
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitLocation(this);
    }

    @Override
    public String toString() {
        return name;
    }

    @Override
    public int hashCode() {
        return base.hashCode() + offset;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        Location o = (Location) obj;
        return base.equals(o.base) && offset == o.offset;
    }
}