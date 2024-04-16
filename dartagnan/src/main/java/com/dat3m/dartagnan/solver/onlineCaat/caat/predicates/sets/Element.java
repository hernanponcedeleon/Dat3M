package com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.sets;

import com.dat3m.dartagnan.solver.onlineCaat.caat.predicates.AbstractDerivable;

public class Element extends AbstractDerivable implements Comparable<Element> {

    protected final int dId;

    public int getId() { return dId; }

    public Element(int id, int time, int derivLength) {
        super(time, derivLength);
        this.dId = id;
    }

    public Element(int id) {
        this(id, 0, 0);
    }

    @Override
    public Element with(int time, int derivationLength) { return new Element(dId, time, derivLength); }
    @Override
    public Element withTime(int time) { return with(time, derivLength); }
    @Override
    public Element withDerivationLength(int derivationLength) { return with(time, derivationLength); }

    @Override
    public int compareTo(Element o) {
        return dId - o.dId;
    }

    @Override
    public int hashCode() {
        return dId;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        return equals((Element)obj);
    }

    public boolean equals(Element e) {
        return this.dId == e.dId;
    }

    @Override
    public String toString() {
        return Integer.toString(dId);
    }
}
