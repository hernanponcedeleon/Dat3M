package com.dat3m.dartagnan.expression.type;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import com.dat3m.dartagnan.expression.Type;
import com.google.common.collect.ImmutableList;

public class AggregateType implements Type {

    private final ImmutableList<TypeOffset> fields;
    private final int alignment;
    private final int size;

    AggregateType(List<? extends Type> fields, List<Integer> offsets, int alignment, int size) {
        this.alignment = alignment;
        this.size = size;
        this.fields = IntStream.range(0, fields.size())
                .mapToObj(i -> new TypeOffset(fields.get(i), offsets.get(i)))
                .collect(ImmutableList.toImmutableList());
    }

    public ImmutableList<TypeOffset> getFields() {
        return fields;
    }

    public int getAlignment() {
        return alignment;
    }

    public int getSize() {
        return size;
    }

    @Override
    public int hashCode() {
        return Objects.hash(fields, alignment, size);
    }

    @Override
    public boolean equals(Object obj) {
        return this == obj || obj instanceof AggregateType o
                && alignment == o.alignment && size == o.size && fields.equals(o.fields);
    }

    @Override
    public String toString() {
        return fields.stream().map(f -> f.offset() + ": " + f.type())
                .collect(Collectors.joining(", ", "{ ", " }"));
    }
}
