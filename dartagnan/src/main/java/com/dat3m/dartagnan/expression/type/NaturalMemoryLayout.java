package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;

import java.util.ArrayList;
import java.util.List;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

/**
 * Natural layout policy for frontends that use scalar storage size as alignment.
 * LLVM types must instead use the target's data layout.
 */
public final class NaturalMemoryLayout {

    private static final TypeFactory types = TypeFactory.getInstance();

    private NaturalMemoryLayout() {}

    public static AggregateType getAggregateType(List<Type> fields) {
        return getAggregateType(fields, computeDefaultOffsets(fields));
    }

    public static AggregateType getAggregateType(List<Type> fields, List<Integer> offsets) {
        checkNotNull(fields);
        checkArgument(fields.stream().noneMatch(t -> t == types.getVoidType()), "Void fields are not allowed");
        final int alignment = fields.stream().map(NaturalMemoryLayout::getAlignment).max(Integer::compare).orElse(1);
        return getAggregateType(fields, offsets, alignment);
    }

    public static AggregateType getAggregateType(List<Type> fields, List<Integer> offsets, int alignment) {
        types.checkAggregateLayout(fields, offsets, alignment);
        final int size;
        if (fields.stream().anyMatch(f -> !types.hasKnownSize(f))) {
            size = -1;
        } else if (fields.isEmpty()) {
            size = 0;
        } else {
            final int last = fields.size() - 1;
            size = paddedSize(offsets.get(last) + types.getMemorySizeInBytes(fields.get(last)), alignment);
        }
        return types.getAggregateType(fields, offsets, alignment, size);
    }

    private static List<Integer> computeDefaultOffsets(List<Type> fields) {
        List<Integer> offsets = new ArrayList<>();
        int offset = 0;
        if (!fields.isEmpty()) {
            offset = types.getMemorySizeInBytes(fields.get(0));
            offsets.add(0);
        }
        for (int i = 1; i < fields.size(); i++) {
            offset = paddedSize(offset, getAlignment(fields.get(i)));
            offsets.add(offset);
            offset += types.getMemorySizeInBytes(fields.get(i));
        }
        return offsets;
    }

    private static int getAlignment(Type type) {
        if (type instanceof BooleanType || type instanceof IntegerType || type instanceof FloatType) {
            return types.getMemorySizeInBytes(type);
        }
        if (type instanceof ArrayType arrayType) {
            Integer alignment = arrayType.getAlignment();
            if (alignment != null) {
                return alignment;
            }
            return getAlignment(arrayType.getElementType());
        }
        if (type instanceof AggregateType aType) {
            return aType.getAlignment();
        }
        throw new UnsupportedOperationException("Cannot compute memory layout of type " + type);
    }

    private static int paddedSize(int size, int alignment) {
        return Math.addExact(size, Math.floorMod(-size, alignment));
    }
}
