package porthosc.memorymodels.relations;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import porthosc.languages.syntax.xgraph.program.XProgram;

import java.util.Set;


public class ZBasicRelation extends ZRelation {

    public static final String BASERELS[] = {"po", "co", "fr", "rf", "poloc", "rfe", "WR", "mfence"};

    public ZBasicRelation(String rel) {
        super(rel);
        containsRec = false;
    }

    @Override
    public BoolExpr encodeBasic(XProgram program, Context ctx) throws Z3Exception {
        return ctx.mkTrue();
    }

    @Override
    public BoolExpr encode(XProgram program, Context ctx, Set<String> encodedRels) throws Z3Exception {
        return ctx.mkTrue();
    }
}
