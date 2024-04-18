package com.dat3m.dartagnan.solver.caat4wmm.coreReasoning;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.Relation;

import java.util.Objects;

public final class RelLiteral implements CoreLiteral {

    private final Relation relation;
    private final Event e1;
    private final Event e2;
    private final boolean isPositive;
    public RelLiteral(Relation rel, Event e1, Event e2, boolean isPositive) {
        this.relation = rel;
        this.e1 = e1;
        this.e2 = e2;
        this.isPositive = isPositive;
    }

    public Relation getRelation() { return relation; }
    public Event getSource() { return e1; }
    public Event getTarget() { return e2; }

    @Override
    public String getName() {
        return relation.getNameOrTerm();
    }

    @Override
    public boolean isPositive() {
        return isPositive;
    }

    @Override
    public RelLiteral negated() {
        return new RelLiteral(relation, e1, e2, !isPositive);
    }

    @Override
    public String toString() {
        return (isNegative() ? "!" : "") + getName() + "(" + e1.getGlobalId() + "," + e2.getGlobalId() + ")";
    }

    @Override
    public int hashCode() {
        return Objects.hash(relation, e1, e2, isPositive);
    }

    @Override
    public boolean equals(Object obj) {
        return (obj instanceof RelLiteral other
                && this.relation == other.relation
                && this.e1 == other.e1
                && this.e2 == other.e2
                && this.isPositive == other.isPositive);
    }
}
