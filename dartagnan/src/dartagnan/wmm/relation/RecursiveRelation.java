package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.wmm.utils.TupleSet;

/**
 *
 * @author Florian Furbach
 */
public class RecursiveRelation extends Relation {

    private Relation r1;
    private boolean doRecurse = false;

    public RecursiveRelation(String name) {
        super(name);
    }

    public static String makeTerm(String name){
        return name;
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
        forceUpdateRecursiveGroupId = true;
        recursiveGroupId = id;
        r1.setRecursiveGroupId(id);
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
    public BoolExpr encode(Context ctx) throws Z3Exception {
        if(isEncoded){
            return ctx.mkTrue();
        }
        isEncoded = true;
        return r1.encode(ctx);
    }

    @Override
    protected BoolExpr encodeBasic(Context ctx) throws Z3Exception {
        return r1.encodeBasic(ctx);
    }

    @Override
    protected BoolExpr encodeApprox(Context ctx) throws Z3Exception {
        return r1.encodeApprox(ctx);
    }

    @Override
    public BoolExpr encodeIteration(int recGroupId, Context ctx, int iteration){
        return r1.encodeIteration(recGroupId, ctx, iteration);
    }
}
