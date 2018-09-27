package dartagnan.wmm.relation.binary;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Z3Exception;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.utils.TupleSet;

/**
 *
 * @author Florian Furbach
 */
public abstract class BinaryRelation extends Relation {

    protected Relation r1;
    protected Relation r2;

    BinaryRelation(Relation r1, Relation r2) {
        this.r1 = r1;
        this.r2 = r2;
    }

    BinaryRelation(Relation r1, Relation r2, String name) {
        super(name);
        this.r1 = r1;
        this.r2 = r2;
    }

    @Override
    public int updateRecursiveGroupId(int parentId){
        if(recursiveGroupId == 0 || forceUpdateRecursiveGroupId){
            forceUpdateRecursiveGroupId = false;
            int r1Id = r1.updateRecursiveGroupId(parentId | recursiveGroupId);
            int r2Id = r2.updateRecursiveGroupId(parentId | recursiveGroupId);
            recursiveGroupId |= (r1Id | r2Id) & parentId;
        }
        return recursiveGroupId;
    }

    @Override
    public TupleSet getMaxTupleSetRecursive(){
        if(recursiveGroupId > 0 && maxTupleSet != null){
            throw new RuntimeException("Method getMaxTupleSetRecursive is not implemented for " + this.getClass().getName());
        }
        return getMaxTupleSet();
    }

    @Override
    public BoolExpr encode() throws Z3Exception {
        if(isEncoded){
            return ctx.mkTrue();
        }
        isEncoded = true;
        return ctx.mkAnd(r1.encode(), r2.encode(), doEncode());
    }

    @Override
    public BoolExpr encodeIteration(int groupId, int iteration){
        if((groupId & recursiveGroupId) > 0){
            throw new RuntimeException("Method encodeIteration is not implemented for " + this.getClass().getName());
        }
        return ctx.mkTrue();
    }
}
