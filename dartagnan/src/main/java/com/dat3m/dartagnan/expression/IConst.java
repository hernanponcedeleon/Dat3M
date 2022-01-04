package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.event.Event;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

import java.math.BigInteger;

public class IConst extends IExpr implements ExprInterface, LastValueInterface {

	// TODO(TH): not sure where this are used, but why do you set the precision to 0?
	// TH: This was a temporary try for integer logic only
	// However, it is impossible to define general constants, we need a function that produces
	// a constant for each precision degree
	// HP: agree. I assume you wanted this to improve code readability, but having one constant per precition won't help.
	public static IConst ZERO = new IConst(BigInteger.ZERO, -1);
	public static IConst ONE = new IConst(BigInteger.ONE, -1);

	private final BigInteger value;
	protected final int precision;
	
	public IConst(BigInteger value, int precision) {
		this.value = value;
		this.precision = precision;
	}

	public IConst(String value, int precision) {
		this.value = new BigInteger(value);
		this.precision = precision;
	}

	@Override
    public Formula toIntFormula(Event e, SolverContext ctx){
		FormulaManager fmgr = ctx.getFormulaManager();
		return precision > 0 ? 
				fmgr.getBitvectorFormulaManager().makeBitvector(precision, value) : 
				fmgr.getIntegerFormulaManager().makeNumber(value);
	}

	@Override
	public String toString() {
		return value.toString();
	}

	@Override
	public Formula getLastValueExpr(SolverContext ctx){
		FormulaManager fmgr = ctx.getFormulaManager();
		return precision > 0 ? 
				fmgr.getBitvectorFormulaManager().makeBitvector(precision, value) : 
				fmgr.getIntegerFormulaManager().makeNumber(value);
	}

	@Override
	public BigInteger getIntValue(Event e, Model model, SolverContext ctx){
		return value;
	}

	public int getValueAsInt() {
		return value.intValue();
	}

    public Formula toIntFormula(SolverContext ctx) {
		FormulaManager fmgr = ctx.getFormulaManager();
		return precision > 0 ?
				fmgr.getBitvectorFormulaManager().makeBitvector(precision, value) :
				fmgr.getIntegerFormulaManager().makeNumber(value);
    }

	@Override
	public IConst reduce() {
		return this;
	}
	
	@Override
	public IExpr getBase() {
		return this;
	}
	
	public BigInteger getValue() {
		return value;
	}

    
	@Override
	public int getPrecision() {
    	return precision;
    }

	@Override
	public <T> T visit(ExpressionVisitor<T> visitor) {
		return visitor.visit(this);
	}

	@Override
	public int hashCode() {
		return precision > 0 ? value.hashCode() : value.hashCode() + precision;
	}

	@Override
	public boolean equals(Object obj) {
		if (obj == this) {
			return true;
		} else if (obj == null || obj.getClass() != getClass()) {
			return false;
		}
		IConst expr = (IConst) obj;
		return expr.value.equals(value) && expr.precision == precision;
	}
}
