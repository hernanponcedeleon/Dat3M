package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.microsoft.z3.BoolExpr;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.microsoft.z3.Context;

//TODO(TH): RelCrit, RelRMW and RelFencerel are NOT strongly static like the other static relations
// It might be reasonable to group them into weakly static relations (or alternatively the other one's into
// strongly static)
// Explanation of these ideas:
// A relation is static IFF its edges are completely determined by the set of executed events
// (irrespective of rf, co, po and any values/addresses of the events)
// We call it "strongly static", if an edge (e1, e2) exists IFF both e1 and e2 are executed
// We call it "weakly static", if the existence of edge (e1, e2) depends on other possibly other events
// E.g. RelFenceRel is weakly static since (e1, e2) exists IFF there exists a fence e3 between e1 and e2.
// (It is a composition of the strongly static relations (po & _ x F) and po)
public abstract class StaticRelation extends Relation {

    public StaticRelation() {
        super();
    }

    public StaticRelation(String name) {
        super(name);
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            minTupleSet = getMaxTupleSet();
        }
        return minTupleSet;
    }

    @Override
    protected BoolExpr encodeApprox(Context ctx) {
        BoolExpr enc = ctx.mkTrue();
        for(Tuple tuple : encodeTupleSet) {
            BoolExpr rel = this.getSMTVar(tuple, ctx);
            enc = ctx.mkAnd(enc, ctx.mkEq(rel, ctx.mkAnd(getExecPair(tuple, ctx))));
        }
        return enc;
    }
}
