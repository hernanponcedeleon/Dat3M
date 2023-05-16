package com.dat3m.dartagnan.prototype.expr.types;

import com.dat3m.dartagnan.prototype.expr.Type;
import com.google.common.collect.Iterables;

import javax.annotation.Nonnegative;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

/*
    Struct type.
    TODO 1: Do we want to add offsets to model both padding and unions?
     TBAA metadata has such offsets. On the other hand, native LLVM structs have their
     padding defined by a separate DataLayout object (unless they are packed structs).

    TODO 2: AggregateType might be reworked to a superclass for "struct type" and "array type"
 */
public class AggregateType implements Type {

    private final Type[] types;
    private final int[] offsets;
    private final int hashCode;
    private final int alignment;
    private final int size;

    protected AggregateType(Type... types) {
        this.types = types;
        this.hashCode = Arrays.hashCode(types);
        this.alignment = Arrays.stream(types)
                .mapToInt(Type::getMemoryAlignment)
                .reduce(1, AggregateType::lowestCommonMultiple);
        this.offsets = new int[types.length];
        int offset = 0;
        for (int i = 0; i < types.length; i++) {
            if (offset != 0) {
                offset = applyPadding(offset, types[i].getMemoryAlignment());
            }
            this.offsets[i] = offset;
            offset += types[i].getMemorySize();
        }
        this.size = types.length == 0 ? 1 : applyPadding(offset, this.alignment);
    }

    @Nonnegative
    private static int lowestCommonMultiple(@Nonnegative int a, @Nonnegative int b) {
        assert a > 0 && b > 0;
        if (a < b) {
            int t = a;
            a = b;
            b = t;
        }
        while (a % b != 0) {
            int t = a + b;
            b = a;
            a = t;
        }
        return a;
    }

    private int applyPadding(int value, int alignment) {
        return alignment + (value - 1) / alignment * alignment;
    }

    private final static HashMap<AggregateType, AggregateType> normalizer = new HashMap<>();

    public static AggregateType get(Type... types) {
        return normalizer.computeIfAbsent(new AggregateType(types), k -> k);
    }

    public List<Type> getAggregatedTypes() { return Arrays.asList(types); }

    @Nonnegative
    public int getFieldOffset(@Nonnegative int index) {
        return offsets[index];
    }

    @Override
    public int getMemoryAlignment() {
        return this.alignment;
    }

    @Override
    public int getMemorySize() {
        return this.size;
    }

    @Override
    public int hashCode() { return this.hashCode; }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        final AggregateType other = (AggregateType) obj;
        return this.hashCode == other.hashCode && Arrays.equals(this.types, other.types);
    }

    @Override
    public String toString() {
        return String.format("{ %s }", String.join(", ", Iterables.transform(Arrays.asList(types), Object::toString)));
    }
}
