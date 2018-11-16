package dartagnan.expression;

import com.microsoft.z3.*;
import dartagnan.expression.op.AOpBin;
import dartagnan.program.Register;
import dartagnan.utils.MapSSA;

import java.util.HashSet;
import java.util.Set;

public class AExpr implements ExprInterface {

	private AExpr lhs;
	private AExpr rhs;
	private AOpBin op;

	public AExpr() {};
	
	public AExpr(ExprInterface lhs, AOpBin op, ExprInterface rhs) {
	    if(!(lhs instanceof AExpr) || !(rhs instanceof AExpr)){
	        // TODO: Implementation
	        throw new RuntimeException("AExpr is not implemented for BExpr arguments");
        }
		this.lhs = (AExpr)lhs;
		this.rhs = (AExpr)rhs;
		this.op = op;
	}

    @Override
	public String toString() {
		return "(" + lhs + " " + op + " " + rhs + ")";
	}

    @Override
	public AExpr clone() {
		return new AExpr(lhs.clone(), op, rhs.clone());
	}

    @Override
	public ArithExpr toZ3(MapSSA map, Context ctx) {
	    return op.encode(lhs.toZ3(map, ctx), rhs.toZ3(map, ctx), ctx);
	}

    @Override
	public BoolExpr toZ3Boolean(MapSSA map, Context ctx) {
		return ctx.mkGt(toZ3(map, ctx), ctx.mkInt(0));
	}

    @Override
	public Set<Register> getRegs() {
		Set<Register> setRegs = new HashSet<>();
		setRegs.addAll(lhs.getRegs());
		setRegs.addAll(rhs.getRegs());
		return setRegs;
	}

    @Override
	public BoolExpr encodeAssignment(MapSSA map, Context ctx, Expr target, Expr value){
		return ctx.mkEq(target, value);
	}
}


