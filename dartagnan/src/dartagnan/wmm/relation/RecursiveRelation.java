package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.wmm.relation.utils.TupleSet;

/**
 *
 * @author Florian Furbach
 */
public class RecursiveRelation extends Relation {

    public static String makeTerm(String name){
        return name;
    }

    private Relation r1;
    private boolean isActive = false;

    public RecursiveRelation(String name) {
        super(name);
        containsRec = true;
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
        if(isActive){
            isActive = false;
            maxTupleSet = r1.getMaxTupleSetRecursive();
            return maxTupleSet;
        }
        return getMaxTupleSet();
    }

    @Override
    public void addEncodeTupleSet(TupleSet tuples){
        encodeTupleSet.addAll(tuples);
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

    public void setConcreteRelation(Relation r1){
        this.r1 = r1;
        r1.setName(name);
        term = r1.term;
    }

    public void setIsActive(){
        isActive = true;
    }

    public void updateEncodeTupleSet(){
        r1.addEncodeTupleSet(encodeTupleSet);
    }
}
