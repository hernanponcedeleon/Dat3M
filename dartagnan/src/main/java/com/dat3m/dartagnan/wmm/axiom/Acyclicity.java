package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.wmm.Relation;

public class Acyclicity extends Axiom {

    public Acyclicity(Relation rel, boolean negated, boolean flag, boolean invariant) {
        super(Relation.checkIsRelation(rel), negated, flag, invariant);
    }

    public Acyclicity(Relation rel, boolean negated, boolean flag) {
        this(rel, negated, flag, false);
    }

    public Acyclicity(Relation rel) {
        this(rel, false, false);
    }

    @Override
    protected String getAxiomName() { return "acyclic"; }

    @Override
    public <T> T accept(Visitor<? extends T> visitor) {
        return visitor.visitAcyclicity(this);
    }
}