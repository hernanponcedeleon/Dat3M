package com.dat3m.dartagnan.wmm.axiom;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.dat3m.dartagnan.utils.Utils;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

/**
 *
 * @author Florian Furbach
 */
public class Irreflexive extends Axiom {

    public Irreflexive(Relation rel) {
        super(rel);
    }

    public Irreflexive(Relation rel, boolean negate) {
        super(rel, negate);
    }

    @Override
    public TupleSet getEncodeTupleSet(){
        TupleSet set = new TupleSet();
        for(Tuple tuple : rel.getMaxTupleSet()){
            if(tuple.getFirst().getEId() == tuple.getSecond().getEId()){
                set.add(tuple);
            }
        }
        return set;
    }

    @Override
    protected BoolExpr _consistent(Context ctx) {
        BoolExpr enc = ctx.mkTrue();
        for(Tuple tuple : rel.getEncodeTupleSet()){
            if(tuple.getFirst().getEId() == tuple.getSecond().getEId()){
                enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge(rel.getName(), tuple.getFirst(), tuple.getFirst(), ctx)));
            }
        }
        return enc;
    }

    @Override
    protected BoolExpr _inconsistent(Context ctx) {
        BoolExpr enc = ctx.mkTrue();
        for(Tuple tuple : rel.getEncodeTupleSet()){
            if(tuple.getFirst().getEId() == tuple.getSecond().getEId()){
                enc = ctx.mkOr(enc, Utils.edge(rel.getName(), tuple.getFirst(), tuple.getFirst(), ctx));
            }
        }
        return enc;
    }

    @Override
    protected String _toString() {
        return "irreflexive " + rel.getName();
    }
}
