package com.dat3m.dartagnan.expression.type;

public class ArrayType implements Type {

    private final Type elementType;
    private final int numElements;

    ArrayType(Type elementType, int numElements) {
        this.elementType  = elementType;
        this.numElements = numElements;
    }

    // NOTE: We use empty arrays to represent unknown size.
    // numElements = 0 is commonly used in LLVM to represent unknown sizes,
    // however, even with numElements > 0, the sizes
    public boolean hasKnownNumElements() { return this.numElements > 0; }
    public int getNumElements() { return this.numElements; }

    public Type getElementType() { return elementType; }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        } else if (obj == null || this.getClass() != obj.getClass()) {
            return false;
        }
        ArrayType other = (ArrayType) obj;
        return this.elementType == other.elementType && this.numElements == other.numElements;
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