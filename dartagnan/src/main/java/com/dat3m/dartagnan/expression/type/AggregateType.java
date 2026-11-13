package com.dat3m.dartagnan.expression.type;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import com.dat3m.dartagnan.expression.Type;
import com.google.common.collect.ImmutableList;

public class AggregateType implements Type {

    private final ImmutableList<TypeOffset> fields;
    private final int allocationSize;

    AggregateType(List<? extends Type> fields, List<Integer> offsets, int allocationSize) {
        this.fields = IntStream.range(0, fields.size())
                .mapToObj(i -> new TypeOffset(fields.get(i), offsets.get(i)))
                .collect(ImmutableList.toImmutableList());
        this.allocationSize = allocationSize;
    }

    public ImmutableList<TypeOffset> getFields() {
        return fields;
    }

    public int getAllocationSize() {
        return allocationSize;
    }

    @Override
    public int hashCode() {
        return Objects.hash(fields.hashCode(), allocationSize);
    }

    @Override
    public boolean equals(Object obj) {
        return this == obj || obj instanceof AggregateType o && fields.equals(o.fields)
                && allocationSize == o.allocationSize;
    }

    @Override
    public String toString() {
        return fields.stream().map(f -> f.offset() + ": " + f.type())
                .collect(Collectors.joining(", ", "{ ", " }"));
    }
}
