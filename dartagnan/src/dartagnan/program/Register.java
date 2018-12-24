package dartagnan.program;

import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import dartagnan.expression.IExpr;
import dartagnan.expression.IntExprInterface;
import dartagnan.utils.MapSSA;

import java.util.HashSet;
import java.util.Set;

import static dartagnan.utils.Utils.ssaReg;

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
	public IntExpr toZ3Int(MapSSA map, Context ctx) {
		if(mainThreadId > -1) {
			return ssaReg(this, map.get(this), ctx);
		}
		throw new RuntimeException("Main thread is not set for " + this);
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
}
