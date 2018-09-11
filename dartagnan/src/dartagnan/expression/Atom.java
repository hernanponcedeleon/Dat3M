package dartagnan.expression;

import java.util.HashSet;
import java.util.Set;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;

import dartagnan.program.Register;
import dartagnan.utils.MapSSA;

public class Atom extends BExpr implements ExprInterface {
	
	private AExpr lhs;
	private AExpr rhs;
	private String op;
	
	public Atom (ExprInterface lhs, String op, ExprInterface rhs) {
        if(!(lhs instanceof AExpr) || !(rhs instanceof AExpr)){
            // TODO: Implementation
            throw new RuntimeException("Atom is not implemented for BExpr arguments");
        }
		this.lhs = (AExpr)lhs;
		this.rhs = (AExpr)rhs;
		this.op = op;	
	}
	
	public String toString() {
		return String.format("(%s %s %s)", lhs, op, rhs);
	}
	
	public Atom clone() {
		AExpr newLHS = lhs.clone();
		AExpr newRHS = rhs.clone();
		return new Atom(newLHS, op, newRHS);
	}
	
	public BoolExpr toZ3(MapSSA map, Context ctx) throws Z3Exception {
		switch(op) {
		case "==": return ctx.mkEq(lhs.toZ3(map, ctx), rhs.toZ3(map, ctx));
		case "!=": return ctx.mkNot(ctx.mkEq(lhs.toZ3(map, ctx), rhs.toZ3(map, ctx)));
		case "<": return ctx.mkLt(lhs.toZ3(map, ctx), rhs.toZ3(map, ctx)); 
		case "<=": return ctx.mkLe(lhs.toZ3(map, ctx), rhs.toZ3(map, ctx)); 
		case ">": return ctx.mkGt(lhs.toZ3(map, ctx), rhs.toZ3(map, ctx)); 
		case ">=": return ctx.mkGe(lhs.toZ3(map, ctx), rhs.toZ3(map, ctx)); 
		}
		System.out.println(String.format("Check toz3() for %s", this));
		return null;
	}
	
	public Set<Register> getRegs() {
		Set<Register> setRegs = new HashSet<Register>();
		setRegs.addAll(lhs.getRegs());
		setRegs.addAll(rhs.getRegs());
		return setRegs;
	}
}