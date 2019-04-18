package com.dat3m.dartagnan.wmm.relation.unary;

import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.utils.Utils;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;
import java.util.Map;
import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public class RelTransRef extends RelTrans {

    private TupleSet identityEncodeTupleSet = new TupleSet();
    private TupleSet transEncodeTupleSet = new TupleSet();

    public static String makeTerm(Relation r1){
        return r1.getName() + "^*";
    }

    public RelTransRef(Relation r1) {
        super(r1);
        term = makeTerm(r1);
    }

    public RelTransRef(Relation r1, String name) {
        super(r1, name);
        term = makeTerm(r1);
    }

    @Override
    public void initialise(Program program, Context ctx, Mode mode){
        super.initialise(program, ctx, mode);
        identityEncodeTupleSet = new TupleSet();
        transEncodeTupleSet = new TupleSet();
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            super.getMaxTupleSet();
            for (Map.Entry<Event, Set<Event>> entry : transitiveReachabilityMap.entrySet()) {
                entry.getValue().remove(entry.getKey());
            }
            for(Event e : program.getCache().getEvents(FilterBasic.get(EType.ANY))){
                maxTupleSet.add(new Tuple(e, e));
            }
        }
        return maxTupleSet;
    }

    @Override
    public void addEncodeTupleSet(TupleSet tuples){
        TupleSet activeSet = new TupleSet();
        activeSet.addAll(tuples);
        activeSet.removeAll(encodeTupleSet);
        encodeTupleSet.addAll(activeSet);
        activeSet.retainAll(maxTupleSet);

        for(Tuple tuple : activeSet){
            if(tuple.getFirst().getCId() == tuple.getSecond().getCId()){
                identityEncodeTupleSet.add(tuple);
            }
        }
        activeSet.removeAll(identityEncodeTupleSet);

        TupleSet temp = encodeTupleSet;
        encodeTupleSet = transEncodeTupleSet;
        super.addEncodeTupleSet(activeSet);
        encodeTupleSet = temp;
    }

    @Override
    protected BoolExpr encodeApprox() {
        return invokeEncode("encodeApprox");
    }

    @Override
    protected BoolExpr encodeIDL() {
        return invokeEncode("encodeIDL");
    }

    @Override
    protected BoolExpr encodeLFP() {
        return invokeEncode("encodeLFP");
    }

    private BoolExpr invokeEncode(String methodName){
        try{
            MethodHandle method = MethodHandles.lookup().findSpecial(RelTrans.class, methodName,
                    MethodType.methodType(BoolExpr.class), RelTransRef.class);

            TupleSet temp = encodeTupleSet;
            encodeTupleSet = transEncodeTupleSet;
            BoolExpr enc = (BoolExpr)method.invoke(this);
            encodeTupleSet = temp;

            for(Tuple tuple : identityEncodeTupleSet){
                enc = ctx.mkAnd(enc, Utils.edge(this.getName(), tuple.getFirst(), tuple.getFirst(), ctx));
            }
            return enc;
        } catch (Throwable e){
            e.printStackTrace();
            throw new RuntimeException("Failed to encode relation " + this.getName());
        }
    }
}