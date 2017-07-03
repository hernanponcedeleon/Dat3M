package dartagnan.program;

import java.util.HashSet;
import java.util.Set;

import com.microsoft.z3.*;

import dartagnan.expression.AExpr;
import dartagnan.utils.MapSSA;

public class Register extends AExpr {

	private String name;
	private Integer mainThread;

	public Register(String name) {
		this.name = name;
	}
	
	public String getName() {
		return name;
	}
	
	public String toString() {
		return String.format("%s", name);
		}
	
	public Register clone() {
		return this;
		//return new Register(name);
	}
	
	public void setMainThread(Integer t) {
		this.mainThread = t;
	}

	public ArithExpr toZ3(MapSSA map, Context ctx) throws Z3Exception {
		if(getMainThread() == null) {
			System.out.println(String.format("Check toZ3() for %s: null pointer!", this));
		}
		//map.get(this);
		return (ArithExpr) ctx.mkIntConst(String.format("T%s_%s_%s", getMainThread(), name, map.get(this)));
	}
	
	public Set<Register> getRegs() {
		HashSet<Register> setRegs = new HashSet<Register>();
		setRegs.add(this);
		return setRegs;
	}

	public Integer getMainThread() {
		return mainThread;
	}

}
