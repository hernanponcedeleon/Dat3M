package dartagnan.program;

import java.util.Collections;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;

public class OptSync extends Sync {

	public String toString() {
		return String.format("%ssync?", String.join("", Collections.nCopies(condLevel, "  ")));
	}
	
	public BoolExpr encodeCF(Context ctx) throws Z3Exception {
		return ctx.mkBoolConst(cfVar());
	}
}
