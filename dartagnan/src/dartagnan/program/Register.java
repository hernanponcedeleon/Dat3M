package dartagnan.program;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

import com.microsoft.z3.*;

import dartagnan.expression.AExpr;
import dartagnan.utils.MapSSA;
import static dartagnan.utils.Utils.ssaReg;

public class Register extends AExpr {

	private String name;
	private Integer mainThread;

	public Register(String name) {
		if(name == null){
			name = "DUMMY_REG_" + UUID.randomUUID().toString();
		}
		this.name = name;
	}
	
	public String getName() {
		return name;
	}
	
	public String toString() {
		return name;
		}
	
	public Register clone() {
		return this;
	}
	
	public void setMainThread(Integer t) {
		this.mainThread = t;
	}

	public ArithExpr toZ3(MapSSA map, Context ctx) throws Z3Exception {
		if(getMainThread() == null) {
			System.out.println(String.format("Check toZ3() for %s: null pointer!", this));
		}
		return (ArithExpr) ssaReg(this, map.get(this), ctx);
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
