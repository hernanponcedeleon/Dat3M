package com.dat3m.dartagnan.wmm.relation.unary;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.collect.Sets;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public class RelDomainIdentity extends UnaryRelation {

    public static String makeTerm(Relation r1){
        return "[domain(" + r1.getName() + ")]";
    }

    public RelDomainIdentity(Relation r1){
        super(r1);
        term = makeTerm(r1);
    }

    public RelDomainIdentity(Relation r1, String name) {
        super(r1, name);
        term = makeTerm(r1);
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            minTupleSet = r1.getMinTupleSet().mapped(t -> new Tuple(t.getFirst(), t.getFirst()));
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = r1.getMaxTupleSet().mapped(t -> new Tuple(t.getFirst(), t.getFirst()));
        }
        return maxTupleSet;
    }

    @Override
    public void addEncodeTupleSet(TupleSet tuples){
        TupleSet activeSet = new TupleSet(Sets.intersection(Sets.difference(tuples, encodeTupleSet), maxTupleSet));
        encodeTupleSet.addAll(activeSet);

        //TODO: Optimize using minSets (but no CAT uses this anyway)
        if(!activeSet.isEmpty()){
            TupleSet r1Set = new TupleSet();
            for(Tuple tuple : activeSet){
                r1Set.addAll(r1.getMaxTupleSet().getByFirst(tuple.getFirst()));

            }
            r1.addEncodeTupleSet(r1Set);
        }
    }

    @Override
    protected BoolExpr encodeApprox(Context ctx) {
        BoolExpr enc = ctx.mkTrue();
        for(Tuple tuple1 : encodeTupleSet){
            Event e = tuple1.getFirst();
            BoolExpr opt = ctx.mkFalse();
            //TODO: Optimize using minSets (but no CAT uses this anyway)
            for(Tuple tuple2 : r1.getMaxTupleSet().getByFirst(e)){
                opt = ctx.mkOr(r1.getSMTVar(e, tuple2.getSecond(), ctx));
            }
            enc = ctx.mkAnd(enc, ctx.mkEq(this.getSMTVar(e, e, ctx), opt));
        }
        return enc;
    }
}
