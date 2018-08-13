package dartagnan.expression;

import java.util.HashSet;
import java.util.Set;

import com.microsoft.z3.*;

import dartagnan.program.Register;
import dartagnan.utils.MapSSA;

public class AConst extends AExpr implements ExprInterface, IntExprInterface {

	private Integer value;
	
	public AConst(Integer value) {
		this.value = value;
	}
	
	public String toString() {
		return value.toString();
	}
	
	public AConst clone() {
		return new AConst(value);
	}
	
	public ArithExpr toZ3(MapSSA map, Context ctx) throws Z3Exception {
		return ctx.mkInt(value);
	}
	
	public Set<Register> getRegs() {
		return new HashSet<>();
	}

	public IntExpr getLastValueExpr(Context ctx){
		return ctx.mkInt(value);
	}
}
