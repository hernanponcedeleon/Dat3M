package dartagnan.program;

import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import dartagnan.expression.IntExprInterface;

public class Location implements IntExprInterface {

	private String name;
	private Integer iValue;
	private Integer min;
	private Integer max;

	public Location(String name) {
		this.name = name;
	}
	
	public String getName() {
		return name;
	}
	
	public void setIValue(int iValue) {
		this.iValue = iValue;
	}
	
	public Integer getIValue() {
		return iValue;
	}

	public void setMin(int min) {
		this.min = min;
	}

	public void setMax(int max) {
		this.max = max;
	}

	@Override
	public String toString() {
		return name;
	}

	@Override
	public Location clone() {
		return this;
	}

	@Override
	public IntExpr getLastValueExpr(Context ctx){
		return ctx.mkIntConst(getName() + "_final");
	}
}
