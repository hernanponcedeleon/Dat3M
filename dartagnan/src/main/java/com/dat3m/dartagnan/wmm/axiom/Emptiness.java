package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.wmm.Relation;

public class Emptiness extends Axiom {

    public Emptiness(Relation rel, boolean negated, boolean flag, boolean invariant) {
        super(rel, negated, flag, invariant);
    }

    public Emptiness(Relation rel, boolean negated, boolean flag) {
        this(rel, negated, flag, false);
    }

    public Emptiness(Relation rel) {
        this(rel, false, false);
    }

    @Override
    protected String getAxiomName() { return "empty"; }

    @Override
    public <T> T accept(Visitor<? extends T> visitor) {
        return visitor.visitEmptiness(this);
    }

}