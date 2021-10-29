package com.dat3m.dartagnan.analysis.saturation.reasoning;


import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.verification.model.EventData;

public class AddressLiteral extends AbstractLiteral {

    protected EventData e1;
    protected EventData e2;

    public EventData getFirst() { return e1; }
    public EventData getSecond() { return e2; }

    //TODO: This normalization is ugly. We should use a literal factory at some point
    // which should perform such normalization.
    public AddressLiteral(EventData e1, EventData e2) {
        if (e1.getEvent().getCId() > e2.getEvent().getCId()) {
            // We normalize the direction, because loc is symmetric
            this.e1 = e2;
            this.e2 = e1;
        } else {
            this.e1 = e1;
            this.e2 = e2;
        }
    }

    public AddressLiteral(Edge e) {
        this(e.getFirst(), e.getSecond());
    }

    @Override
    public int hashCode() {
        return 31*e1.hashCode() + e2.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || obj.getClass() != getClass()) {
            return false;
        }

        AddressLiteral addrLit = (AddressLiteral) obj;
        return addrLit.negated == negated && addrLit.e1.equals(e1) && addrLit.e2.equals(e2);
    }

    @Override
    public String toString() {
        return String.format("(memAddr(%s) %s memAddr(%s))", e1, negated ? "!=" : "==", e2);
    }

    @Override
    public AddressLiteral getOpposite() {
        AddressLiteral opp = new AddressLiteral(e1, e2);
        opp.negated = !negated;
        return opp;
    }
}
