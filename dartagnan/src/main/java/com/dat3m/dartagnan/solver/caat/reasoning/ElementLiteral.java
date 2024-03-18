package com.dat3m.dartagnan.solver.caat.reasoning;

import com.dat3m.dartagnan.solver.caat.predicates.sets.Element;
import com.dat3m.dartagnan.solver.caat.predicates.sets.SetPredicate;

public final class ElementLiteral extends CAATLiteralBase<SetPredicate, Element> {

    public ElementLiteral(SetPredicate set, Element element, boolean isPositive) {
        super(set, element, isPositive);
    }

    @Override
    public ElementLiteral negated() {
        return new ElementLiteral(predicate, data, !isPositive);
    }

    @Override
    public String toString() {
        return getName() + "(" + data + ")";
    }

}
