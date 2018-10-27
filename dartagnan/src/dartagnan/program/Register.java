package dartagnan.program;

import com.microsoft.z3.ArithExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import dartagnan.expression.AExpr;
import dartagnan.expression.IntExprInterface;
import dartagnan.utils.MapSSA;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

import static dartagnan.utils.Utils.ssaReg;

public class Register extends AExpr implements IntExprInterface {

	private String name;
	private Integer mainThreadId;
	private String printMainThreadId;

	public Register(String name) {
		if(name == null){
			name = "DUMMY_REG_" + UUID.randomUUID().toString();
		}
		this.name = name;
	}
	
	public String getName() {
		return name;
	}

	@Override
	public String toString() {
        return name;
	}

	public Register setPrintMainThreadId(String threadId){
	    this.printMainThreadId = threadId;
	    return this;
    }

    public String getPrintMainThreadId(){
	    return printMainThreadId;
    }

	@Override
	public Register clone() {
		return this;
	}
	
	public void setMainThreadId(Integer t) {
		this.mainThreadId = t;
	}

	@Override
	public ArithExpr toZ3(MapSSA map, Context ctx) {
		if(getMainThreadId() != null) {
			return ssaReg(this, map.get(this), ctx);
		}
		throw new RuntimeException("Main thread is not set for " + toString());
	}

	@Override
	public Set<Register> getRegs() {
		HashSet<Register> setRegs = new HashSet<>();
		setRegs.add(this);
		return setRegs;
	}

	public Integer getMainThreadId() {
		return mainThreadId;
	}

	@Override
	public IntExpr getLastValueExpr(Context ctx){
		return ctx.mkIntConst(getName() + "_" + getMainThreadId() + "_final");
	}
}
