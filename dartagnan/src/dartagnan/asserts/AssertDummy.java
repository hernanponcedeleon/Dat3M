package dartagnan.asserts;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;

// TODO: Temporary parent for backward compatibility. Should rely on AssertInterface only.
import dartagnan.expression.Assert;

public class AssertDummy extends Assert implements AssertInterface {

    public BoolExpr encode(Context ctx) throws Z3Exception {
        return ctx.mkTrue();
    }

    public String toString(){
        return "true";
    }
}
