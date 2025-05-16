package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;

public class ArrayType implements Type {

    private final Type elementType;
    private final int numElements;
    private final int alignment;

    ArrayType(Type elementType, int numElements, int alignment) {
        this.elementType = elementType;
        this.numElements = numElements;
        this.alignment = alignment;
    }

    public int getAlignment() {
        // TODO: Auto type makes no sense for arbitrary number of elements of if element size is -1
        return alignment;
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
                obj instanceof ArrayType o
                        && elementType.equals(o.elementType) && numElements == o.numElements && alignment == o.alignment;
    }

    @Override
    public int hashCode() {
        return 31 * elementType.hashCode() + numElements;
    }

    @Override
    public String toString() {
        if (TypeFactory.getInstance().getMemorySizeInBytes(elementType) != alignment) {
            return String.format("[%s x %s]:%s", hasKnownNumElements() ? numElements : "?", elementType, alignment);
        }
        return String.format("[%s x %s]", hasKnownNumElements() ? numElements : "?", elementType);
    }
}
