package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.LeafExpressionBase;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;

public class Location extends LeafExpressionBase<IntegerType> {

    private final String name;
    private final MemoryObject base;
    private final int offset;

    public Location(String name, MemoryObject base, int offset) {
        super(TypeFactory.getInstance().getArchType());
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