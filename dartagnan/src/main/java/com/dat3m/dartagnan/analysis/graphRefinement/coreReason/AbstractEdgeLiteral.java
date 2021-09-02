package com.dat3m.dartagnan.analysis.graphRefinement.coreReason;

import com.dat3m.dartagnan.verification.model.Edge;

public abstract class AbstractEdgeLiteral extends AbstractLiteral {
    protected Edge edge;
    protected String name;

    public String getName() {
        return name;
    }

    public Edge getEdge() {
        return edge;
    }

    public AbstractEdgeLiteral(String name, Edge edge) {
        this.edge = edge;
        this.name = name;
    }

    @Override
    public int hashCode() {
        return edge.hashCode() + 31*name.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this)
            return true;
        if (obj == null || obj.getClass() != this.getClass())
            return false;
        AbstractEdgeLiteral other = (AbstractEdgeLiteral)obj;
        // Due to string-interning, we can actually use == for the names.
        return  this.name.equals(other.name) && this.edge.equals(other.edge);
    }

    @Override
    public String toString() {
        return name + "(" + edge.getFirst() + "," + edge.getSecond() + ")";
    }
}
