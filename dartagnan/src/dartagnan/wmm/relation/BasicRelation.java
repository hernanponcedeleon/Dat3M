package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import dartagnan.wmm.relation.utils.Tuple;

import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public class BasicRelation extends Relation {

    public BasicRelation(String name) {
        term = name;
    }

    @Override
    protected BoolExpr encodeBasic(Program program, Context ctx) throws Z3Exception {
        return ctx.mkTrue();
    }

    @Override
    protected BoolExpr encodeApprox(Program program, Context ctx) throws Z3Exception {
        return ctx.mkTrue();
    }

    @Override
    public Set<Tuple> getMaxTupleSet(Program program){
        throw new RuntimeException("not implemented");
    }
}
