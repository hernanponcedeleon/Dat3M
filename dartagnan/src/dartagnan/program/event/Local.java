package dartagnan.program.event;

import java.util.Collections;

import com.microsoft.z3.*;

import dartagnan.expression.ExprInterface;
import dartagnan.program.Register;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;
import static dartagnan.utils.Utils.ssaReg;

public class Local extends Event {
	
	private Register reg;
	private ExprInterface expr;
	private Integer ssaRegIndex;
	
	public Local(Register reg, ExprInterface expr) {
		this.reg = reg;
		this.expr = expr;
		this.condLevel = 0;
	}
	
	public Register getReg() {
		return reg;
	}
	
	public ExprInterface getExpr() {
		return expr;
	}

	public String toString() {
		return String.format("%s%s <- %s", String.join("", Collections.nCopies(condLevel, "  ")), reg, expr);
	}
	
	public Local clone() {
		Register newReg = reg.clone();
		ExprInterface newExpr = expr.clone();
		Local newLocal = new Local(newReg, newExpr);
		newLocal.condLevel = condLevel;
		newLocal.setHLId(hashCode());
		newLocal.setUnfCopy(getUnfCopy());
		return newLocal;
	}

	public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) throws Z3Exception {
		if(mainThread == null){
			System.out.println(String.format("Check encodeDF for %s", this));
			return null;
		}
		else {
			Expr z3Expr = expr.toZ3(map, ctx);
			Expr z3Reg = ssaReg(reg, map.getFresh(reg), ctx);
			this.ssaRegIndex = map.get(reg);
			return new Pair<>(ctx.mkImplies(executes(ctx), expr.encodeAssignment(map, ctx, z3Reg, z3Expr)), map);
		}		
	}
	
	public Integer getSsaRegIndex() {
			return ssaRegIndex;
	}
}