package dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import dartagnan.program.Register;
import dartagnan.utils.MapSSA;

import java.util.HashSet;
import java.util.Set;

public class BExpr implements ExprInterface {
	
	private BExpr b1;
	private BExpr b2;
	private String op;
	
	public BExpr() {};
	
	public BExpr(BExpr b1, String op, BExpr b2) {
		this.b1 = b1;
		this.b2 = b2;
		this.op = op;
	}

	@Override
	public String toString() {
		return b1 + " " + op + " " + b2;
	}

	@Override
	public BExpr clone() {
		return new BExpr(b1.clone(), op, b2.clone());
	}

	@Override
	public BoolExpr toZ3(MapSSA map, Context ctx) {
		switch(op) {
			case "and":
				return ctx.mkAnd(b1.toZ3(map, ctx), b2.toZ3(map, ctx));
			case "or":
				return ctx.mkOr(b1.toZ3(map, ctx), b2.toZ3(map, ctx));
			case "not":
				return ctx.mkNot(b1.toZ3(map, ctx));
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
		setRegs.addAll(b2.getRegs());
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
