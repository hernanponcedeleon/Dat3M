package com.dat3m.dartagnan.expression.type;

import java.util.List;
import java.util.stream.Collectors;

public final class AggregateType implements Type {

    private final List<Type> fields;

    AggregateType(List<Type> directFields) {
        this.fields = List.copyOf(directFields);
    }

    public List<Type> getDirectFields() {
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
        return String.format("{ %s }", fields.stream().map(Type::toString).collect(Collectors.joining(", ")));
    }
}
