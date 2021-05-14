package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.utils.dependable.Dependent;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.Collections;
import java.util.List;
import java.util.Objects;

/**
 *
 * @author Florian Furbach
 */
public abstract class Axiom implements Dependent<Relation> {

    protected Relation rel;

    protected VerificationTask task;

    Axiom(Relation rel) {
        this.rel = rel;
    }

    public void initialise(VerificationTask task, Context ctx) {
        this.task = task;
    }

    @Override
    public List<Relation> getDependencies() {
        return Collections.singletonList(rel);
    }

    public Relation getRelation() {
        return rel;
    }

    public BoolExpr encodeRelAndConsistency(Context ctx) {
    	return ctx.mkAnd(rel.encode(ctx), consistent(ctx));
    }
    
    @Override
    public String toString(){
        return _toString();
    }

    public abstract TupleSet getEncodeTupleSet();

    public abstract BoolExpr consistent(Context ctx);

    protected abstract String _toString();

    @Override
    public int hashCode() {
        return Objects.hash(rel);
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null || obj.getClass() != this.getClass())
            return false;
        Axiom other = (Axiom)obj;
        return this.rel.equals(other.rel);
    }


    // ===================== Utility methods ===================
    
    public boolean isEmptiness() {
    	return this instanceof Empty;
    }
    
    public boolean isAcyclicity() {
    	return this instanceof Acyclic;
    }
    
    public boolean isIrreflexivity() {
    	return this instanceof Irreflexive;
    }
}