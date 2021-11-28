package com.dat3m.dartagnan.solver.newcaat.reasoning;

import com.dat3m.dartagnan.solver.newcaat.predicates.sets.Element;
import com.dat3m.dartagnan.utils.logic.AbstractDataLiteral;

public class ElementLiteral extends AbstractDataLiteral<CAATLiteral, Element> implements CAATLiteral {

    public Element getElement() {
        return data;
    }

    public ElementLiteral(String name, Element ele, boolean isNegative) {
        super(name, ele, isNegative);
    }

    @Override
    public ElementLiteral negated() {
        return new ElementLiteral(name, data, !isNegative);
    }

    @Override
    public String toString() {
        return toStringBase() + "(" + data + ")";
    }

}
