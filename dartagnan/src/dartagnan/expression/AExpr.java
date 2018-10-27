package dartagnan.expression;

import com.microsoft.z3.*;
import dartagnan.program.Register;
import dartagnan.utils.MapSSA;

import java.util.HashSet;
import java.util.Set;

public class AExpr implements ExprInterface {

	private AExpr lhs;
	private AExpr rhs;
	private String op;

	public AExpr() {};
	
	public AExpr(ExprInterface lhs, String op, ExprInterface rhs) {
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
		return lhs + " " + op + " " + rhs;
	}

    @Override
	public AExpr clone() {
		return new AExpr(lhs.clone(), op, rhs.clone());
	}

    @Override
	public ArithExpr toZ3(MapSSA map, Context ctx) {
		switch(op) {
			case "+":
				return ctx.mkAdd(lhs.toZ3(map, ctx), rhs.toZ3(map, ctx));
			case "-":
				return ctx.mkSub(lhs.toZ3(map, ctx), rhs.toZ3(map, ctx));
			case "*":
				return ctx.mkMul(lhs.toZ3(map, ctx), rhs.toZ3(map, ctx));
			case "/":
				return ctx.mkDiv(lhs.toZ3(map, ctx), rhs.toZ3(map, ctx));
			case "&":
				return ctx.mkBV2Int(ctx.mkBVAND(ctx.mkInt2BV(32, (IntExpr) lhs.toZ3(map, ctx)), ctx.mkInt2BV(32, (IntExpr) rhs.toZ3(map, ctx))), false);
			case "|":
				return ctx.mkBV2Int(ctx.mkBVOR(ctx.mkInt2BV(32, (IntExpr) lhs.toZ3(map, ctx)), ctx.mkInt2BV(32, (IntExpr) rhs.toZ3(map, ctx))), false);
			case "xor":
				return ctx.mkBV2Int(ctx.mkBVXOR(ctx.mkInt2BV(32, (IntExpr) lhs.toZ3(map, ctx)), ctx.mkInt2BV(32, (IntExpr) rhs.toZ3(map, ctx))), false);
		}
		throw new RuntimeException("Unrecognised arithmetic operator " + op);
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


