package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;
import com.google.common.collect.ImmutableList;

import java.util.List;

/** A group of values with no memory size, alignment, or field offsets. */
public final class TupleType implements Type {

    private final ImmutableList<Type> fields;

    TupleType(List<? extends Type> fields) {
        this.fields = ImmutableList.copyOf(fields);
    }

    public ImmutableList<Type> getFields() {
        return fields;
    }

    @Override
    public int hashCode() {
        return fields.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        return this == obj || obj instanceof TupleType other && fields.equals(other.fields);
    }

    @Override
    public String toString() {
        return "tuple" + fields;
    }
}
