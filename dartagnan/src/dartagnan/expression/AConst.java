package dartagnan.expression;

import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import dartagnan.program.Register;
import dartagnan.utils.MapSSA;

import java.util.HashSet;
import java.util.Set;

public class AConst extends AExpr implements ExprInterface, IntExprInterface {

	private int value;
	
	public AConst(int value) {
		this.value = value;
	}

	@Override
	public String toString() {
		return Integer.toString(value);
	}

	@Override
	public AConst clone() {
		return new AConst(value);
	}

	@Override
	public IntExpr toZ3(MapSSA map, Context ctx) {
		return ctx.mkInt(value);
	}

	@Override
	public Set<Register> getRegs() {
		return new HashSet<>();
	}

	@Override
	public IntExpr getLastValueExpr(Context ctx){
		return ctx.mkInt(value);
	}

    public IntExpr toZ3(Context ctx) {
        return ctx.mkInt(value);
    }
}
