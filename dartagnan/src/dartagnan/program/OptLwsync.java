package dartagnan.program;

import java.util.Collections;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;

public class OptLwsync extends Lwsync {

	public String toString() {
		return String.format("%slwsync?", String.join("", Collections.nCopies(condLevel, "  ")));
	}
	
	public BoolExpr encodeCF(Context ctx) throws Z3Exception {
		return ctx.mkBoolConst(cfVar());
	}
}
