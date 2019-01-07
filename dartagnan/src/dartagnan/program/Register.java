package dartagnan.program;

import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Model;
import dartagnan.expression.IExpr;
import dartagnan.expression.IntExprInterface;
import dartagnan.program.event.Event;

import java.util.HashSet;
import java.util.Set;

public class Register extends IExpr implements IntExprInterface {

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
	public Set<Register> getRegs() {
		HashSet<Register> setRegs = new HashSet<>();
		setRegs.add(this);
		return setRegs;
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
