package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.base.LeafExpressionBase;

// TODO: Should work with an arbitrary pointer rather than "base + offset"
// Represents the final (co-maximal) value at a memory address as if read by a load instruction
// that observed the final store.
public class FinalMemoryValue extends LeafExpressionBase<Type> {

    private final String name;
    private final MemoryObject base;
    private final int offset;

    public FinalMemoryValue(String displayName, Type loadType, MemoryObject base, int offset) {
        super(loadType);
        this.name = displayName;
        this.base = base;
        this.offset = offset;
    }

    public String getName() {
        return base.getName();
    }

    public MemoryObject getMemoryObject() {
        return base;
    }

    public int getOffset() {
        return offset;
    }

    @Override
    public ExpressionKind getKind() {
        return ExpressionKind.Other.FINAL_MEM_VAL;
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitFinalMemoryValue(this);
    }

    @Override
    public String toString() {
        if (name == null) {
            return String.format("%s[%s]", base, offset);
        }
        return name;
    }

    @Override
    public int hashCode() {
        return base.hashCode() + 31 * offset;
    }

    @Override
    public boolean equals(Object obj) {
        return (obj instanceof FinalMemoryValue o) &&
                base.equals(o.base) && offset == o.offset;
    }
}