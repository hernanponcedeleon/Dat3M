package com.dat3m.dartagnan.prototype.expr.types;

import com.dat3m.dartagnan.prototype.expr.Type;
import com.google.common.base.Preconditions;

import java.util.HashMap;

public class ArrayType implements Type {

    private final Type elementType;
    private final int numElements;

    private ArrayType(Type elementType, int numElements) {
        this.elementType  = elementType;
        this.numElements = numElements;
    }

    private final static HashMap<ArrayType, ArrayType> normalizer = new HashMap<>();
    public static ArrayType get(Type elementType, int numElements) {
        Preconditions.checkNotNull(elementType);
        Preconditions.checkArgument(numElements >= 0);
        return normalizer.computeIfAbsent(new ArrayType(elementType, numElements), k -> k);
    }

    public static ArrayType getWithUnknownSize(Type elementType) {
        return get(elementType, 0);
    }

    // NOTE: We use empty arrays to represent unknown size.
    // numElements = 0 is commonly used in LLVM to represent unknown sizes,
    // however, even with numElements > 0, the sizes
    public boolean hasKnownNumElements() { return this.numElements > 0; }
    public int getNumElements() { return this.numElements; }

    public Type getElementType() { return elementType; }

    public ArrayType withUnknownNumElements() {
        return hasKnownNumElements() ? get(elementType, 0) : this;
    }

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

    @Override
    public int getMemoryAlignment() {
        return elementType.getMemoryAlignment();
    }

    @Override
    public int getMemorySize() {
        // NOTE: This may not be the actual size of the array in memory
        return elementType.getMemorySize() * numElements;
    }
}
