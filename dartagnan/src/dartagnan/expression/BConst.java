package dartagnan.expression;

import java.util.HashSet;
import java.util.Set;

import com.microsoft.z3.*;

import dartagnan.program.Register;
import dartagnan.utils.MapSSA;

public class BConst extends BExpr {

	private boolean value;
	
	public BConst(boolean value) {
		this.value = value;
	}
	
	public String toString() {
		if (value)
			return "True";
		else
			return "False";
	}
	
	public BConst clone() {
		return new BConst(value);
	}
	
	public BoolExpr toZ3(MapSSA map, Context ctx) throws Z3Exception {
		if(value) {
			return ctx.mkTrue();	
		}
		else {
			return ctx.mkFalse();
		}
	}
	
	public Set<Register> getRegs() {
		return new HashSet<Register>();
	}
}
