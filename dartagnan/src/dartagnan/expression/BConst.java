package dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.program.Register;
import dartagnan.utils.MapSSA;

import java.util.HashSet;
import java.util.Set;

public class BConst extends BExpr implements ExprInterface {

	private final boolean value;
	
	public BConst(boolean value) {
		this.value = value;
	}

    @Override
	public BoolExpr toZ3Bool(MapSSA map, Context ctx) {
		return value ? ctx.mkTrue() : ctx.mkFalse();
	}

    @Override
	public Set<Register> getRegs() {
		return new HashSet<>();
	}

	@Override
	public BConst clone() {
		return new BConst(value);
	}

	@Override
	public String toString() {
		return value ? "True" : "False";
	}
}
