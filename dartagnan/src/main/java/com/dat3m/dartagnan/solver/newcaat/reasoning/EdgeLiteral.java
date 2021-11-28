package com.dat3m.dartagnan.solver.newcaat.reasoning;

import com.dat3m.dartagnan.solver.newcaat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.utils.logic.AbstractDataLiteral;

public class EdgeLiteral extends AbstractDataLiteral<CAATLiteral, Edge> implements CAATLiteral {

    public Edge getEdge() {
        return data;
    }

    public EdgeLiteral(String name, Edge edge, boolean isNegative) {
        super(name, edge, isNegative);
    }

    @Override
    public EdgeLiteral negated() {
        return new EdgeLiteral(name, data, !isNegative);
    }

    @Override
    public String toString() {
        return toStringBase() + data.toString();
    }

}
