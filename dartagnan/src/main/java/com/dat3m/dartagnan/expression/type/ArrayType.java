package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;

public class ArrayType implements Type {

    private final Type elementType;
    private final int numElements;

    ArrayType(Type elementType, int numElements) {
        this.elementType = elementType;
        this.numElements = numElements;
    }

    // NOTE: We use empty arrays to represent unknown size.
    // numElements = 0 is commonly used in LLVM to represent unknown sizes,
    // however, even with numElements > 0, the size can be unreliable.
    // see https://llvm.org/docs/LangRef.html#array-type
    public boolean hasKnownNumElements() { return this.numElements >= 0; }
    public int getNumElements() { return this.numElements; }

    public Type getElementType() { return elementType; }

    @Override
    public boolean equals(Object obj) {
        return this == obj ||
                obj instanceof ArrayType o && elementType.equals(o.elementType) && numElements == o.numElements;
    }

    @Override
    public int hashCode() {
        return 31 * elementType.hashCode() + numElements;
    }

    @Override
    public String toString() {
        return String.format("[%s x %s]", hasKnownNumElements() ? numElements : "?", elementType);
    }
}
