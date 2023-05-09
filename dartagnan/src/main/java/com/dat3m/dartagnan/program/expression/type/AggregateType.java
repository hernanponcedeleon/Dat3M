package com.dat3m.dartagnan.program.expression.type;

import java.util.List;

public final class AggregateType implements Type {

    private final List<Type> elementTypes;

    AggregateType(List<Type> elementTypes) {
        this.elementTypes = List.copyOf(elementTypes);
    }

    public List<Type> getElementTypes() {
        return elementTypes;
    }
}
