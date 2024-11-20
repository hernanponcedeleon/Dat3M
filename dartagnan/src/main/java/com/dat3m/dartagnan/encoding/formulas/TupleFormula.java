package com.dat3m.dartagnan.encoding.formulas;

import org.sosy_lab.java_smt.api.Formula;

import java.util.List;
import java.util.stream.Collectors;

/*
    Implementation Note:
    We implement JavaSMT's Formula interface so this appears like a normal formula,
    however, it won't support many of JavaSMT's features like formula traversal.
 */
public class TupleFormula implements Formula {

    final List<Formula> elements;

    TupleFormula(List<Formula> elements) {
        this.elements = elements;
    }

    @Override
    public String toString() {
        return elements.stream()
                .map(Object::toString)
                .collect(Collectors.joining(",", "{ ", " }"));
    }

    @Override
    public int hashCode() {
        return elements.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        } else if (obj == null || obj.getClass() != this.getClass()) {
            return false;
        } else {
            final TupleFormula other = (TupleFormula) obj;
            return this.elements.equals(other.elements);
        }
    }

}
