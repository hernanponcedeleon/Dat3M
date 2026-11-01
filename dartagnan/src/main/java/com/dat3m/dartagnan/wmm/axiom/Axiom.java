package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.wmm.ConstraintBase;
import com.dat3m.dartagnan.wmm.Relation;

import java.util.Collections;
import java.util.List;

import static com.google.common.base.Preconditions.checkArgument;

public abstract class Axiom extends ConstraintBase {

    protected final Relation rel;
    protected final boolean negated;
    // Marks if the axiom should be use to report properties rather than filter consistency
    protected final boolean flag;
    // Marks if the axiom holds in every execution of the anarchic semantics, independently of the other axioms.
    // Invariants are not encoded; they only provide information to the relation analysis.
    // Invariants cannot be written in .cat files; only memory model transformation passes (see InferInvariants)
    // create them, and they are responsible for their correctness: a wrong invariant makes the verification unsound.
    protected final boolean invariant;
    protected String name;

    Axiom(Relation rel, boolean negated, boolean flag, boolean invariant) {
        checkArgument(!(flag && invariant), "An axiom cannot be both flagged and an invariant.");
        this.rel = rel;
        this.negated = negated;
        this.flag = flag;
        this.invariant = invariant;
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

    public boolean isInvariant() { return invariant; }

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
        return (flag ? "flag " : "") + (invariant ? "invariant " : "") + (negated ? "~" : "")
                + getAxiomName() + " " + rel.getNameOrTerm() + (name != null ? " as " + name : "");
    }

}