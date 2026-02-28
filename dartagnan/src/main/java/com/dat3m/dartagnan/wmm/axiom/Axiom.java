package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Relation;

import java.util.Collections;
import java.util.List;

public abstract class Axiom implements Constraint {

    protected final Relation rel;
    protected final boolean negated;
    // Marks if the axiom should be use to report properties rather than filter consistency
    protected final boolean flag;
    protected String name;

    Axiom(Relation rel, boolean negated, boolean flag) {
        this.rel = rel;
        this.negated = negated;
        this.flag = flag;
    }

    @Override
    public List<? extends Relation> getConstrainedRelations() {
        return Collections.singletonList(rel);
    }

    public Relation getRelation() {
        return rel;
    }

    public boolean isFlagged() {
        return flag;
    }

    public boolean isNegated() { return negated; }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNameOrTerm() {
        return name != null ? name : toString();
    }

    protected abstract String getAxiomName();

    @Override
    public String toString() {
        return (flag ? "flag " : "") + (negated ? "~" : "") + getAxiomName() + " " + rel.getNameOrTerm()
                + (name != null ? " as " + name : "");
    }

}