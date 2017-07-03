package dartagnan.program;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import com.microsoft.z3.*;

import dartagnan.expression.AExpr;
import dartagnan.utils.LastModMap;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

public class Local extends Event {
	
	private Register reg;
	private AExpr expr;
	
	public Local(Register reg, AExpr expr) {
		this.reg = reg;
		this.expr = expr;
		this.condLevel = 0;
	}
	
	public Register getReg() {
		return reg;
	}
	
	public AExpr getExpr() {
		return expr;
	}
	
	public LastModMap setLastModMap(LastModMap map) {
		this.lastModMap = map;
		LastModMap retMap = map.clone();
		Set<Event> set = new HashSet<Event>();
		set.add(this);
		retMap.put(reg, set);
		return retMap;
	}
	
	public String toString() {
		return String.format("%s%s <- %s", String.join("", Collections.nCopies(condLevel, "  ")), reg, expr);
	}
	
	public Local clone() {
		Register newReg = reg.clone();
		AExpr newExpr = expr.clone();
		Local newLocal = new Local(newReg, newExpr);
		newLocal.condLevel = condLevel;
		return newLocal;
	}

	public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) throws Z3Exception {
		if(mainThread == null){
			System.out.println(String.format("Check encodeDF for %s", this));
			return null;
		}
		else {
			Expr z3Expr = expr.toZ3(map, ctx);
			Expr z3Reg = ctx.mkIntConst(String.format("T%s_%s_%s", mainThread, reg, map.getFresh(reg)));
			return new Pair<BoolExpr, MapSSA>(ctx.mkImplies(executes(ctx), ctx.mkEq(z3Reg, z3Expr)), map);
		}		
	}
}