package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;

import java.util.Collections;
import java.util.List;
import java.util.Objects;

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

    public Wmm getMemoryModel() { return rel.getMemoryModel(); }

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

    @Override
    public abstract String toString();

    @Override
    public int hashCode() {
        return Objects.hash(rel);
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || obj.getClass() != this.getClass()) {
            return false;
        }
        Axiom other = (Axiom)obj;
        return this.rel.equals(other.rel);
    }


    // ===================== Utility methods ===================
    
    public boolean isEmptiness() {
    	return this instanceof Emptiness;
    }
    
    public boolean isAcyclicity() {
    	return this instanceof Acyclicity;
    }
    
    public boolean isIrreflexivity() {
    	return this instanceof Irreflexivity;
    }
}