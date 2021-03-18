package com.dat3m.dartagnan.wmm.relation.unary;

import com.google.common.collect.Sets;
import com.microsoft.z3.BoolExpr;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.utils.Utils;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.microsoft.z3.Context;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public class RelInverse extends UnaryRelation {

    public static String makeTerm(Relation r1){
        return r1.getName() + "^-1";
    }

    public RelInverse(Relation r1){
        super(r1);
        term = makeTerm(r1);
    }

    public RelInverse(Relation r1, String name) {
        super(r1, name);
        term = makeTerm(r1);
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            minTupleSet = new TupleSet();
            r1.getMinTupleSet().stream().map(Tuple::getInverse).forEach(minTupleSet::add);
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            for(Tuple pair : r1.getMaxTupleSet()){
                maxTupleSet.add(new Tuple(pair.getSecond(), pair.getFirst()));
            }
        }
        return maxTupleSet;
    }

    @Override
    public void addEncodeTupleSet(TupleSet tuples){
        Set<Tuple> activeSet = new HashSet<>(tuples);
        activeSet.retainAll(maxTupleSet);
        activeSet.removeAll(encodeTupleSet);
        encodeTupleSet.addAll(activeSet);

        if(!activeSet.isEmpty()){
            TupleSet invSet = new TupleSet();
            for(Tuple pair : activeSet){
                invSet.add(new Tuple(pair.getSecond(), pair.getFirst()));
            }
            r1.addEncodeTupleSet(invSet);
        }
    }

    @Override
    protected BoolExpr encodeApprox(Context ctx) {
        BoolExpr enc = ctx.mkTrue();
        for(Tuple tuple : encodeTupleSet){
            BoolExpr opt = r1.getSMTVar(tuple.getInverse(), ctx);
            enc = ctx.mkAnd(enc, ctx.mkEq(this.getSMTVar(tuple, ctx), opt));
        }
        return enc;
    }
}
    

