package dartagnan.program.memory;

import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import dartagnan.expression.AConst;
import dartagnan.expression.IntExprInterface;

public class Location implements IntExprInterface {

	public static final int DEFAULT_INIT_VALUE = 0;

	private final String name;
	private final Address address;
	private AConst iValue = new AConst(DEFAULT_INIT_VALUE);

	Location(String name, Address address) {
		this.name = name;
		this.address = address;
	}
	
	public String getName() {
		return name;
	}
	
	public void setIValue(AConst iValue) {
		this.iValue = iValue;
	}

	public AConst getIValue() {
		return iValue;
	}

	public Address getAddress() {
		return address;
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
		return ctx.mkIntConst("memory_" + getAddress() + "_final");
	}
}
