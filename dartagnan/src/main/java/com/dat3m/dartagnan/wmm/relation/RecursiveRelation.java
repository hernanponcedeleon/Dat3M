package com.dat3m.dartagnan.wmm.relation;

import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

import java.util.Collections;
import java.util.List;

/**
 *
 * @author Florian Furbach
 */
public class RecursiveRelation extends Relation {

    private Relation r1;
    private boolean doRecurse = false;

    public Relation getInner() {
        return r1;
    }

    @Override
    public List<Relation> getDependencies() {
        return Collections.singletonList(r1);
    }

    public RecursiveRelation(String name) {
        super(name);
        term = name;
    }

    public static String makeTerm(String name){
        return name;
    }

    public void initialise(VerificationTask task, Context ctx){
        if(doRecurse){
            doRecurse = false;
            super.initialise(task, ctx);
            r1.initialise(task, ctx);
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
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            minTupleSet = new TupleSet();
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
        }
        return maxTupleSet;
    }

    @Override
    public TupleSet getMinTupleSetRecursive(){
        if(doRecurse){
            doRecurse = false;
            minTupleSet = r1.getMinTupleSetRecursive();
            return minTupleSet;
        }
        return getMinTupleSet();
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
            //TODO: This encodeTupleSet is never used except to stop this recursion
            // Can it get larger than r1's encodeTupleSet???
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
    public BoolExpr encode(Context ctx) {
        if(isEncoded){
            return ctx.mkTrue();
        }
        isEncoded = true;
        return r1.encode(ctx);
    }

    @Override
    protected BoolExpr encodeApprox(Context ctx) {
        return r1.encodeApprox(ctx);
    }

}
