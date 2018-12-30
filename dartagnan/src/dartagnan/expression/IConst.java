package dartagnan.expression;

import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import dartagnan.program.Register;
import dartagnan.program.event.Event;

import java.util.HashSet;
import java.util.Set;

public class IConst extends IExpr implements ExprInterface, IntExprInterface {

	private final int value;
	
	public IConst(int value) {
		this.value = value;
	}

	@Override
	public IntExpr toZ3Int(Event e, Context ctx) {
		return ctx.mkInt(value);
	}

	@Override
	public Set<Register> getRegs() {
		return new HashSet<>();
	}

	@Override
	public IConst clone() {
		return new IConst(value);
	}

	@Override
	public String toString() {
		return Integer.toString(value);
	}

	@Override
	public IntExpr getLastValueExpr(Context ctx){
		return ctx.mkInt(value);
	}

    public IntExpr toZ3Int(Context ctx) {
        return ctx.mkInt(value);
    }
}
