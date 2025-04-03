package com.dat3m.dartagnan.expression.type;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import com.dat3m.dartagnan.expression.Type;
import com.google.common.collect.ImmutableList;

public class AggregateType implements Type {

    private final ImmutableList<TypeOffset> fields;

    AggregateType(List<? extends Type> fields, List<Integer> offsets) {
        this.fields = IntStream.range(0, fields.size())
                .mapToObj(i -> new TypeOffset(fields.get(i), offsets.get(i)))
                .collect(ImmutableList.toImmutableList());
    }

    public ImmutableList<TypeOffset> getFields() {
        return fields;
    }

    @Override
    public int hashCode() {
        return fields.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        return this == obj || obj instanceof AggregateType o && fields.equals(o.fields);
    }

    @Override
    public String toString() {
        return fields.stream().map(f -> f.offset() + ": " + f.type())
                .collect(Collectors.joining(", ", "{ ", " }"));
    }
}
