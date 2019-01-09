package dartagnan.program;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Model;
import dartagnan.expression.ExprInterface;
import dartagnan.expression.IExpr;
import dartagnan.program.event.Event;

public class Register extends IExpr implements ExprInterface {

	private static int dummyCount = 0;

	private String name;
	private int mainThreadId = -1;
	private String printMainThreadId;

	public Register(String name) {
		if(name == null){
			name = "DUMMY_REG_" + dummyCount++;
		}
		this.name = name;
	}
	
	public String getName() {
		return name;
	}

	public void setMainThreadId(int t) {
		this.mainThreadId = t;
	}

	public void setPrintMainThreadId(String threadId){
		this.printMainThreadId = threadId;
	}

	public String getPrintMainThreadId(){
		return printMainThreadId;
	}

	@Override
	public String toString() {
        return name;
	}

	@Override
	public Register clone() {
		return this;
	}

	@Override
	public IntExpr toZ3Int(Event e, Context ctx) {
		return ctx.mkIntConst(getName() + "(" + e.repr() + ")");
	}

	public IntExpr toZ3IntResult(Event e, Context ctx) {
		return ctx.mkIntConst(getName() + "(" + e.repr() + "_result)");
	}

	@Override
	public ImmutableSet<Register> getRegs() {
		return ImmutableSet.of(this);
	}

	@Override
	public IntExpr getLastValueExpr(Context ctx){
		if(mainThreadId > -1) {
			return ctx.mkIntConst(getName() + "_" + mainThreadId + "_final");
		}
		throw new RuntimeException("Main thread is not set for " + this);
	}

	@Override
	public int getIntValue(Event e, Context ctx, Model model){
		return Integer.parseInt(model.getConstInterp(toZ3Int(e, ctx)).toString());
	}
}
