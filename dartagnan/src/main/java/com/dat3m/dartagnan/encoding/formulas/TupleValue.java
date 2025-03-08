package com.dat3m.dartagnan.encoding.formulas;

import java.util.List;
import java.util.stream.Collectors;

/*
    Simple representation of values of TupleFormula
 */
public record TupleValue(List<?> values) {
    @Override
    public String toString() {
        return values.stream().map(Object::toString).collect(Collectors.joining(", ", "( ", " )"));
    }
}
