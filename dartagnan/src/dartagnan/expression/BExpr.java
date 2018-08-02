package dartagnan.expression;

import java.util.HashSet;
import java.util.Set;

import com.microsoft.z3.*;

import dartagnan.program.Register;
import dartagnan.utils.MapSSA;

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
	
	public String toString() {
		return String.format("(%s %s %s)", b1, op, b2);
	}
	
	public BExpr clone() {
		BExpr newB1 = b1.clone();
		BExpr newB2 = b2.clone();
		return new BExpr(newB1, op, newB2);
	}
	
	public BoolExpr toZ3(MapSSA map, Context ctx) throws Z3Exception {
		switch(op) {
		case "and": return ctx.mkAnd(b1.toZ3(map, ctx), b2.toZ3(map, ctx));
		case "or": return ctx.mkOr(b1.toZ3(map, ctx), b2.toZ3(map, ctx));
		case "not": return ctx.mkNot(b1.toZ3(map, ctx)); 
		}
		System.out.println(String.format("Check toz3() for %s", this));
		return null;
	}

	public Set<Register> getRegs() {
		Set<Register> setRegs = new HashSet<Register>();
		setRegs.addAll(b1.getRegs());
		setRegs.addAll(b2.getRegs());
		return setRegs;
	}

	// TODO: Setting for (true -> 1) vs (true -> not 0)
	public BoolExpr encodeAssignment(MapSSA map, Context ctx, Expr target, Expr value){
		return ctx.mkOr(
				ctx.mkAnd((BoolExpr) value, ctx.mkEq(target, ctx.mkInt(1))),
				ctx.mkAnd(ctx.mkNot((BoolExpr) value), ctx.mkEq(target, ctx.mkInt(0)))
		);
	}
}
