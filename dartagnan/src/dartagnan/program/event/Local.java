package dartagnan.program.event;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import dartagnan.expression.ExprInterface;
import dartagnan.program.Register;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import java.util.Set;

import static dartagnan.utils.Utils.ssaReg;

public class Local extends Event implements RegWriter, RegReaderData {
	
	protected Register reg;
	protected ExprInterface expr;
	protected int ssaRegIndex;
	
	public Local(Register reg, ExprInterface expr) {
		this.reg = reg;
		this.expr = expr;
		this.condLevel = 0;
	}

	@Override
	public Register getModifiedReg(){
		return reg;
	}

	@Override
	public Set<Register> getDataRegs(){
		return expr.getRegs();
	}

    @Override
	public String toString() {
		return nTimesCondLevel() + reg + " <- " + expr;
	}

    @Override
    public int getSsaRegIndex() {
        return ssaRegIndex;
    }

    @Override
	public Local clone() {
		Register newReg = reg.clone();
		ExprInterface newExpr = expr.clone();
		Local newLocal = new Local(newReg, newExpr);
		newLocal.condLevel = condLevel;
		newLocal.setHLId(hashCode());
		newLocal.setUnfCopy(getUnfCopy());
		return newLocal;
	}

    @Override
	public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) {
		if(mainThread != null){
			Expr z3Expr = expr.toZ3(map, ctx);
			Expr z3Reg = ssaReg(reg, map.getFresh(reg), ctx);
			this.ssaRegIndex = map.get(reg);
			return new Pair<>(ctx.mkImplies(executes(ctx), expr.encodeAssignment(map, ctx, z3Reg, z3Expr)), map);
		}
		throw new RuntimeException("Main thread is not set for " + toString());
	}
}