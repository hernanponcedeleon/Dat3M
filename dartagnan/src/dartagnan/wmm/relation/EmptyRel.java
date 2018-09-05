package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.wmm.EncodingsCAT;
import dartagnan.wmm.relation.utils.Tuple;

import java.util.HashSet;
import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public class EmptyRel extends Relation {

    public EmptyRel(String name) {
        super(name);
        term = name;
    }

    @Override
    protected BoolExpr encodeBasic(Context ctx) throws Z3Exception {
        return EncodingsCAT.satEmpty(this.getName(), program.getEventRepository().getEvents(this.eventMask), ctx);
    }

    @Override
    protected BoolExpr encodeApprox(Context ctx) throws Z3Exception {
        return encodeBasic(ctx);
    }

    @Override
    protected BoolExpr encodePredicateBasic(Context ctx) throws Z3Exception {
        return encodeBasic(ctx);
    }

    @Override
    protected BoolExpr encodePredicateApprox(Context ctx) throws Z3Exception {
        return encodeBasic(ctx);
    }

    @Override
    public Set<Tuple> getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new HashSet<>();
        }
        return maxTupleSet;
    }
}
