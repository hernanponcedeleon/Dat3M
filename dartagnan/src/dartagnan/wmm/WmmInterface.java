package dartagnan.wmm;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;

public interface WmmInterface {

    BoolExpr encode(Program program, Context ctx, boolean approx, boolean idl) throws Z3Exception;

    BoolExpr Consistent(Program program, Context ctx) throws Z3Exception;

    BoolExpr Inconsistent(Program program, Context ctx) throws Z3Exception;
}
