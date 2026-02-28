package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.wmm.Relation;

public class Emptiness extends Axiom {

    public Emptiness(Relation rel, boolean negated, boolean flag) {
        super(rel, negated, flag);
    }

    public Emptiness(Relation rel) {
        super(rel, false, false);
    }

    @Override
    protected String getAxiomName() { return "empty"; }

    @Override
    public <T> T accept(Visitor<? extends T> visitor) {
        return visitor.visitEmptiness(this);
    }

}