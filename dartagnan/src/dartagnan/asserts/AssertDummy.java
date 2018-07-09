package dartagnan.asserts;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;

public class AssertDummy implements AssertInterface {

    public BoolExpr encode(Context ctx) throws Z3Exception {
        return ctx.mkTrue();
    }

    public String toString(){
        return "true";
    }
}
