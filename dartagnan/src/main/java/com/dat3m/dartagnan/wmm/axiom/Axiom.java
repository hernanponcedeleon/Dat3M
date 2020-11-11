package com.dat3m.dartagnan.wmm.axiom;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.Objects;

/**
 *
 * @author Florian Furbach
 */
public abstract class Axiom {

    protected Relation rel;

    private boolean negate = false;

    public boolean isNegated() {
        return negate;
    }

    Axiom(Relation rel) {
        this.rel = rel;
    }

    Axiom(Relation rel, boolean negate) {
        this.rel = rel;
        this.negate = negate;
    }

    public Relation getRel() {
        return rel;
    }

    public BoolExpr encodeRelAndConsistency(Context ctx) {
    	return ctx.mkAnd(rel.encode(), consistent(ctx));
    }
    
    public BoolExpr consistent(Context ctx) {
        if(negate){
            return _inconsistent(ctx);
        }
        return _consistent(ctx);
    }

    public BoolExpr inconsistent(Context ctx) {
        if(negate){
            return _consistent(ctx);
        }
        return _inconsistent(ctx);
    }

    @Override
    public String toString(){
        if(negate){
            return "~" + _toString();
        }
        return _toString();
    }

    public abstract TupleSet getEncodeTupleSet();

    protected abstract BoolExpr _consistent(Context ctx);

    protected abstract BoolExpr _inconsistent(Context ctx);

    protected abstract String _toString();

    @Override
    public int hashCode() {
        return Objects.hash(rel, negate);
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null || obj.getClass() != this.getClass())
            return false;
        Axiom other = (Axiom)obj;
        return this.rel.equals(other.rel) && this.negate == other.negate;
    }
}
