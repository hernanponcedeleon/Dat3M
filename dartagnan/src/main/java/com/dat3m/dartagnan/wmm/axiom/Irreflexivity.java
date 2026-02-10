package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.wmm.Relation;

public class Irreflexivity extends Axiom {

    public Irreflexivity(Relation rel, boolean negated, boolean flag) {
        super(Relation.checkIsRelation(rel), negated, flag);
    }

    public Irreflexivity(Relation rel) {
        this(rel, false, false);
    }

    @Override
    public <T> T accept(Visitor<? extends T> visitor) {
        return visitor.visitIrreflexivity(this);
    }

    @Override
    public String toString() {
        return (flag ? "flag " : "") + (negated ? "~" : "") + "irreflexive " + rel.getNameOrTerm();
    }
}