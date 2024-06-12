package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;
import com.google.common.base.Preconditions;

import java.util.List;

import static com.dat3m.dartagnan.expression.type.TypeLayout.paddedSize;

public record TypeOffset(Type type, int offset) {

    public static TypeOffset of(Type type, int index) {
        if (index == 0) {
            return new TypeOffset(type, 0);
        }

        if (type instanceof ArrayType arrayType) {
            final Type elemType = arrayType.getElementType();
            return new TypeOffset(elemType, TypeLayout.of(elemType).totalSizeInBytes() * index);
        } else if (type instanceof AggregateType aggregateType) {
            final List<Type> fields = aggregateType.getDirectFields();
            Preconditions.checkArgument(index < fields.size());
            final TypeLayout prefixLayout = TypeLayout.of(fields.subList(0, index));
            final TypeLayout fieldLayout = TypeLayout.of(fields.get(index));
            final int offset = paddedSize(prefixLayout.unpaddedSize(), fieldLayout.alignment());
            return new TypeOffset(fields.get(index), offset);
        } else {
            final String error = String.format("Cannot compute offset of index %d into type %s.", index, type);
            throw new UnsupportedOperationException(error);
        }
    }

    public static TypeOffset of(Type type, Iterable<Integer> indices) {
        int totalOffset = 0;
        for (int i : indices) {
            final TypeOffset inner = of(type, i);
            type = inner.type();
            totalOffset += inner.offset();
        }

        return new TypeOffset(type, totalOffset);
    }
}
