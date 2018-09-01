package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import dartagnan.wmm.EncodingsCAT;
import dartagnan.wmm.relation.utils.Tuple;

import java.util.HashSet;
import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public class EmptyRel extends Relation {

    public EmptyRel() {
        term = "0";
    }

    public EmptyRel(String name) {
        super(name);
        term = "0";
    }

    @Override
    protected BoolExpr encodeBasic(Program program, Context ctx) throws Z3Exception {
        return EncodingsCAT.satEmpty(this.getName(), program.getEventRepository().getEvents(this.eventMask), ctx);
    }

    @Override
    protected BoolExpr encodeApprox(Program program, Context ctx) throws Z3Exception {
        return encodeBasic(program, ctx);
    }

    @Override
    protected BoolExpr encodePredicateBasic(Program program, Context ctx) throws Z3Exception {
        return encodeBasic(program, ctx);
    }

    @Override
    protected BoolExpr encodePredicateApprox(Program program, Context ctx) throws Z3Exception {
        return encodeBasic(program, ctx);
    }

    @Override
    public Set<Tuple> getMaxTupleSet(Program program){
        if(maxTupleSet == null){
            maxTupleSet = new HashSet<>();
        }
        return maxTupleSet;
    }
}
