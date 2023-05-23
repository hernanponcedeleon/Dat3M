package com.dat3m.dartagnan.program.expression.type;

import java.util.List;
import java.util.stream.Collectors;

public final class AggregateType implements Type {

    private final List<Type> elementTypes;

    AggregateType(List<Type> elementTypes) {
        this.elementTypes = List.copyOf(elementTypes);
    }

    public List<Type> getElementTypes() {
        return elementTypes;
    }

    @Override
    public String toString() {
        return String.format("{ %s }", elementTypes.stream()
                .map(Type::toString).collect(Collectors.joining(", ")));
    }
}
