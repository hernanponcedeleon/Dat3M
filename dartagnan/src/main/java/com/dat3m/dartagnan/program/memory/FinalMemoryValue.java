package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.base.LeafExpressionBase;
import com.dat3m.dartagnan.expression.type.TypeFactory;

// TODO: Should work with an arbitrary pointer rather than "base + offset"
// Represents the final (co-maximal) value at a memory address as if read by a load instruction
// that observed the final store.
public class FinalMemoryValue extends LeafExpressionBase<Type> {

    private final MemoryObject base;
    private final int offset;

    public FinalMemoryValue(Type loadType, MemoryObject base, int offset) {
        super(loadType);
        this.base = base;
        this.offset = offset;
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
        final int accessSize = TypeFactory.getInstance().getMemorySizeInBytes(getType());
        final int lowerByte = offset;
        final int upperByte = offset + accessSize;
        final String baseName = base.toString().substring(1);
        if (base.hasKnownSize() && (lowerByte == 0 && upperByte == base.getKnownSize())) {
            // Access whole range: just print the variable
            return baseName;
        } else {
            // Access subrange: print the subrange
            return String.format("%s[%s..%s]", baseName, lowerByte, upperByte);
        }
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