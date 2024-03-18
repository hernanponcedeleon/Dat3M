package com.dat3m.dartagnan.solver.caat.reasoning;

import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.RelationGraph;

public final class EdgeLiteral extends CAATLiteralBase<RelationGraph, Edge> {

    public EdgeLiteral(RelationGraph relation, Edge edge, boolean isPositive) {
        super(relation, edge, isPositive);
    }

    @Override
    public EdgeLiteral negated() {
        return new EdgeLiteral(predicate, data, !isPositive);
    }

    @Override
    public String toString() {
        return getName() + data;
    }

}