package dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import dartagnan.program.Register;
import dartagnan.utils.MapSSA;

import java.util.HashSet;
import java.util.Set;

public class BExpr implements ExprInterface {
	
	private ExprInterface b1;
	private ExprInterface b2;
	private String op;
	
	public BExpr() {};
	
	public BExpr(ExprInterface b1, String op, ExprInterface b2) {
		this.b1 = b1;
		this.b2 = b2;
		this.op = op;
	}

	public String toString() {
		if(b2 != null){
		    return "(" + b1 + " " + op + " " + b2 + ")";
		}
        return "(" + op + " " + b1 + ")";
	}

	public BExpr clone() {
		ExprInterface newB1 = b1.clone();
		ExprInterface newB2 = b2 == null ? null : b2.clone();
		return new BExpr(newB1, op, newB2);
	}

	@Override
	public BoolExpr toZ3(MapSSA map, Context ctx) {
		switch(op) {
			case "and":
				return ctx.mkAnd(b1.toZ3Boolean(map, ctx), b2.toZ3Boolean(map, ctx));
			case "or":
				return ctx.mkOr(b1.toZ3Boolean(map, ctx), b2.toZ3Boolean(map, ctx));
			case "not":
				return ctx.mkNot(b1.toZ3Boolean(map, ctx));
		}
		throw new RuntimeException("Unrecognised boolean operator " + op);
	}

	@Override
    public BoolExpr toZ3Boolean(MapSSA map, Context ctx){
	    return toZ3(map, ctx);
    }

	@Override
	public Set<Register> getRegs() {
		Set<Register> setRegs = new HashSet<>();
		setRegs.addAll(b1.getRegs());
		if(b2 != null) {
			setRegs.addAll(b2.getRegs());
		}
		return setRegs;
	}

	@Override
	public BoolExpr encodeAssignment(MapSSA map, Context ctx, Expr target, Expr value){
		return ctx.mkOr(
				ctx.mkAnd((BoolExpr) value, ctx.mkEq(target, ctx.mkInt(1))),
				ctx.mkAnd(ctx.mkNot((BoolExpr) value), ctx.mkEq(target, ctx.mkInt(0)))
		);
	}
}
