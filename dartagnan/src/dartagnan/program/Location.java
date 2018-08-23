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
	
	public Integer getMin() {
		return min;
	}
	
	public void setMax(int max) {
		this.max = max;
	}
	
	public Integer getMax() {
		return max;
	}
	
	public String toString() {
		return name;
	}
	
	public Location clone() {
		return this;
	}

	public IntExpr getLastValueExpr(Context ctx){
		return ctx.mkIntConst(getName() + "_final");
	}
}
