package dartagnan.program;

import java.util.Collections;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;

public class OptSync extends Sync {

	private BoolExpr z3Expr;
	
	public BoolExpr getZ3Expr() {
		return z3Expr;
	}
	
	public String toString() {
		return String.format("%sopt_sync", String.join("", Collections.nCopies(condLevel, "  ")));
	}
	
	public BoolExpr encodeCF(Context ctx) throws Z3Exception {
		this.z3Expr = ctx.mkBoolConst(cfVar());
		return z3Expr;
	}
}
