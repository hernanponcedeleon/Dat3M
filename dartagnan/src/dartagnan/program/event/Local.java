package dartagnan.program.event;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import dartagnan.expression.ExprInterface;
import dartagnan.program.Register;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.event.utils.RegWriter;

import java.util.Set;

public class Local extends Event implements RegWriter, RegReaderData {
	
	protected Register reg;
	protected ExprInterface expr;
	private IntExpr regResultExpr;
	
	public Local(Register reg, ExprInterface expr) {
		this.reg = reg;
		this.expr = expr;
		this.condLevel = 0;
	}

	@Override
	public void initialise(Context ctx) {
		regResultExpr = reg.toZ3IntResult(this, ctx);
	}

	public ExprInterface getExpr(){
		return expr;
	}

	@Override
	public Register getModifiedReg(){
		return reg;
	}

	@Override
	public IntExpr getRegResultExpr(){
		return regResultExpr;
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
	public Local clone() {
	    if(clone == null){
            clone = new Local(reg.clone(), expr.clone());
            afterClone();
        }
		return (Local)clone;
	}

	@Override
	public BoolExpr encodeCF(Context ctx) {
		return ctx.mkAnd(super.encodeCF(ctx), ctx.mkEq(regResultExpr,  expr.toZ3Int(this, ctx)));
	}
}