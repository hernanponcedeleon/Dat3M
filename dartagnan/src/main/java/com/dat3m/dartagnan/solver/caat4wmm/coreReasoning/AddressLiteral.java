package com.dat3m.dartagnan.solver.caat4wmm.coreReasoning;


import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.logic.AbstractLiteral;
import com.dat3m.dartagnan.wmm.utils.Tuple;

public class AddressLiteral extends AbstractLiteral<CoreLiteral> implements CoreLiteral {

    private static final String NAME = "memAddr";

    protected Event e1;
    protected Event e2;

    public Event getFirst() { return e1; }
    public Event getSecond() { return e2; }

    //TODO: This normalization is ugly. We should use a literal factory at some point
    // which should perform such normalization.
    public AddressLiteral(Event e1, Event e2, boolean isNegative) {
        super(NAME, isNegative);
        if (e1.getGlobalId() > e2.getGlobalId()) {
            // We normalize the direction, because loc is symmetric
            this.e1 = e2;
            this.e2 = e1;
        } else {
            this.e1 = e1;
            this.e2 = e2;
        }
    }

    public AddressLiteral(Tuple e, boolean isNegative) {
        this(e.first(), e.second(), isNegative);
    }

    @Override
    public int hashCode() {
        return baseHashCode() + 31*e1.hashCode() + e2.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || obj.getClass() != getClass()) {
            return false;
        }

        AddressLiteral addrLit = (AddressLiteral) obj;
        return baseEquals(addrLit) && addrLit.e1.equals(e1) && addrLit.e2.equals(e2);
    }

    @Override
    public String toString() {
        return String.format("(%s(%s) %s %s(%s))", NAME, e1.getGlobalId(), isNegative ? "!=" : "==", NAME, e2.getGlobalId());
    }

    @Override
    public AddressLiteral negated() {
        return new AddressLiteral(e1, e2, !isNegative);
    }
}
