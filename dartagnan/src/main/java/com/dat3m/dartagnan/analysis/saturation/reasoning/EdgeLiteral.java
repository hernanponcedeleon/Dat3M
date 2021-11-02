package com.dat3m.dartagnan.analysis.saturation.reasoning;

import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.Edge;

public class EdgeLiteral extends AbstractLiteral {
    protected Edge edge;
    protected String name;

    public String getName() {
        return name;
    }

    public Edge getEdge() {
        return edge;
    }

    public EdgeLiteral(String name, Edge edge) {
        this.edge = edge;
        this.name = name;
    }

    @Override
    public EdgeLiteral getOpposite() {
        EdgeLiteral opp = new EdgeLiteral(name, edge);
        opp.negated = !negated;
        return opp;
    }

    @Override
    public int hashCode() {
        return edge.hashCode() + 31*name.hashCode() + 3*Boolean.hashCode(negated);
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        } else if (obj == null || obj.getClass() != this.getClass()) {
            return false;
        }
        EdgeLiteral other = (EdgeLiteral)obj;
        return this.negated == other.negated && this.name.equals(other.name) && this.edge.equals(other.edge);
    }

    @Override
    public String toString() {
        return String.format("%s%s(%s,%s)", negated ? "~" : "", name, getEdge().getFirst(), edge.getSecond());
    }

}
