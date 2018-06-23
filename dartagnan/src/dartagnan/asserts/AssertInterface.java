package dartagnan.asserts;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;

public interface AssertInterface {

    BoolExpr encode(Context ctx) throws Z3Exception;

    String toString();
}
