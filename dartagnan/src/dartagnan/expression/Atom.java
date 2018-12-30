package dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.expression.op.COpBin;
import dartagnan.program.Register;
import dartagnan.program.event.Event;

import java.util.HashSet;
import java.util.Set;

public class Atom extends BExpr implements ExprInterface {
	
	private final ExprInterface lhs;
	private final ExprInterface rhs;
	private final COpBin op;
	
	public Atom (ExprInterface lhs, COpBin op, ExprInterface rhs) {
		this.lhs = lhs;
		this.rhs = rhs;
		this.op = op;
	}

    @Override
	public BoolExpr toZ3Bool(Event e, Context ctx) {
		return op.encode(lhs.toZ3Int(e, ctx), rhs.toZ3Int(e, ctx), ctx);
	}

    @Override
	public Set<Register> getRegs() {
		Set<Register> setRegs = new HashSet<>();
		setRegs.addAll(lhs.getRegs());
		setRegs.addAll(rhs.getRegs());
		return setRegs;
	}

    @Override
    public Atom clone() {
        return new Atom(lhs.clone(), op, rhs.clone());
    }

    @Override
    public String toString() {
        return lhs + " " + op + " " + rhs;
    }
}