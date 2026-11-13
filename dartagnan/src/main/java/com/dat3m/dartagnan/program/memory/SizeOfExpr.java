package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.LeafExpressionBase;
import com.dat3m.dartagnan.expression.type.IntegerType;

// Represents the size in bytes of a memory object, as fixed by the memory layout of the execution.
// For dynamically allocated objects, this is the size at the allocation site.
public class SizeOfExpr extends LeafExpressionBase<IntegerType> {

    private final MemoryObject object;

    public SizeOfExpr(IntegerType type, MemoryObject object) {
        super(type);
        this.object = object;
    }

    public MemoryObject getMemoryObject() {
        return object;
    }

    @Override
    public ExpressionKind getKind() {
        return ExpressionKind.Other.SIZE_OF;
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitSizeOfExpression(this);
    }

    @Override
    public String toString() {
        return String.format("sizeof(%s)", object);
    }

    @Override
    public int hashCode() {
        return 31 * object.hashCode() + 7;
    }

    @Override
    public boolean equals(Object obj) {
        return obj instanceof SizeOfExpr o && object.equals(o.object) && getType().equals(o.getType());
    }
}
