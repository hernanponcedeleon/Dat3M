package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;

import java.util.Objects;

public class ArrayType implements Type {

    private final Type elementType;
    private final int numElements;
    private final Integer stride;
    private final Integer alignment;

    ArrayType(Type elementType, int numElements, Integer stride, Integer alignment) {
        this.elementType = elementType;
        this.numElements = numElements;
        this.stride = stride;
        this.alignment = alignment;
    }

    // NOTE: We use empty arrays to represent unknown size.
    // numElements = 0 is commonly used in LLVM to represent unknown sizes,
    // however, even with numElements > 0, the size can be unreliable.
    // see https://llvm.org/docs/LangRef.html#array-type
    public boolean hasKnownNumElements() { return this.numElements >= 0; }
    public int getNumElements() { return this.numElements; }

    public Type getElementType() { return elementType; }

    public Integer getStride() {
        return stride;
    }
    public Integer getAlignment() {
        return alignment;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ArrayType arrayType)) return false;
        return numElements == arrayType.numElements
                && Objects.equals(stride, arrayType.stride)
                && Objects.equals(alignment, arrayType.alignment)
                && Objects.equals(elementType, arrayType.elementType);
    }

    @Override
    public int hashCode() {
        return Objects.hash(elementType, numElements, stride, alignment);
    }

    @Override
    public String toString() {
        String numString = hasKnownNumElements() ? Integer.toString(numElements) : "?";
        if (stride != null) {
            return String.format("[%s x %s]:%s", numString, elementType, stride);
        } else if (alignment != null) {
            return String.format("[%s x %s]:%s", numString, elementType, alignment);
        }
        return String.format("[%s x %s]", numString, elementType);
    }
}
