package com.dat3m.dartagnan.solver.caat4wmm.coreReasoning;


import com.dat3m.dartagnan.program.event.Event;

import java.util.Objects;

public final class AddressLiteral implements CoreLiteral {

    private final Event e1;
    private final Event e2;
    private final boolean isPositive;

    public Event getFirst() { return e1; }
    public Event getSecond() { return e2; }

    //TODO: This normalization is ugly. We should use a literal factory at some point
    // which should perform such normalization.
    public AddressLiteral(Event e1, Event e2, boolean isPositive) {
        this.isPositive = isPositive;
        if (e1.getGlobalId() > e2.getGlobalId()) {
            // We normalize the direction, because loc is symmetric
            this.e1 = e2;
            this.e2 = e1;
        } else {
            this.e1 = e1;
            this.e2 = e2;
        }
    }

    @Override
    public String toString() {
        return String.format("(%s(%s) %s %s(%s))",
                getName(), e1.getGlobalId(), isPositive ? "==" : "!=", getName(), e2.getGlobalId());
    }

    @Override
    public String getName() {
        return "addr";
    }

    @Override
    public boolean isPositive() {
        return isPositive;
    }

    @Override
    public AddressLiteral negated() {
        return new AddressLiteral(e1, e2, !isPositive);
    }

    @Override
    public int hashCode() {
        return Objects.hash(e1, e2, isPositive);
    }

    @Override
    public boolean equals(Object obj) {
        return (obj instanceof AddressLiteral other &&
                this.e1 == other.e1 &&
                this.e2 == other.e2 &&
                this.isPositive == other.isPositive);
    }
}
