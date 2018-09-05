package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.wmm.relation.utils.Tuple;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public class RelDummy extends Relation {

    private Relation r1;
    public boolean isActive = false;

    public static String makeTerm(String name){
        return name;
    }


    public RelDummy(String name) {
        super(name);
        containsRec = true;
    }

    public void setConcreteRelation(Relation r1){
        this.r1 = r1;
        r1.setName(name);
        term = r1.term;
    }

    @Override
    public Set<Tuple> getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new HashSet<>();
        }
        return maxTupleSet;
    }

    @Override
    public Set<Tuple> getMaxTupleSetRecursive(){
        if(isActive){
            isActive = false;
            return r1.getMaxTupleSetRecursive();
        }
        return getMaxTupleSet();
    }

    public void setMaxTupleSet(Set<Tuple> set){
        maxTupleSet = set;
    }

    public void addEncodeTupleSet(Set<Tuple> tuples){
        encodeTupleSet.addAll(tuples);
    }

    // TODO: Set difference
    public Set<Tuple> updateEncodeTupleSet(){
        r1.addEncodeTupleSet(encodeTupleSet);
        return encodeTupleSet;
    }

    // TODO: Set difference and use "encode" of the parent
    @Override
    public BoolExpr encode(Context ctx, Collection<String> encodedRels) throws Z3Exception {
        if(encodedRels != null){
            if(encodedRels.contains(this.getName())){
                return ctx.mkTrue();
            }
        }
        return r1.encode(ctx, encodedRels);
    }

    @Override
    protected BoolExpr encodeBasic(Context ctx) throws Z3Exception {
        return r1.encodeBasic(ctx);
    }

    @Override
    protected BoolExpr encodeApprox(Context ctx) throws Z3Exception {
        return r1.encodeApprox(ctx);
    }
}
