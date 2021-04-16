package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.microsoft.z3.BoolExpr;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.microsoft.z3.Context;

//TODO: RelCrit, RelRMW and RelFencerel are strongly static like the other static relations
// It might be reasonable to group them into weakly static relations (or alternatively the other one's into
// strongly static)
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
