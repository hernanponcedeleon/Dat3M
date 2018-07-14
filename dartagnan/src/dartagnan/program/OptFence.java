package dartagnan.program;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;

public class OptFence extends Fence {

    public OptFence(String name){
        super(name);
    }

    public BoolExpr encodeCF(Context ctx) throws Z3Exception {
        return ctx.mkBoolConst(cfVar());
    }
}
