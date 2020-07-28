package com.dat3m.dartagnan.wmm.relation;

import com.dat3m.dartagnan.utils.EncodingConf;
import com.dat3m.dartagnan.utils.Settings;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.wmm.utils.Utils;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

/**
 *
 * @author Florian Furbach
 */
public class RecursiveRelation extends Relation {

    private Relation r1;
    private boolean doRecurse = false;

    public RecursiveRelation(String name) {
        super(name);
        term = name;
    }

    public static String makeTerm(String name){
        return name;
    }

    public void initialise(Program program, EncodingConf conf, Settings settings){
        if(doRecurse){
            doRecurse = false;
            super.initialise(program, conf, settings);
            r1.initialise(program, conf, settings);
        }
    }

    public void setConcreteRelation(Relation r1){
        r1.isRecursive = true;
        r1.setName(name);
        this.r1 = r1;
        this.isRecursive = true;
        this.term = r1.getTerm();
    }

    public void setDoRecurse(){
        doRecurse = true;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
        }
        return maxTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSetRecursive(){
        if(doRecurse){
            doRecurse = false;
            maxTupleSet = r1.getMaxTupleSetRecursive();
            return maxTupleSet;
        }
        return getMaxTupleSet();
    }

    @Override
    public void addEncodeTupleSet(TupleSet tuples){
        if(encodeTupleSet != tuples){
            encodeTupleSet.addAll(tuples);
        }
        if(doRecurse){
            doRecurse = false;
            r1.addEncodeTupleSet(encodeTupleSet);
        }
    }

    @Override
    public void setRecursiveGroupId(int id){
        if(doRecurse){
            doRecurse = false;
            forceUpdateRecursiveGroupId = true;
            recursiveGroupId = id;
            r1.setRecursiveGroupId(id);
        }
    }

    @Override
    public int updateRecursiveGroupId(int parentId){
        if(forceUpdateRecursiveGroupId){
            forceUpdateRecursiveGroupId = false;
            int r1Id = r1.updateRecursiveGroupId(parentId | recursiveGroupId);
            recursiveGroupId |= r1Id & parentId;
        }
        return recursiveGroupId;
    }

    @Override
    public BoolExpr encode() {
        if(isEncoded){
            return conf.getCtx().mkTrue();
        }
        isEncoded = true;
        return r1.encode();
    }

    @Override
    protected BoolExpr encodeLFP() {
        return r1.encodeLFP();
    }

    @Override
    protected BoolExpr encodeIDL() {
        return r1.encodeIDL();
    }

    @Override
    protected BoolExpr encodeApprox() {
        return r1.encodeApprox();
    }

    @Override
    public BoolExpr encodeIteration(int recGroupId, int iteration){
        if(doRecurse){
            doRecurse = false;
            return r1.encodeIteration(recGroupId, iteration);
        }
        return conf.getCtx().mkTrue();
    }

    public BoolExpr encodeFinalIteration(int iteration){
    	Context ctx = conf.getCtx();
        BoolExpr enc = ctx.mkTrue();
        for(Tuple tuple : encodeTupleSet){
            enc = ctx.mkAnd(enc, ctx.mkEq(
                    Utils.edge(getName(), tuple.getFirst(), tuple.getSecond(), ctx),
                    Utils.edge(getName() + "_" + iteration, tuple.getFirst(), tuple.getSecond(), ctx)
            ));
        }
        return enc;
    }
}
