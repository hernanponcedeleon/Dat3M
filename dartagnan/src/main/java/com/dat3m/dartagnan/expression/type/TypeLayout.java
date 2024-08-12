package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;
import com.google.common.math.IntMath;

import java.math.RoundingMode;

public record TypeLayout(int unpaddedSize, int alignment) {

    public int totalSizeInBytes() { return paddedSize(unpaddedSize, alignment); }

    @Override
    public String toString() {
        return String.format("[totalSize = %s bytes, unpaddedSize = %s bytes, alignment = %s bytes]",
                totalSizeInBytes(), unpaddedSize(), alignment());
    }

    public static TypeLayout of(Type type) {
        final int unpaddedSize;
        final int alignment;

        // For primitives, we assume that size and alignment requirement coincide
        if (type instanceof BooleanType) {
            unpaddedSize = 1;
            alignment = unpaddedSize;
        } else if (type instanceof IntegerType integerType) {
            unpaddedSize = IntMath.divide(integerType.getBitWidth(), 8, RoundingMode.CEILING);
            alignment = unpaddedSize;
        } else if (type instanceof FloatType floatType) {
            unpaddedSize = IntMath.divide(floatType.getBitWidth(), 8, RoundingMode.CEILING);
            alignment = unpaddedSize;
        } else if (type instanceof ArrayType arrayType) {
            final TypeLayout elemTypeLayout = of(arrayType.getElementType());
            unpaddedSize = elemTypeLayout.totalSizeInBytes() * arrayType.getNumElements();
            alignment = elemTypeLayout.alignment();
        } else if (type instanceof AggregateType aggregateType) {
            return of(aggregateType.getDirectFields());
        } else {
            throw new UnsupportedOperationException("Cannot compute memory layout of type " + type);
        }

        return new TypeLayout(unpaddedSize, alignment);
    }

    public static TypeLayout of(Iterable<Type> aggregate) {
        int aggregateSize = 0;
        int maxAlignment = 1;
        for (Type fieldType : aggregate) {
            final TypeLayout layout = of(fieldType);
            aggregateSize = paddedSize(aggregateSize, layout.alignment()) + layout.totalSizeInBytes();
            maxAlignment = Math.max(maxAlignment, layout.alignment());
        }
        return new TypeLayout(aggregateSize, maxAlignment);
    }

    public static int paddedSize(int size, int alignment) {
        final int mod = size % alignment;
        final int padding = mod == 0 ? 0 : (alignment - mod);
        return size + padding;
    }

}
