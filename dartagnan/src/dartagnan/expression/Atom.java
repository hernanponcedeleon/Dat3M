package dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.expression.op.COpBin;
import dartagnan.program.Register;
import dartagnan.utils.MapSSA;

import java.util.HashSet;
import java.util.Set;

public class Atom extends BExpr implements ExprInterface {
	
	private AExpr lhs;
	private AExpr rhs;
	private COpBin op;
	
	public Atom (ExprInterface lhs, COpBin op, ExprInterface rhs) {
        if(!(lhs instanceof AExpr) || !(rhs instanceof AExpr)){
            // TODO: Implementation
            throw new RuntimeException("Atom is not implemented for BExpr arguments");
        }
		this.lhs = (AExpr)lhs;
		this.rhs = (AExpr)rhs;
		this.op = op;
	}

    @Override
	public String toString() {
		return lhs + " " + op + " " + rhs;
	}

    @Override
	public Atom clone() {
		return new Atom(lhs.clone(), op, rhs.clone());
	}

    @Override
	public BoolExpr toZ3(MapSSA map, Context ctx) {
		return op.encode(lhs.toZ3(map, ctx), rhs.toZ3(map, ctx), ctx);
	}

    @Override
	public Set<Register> getRegs() {
		Set<Register> setRegs = new HashSet<>();
		setRegs.addAll(lhs.getRegs());
		setRegs.addAll(rhs.getRegs());
		return setRegs;
	}
}