package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.event.Event;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.*;

import java.math.BigInteger;

import static org.sosy_lab.java_smt.api.FormulaType.IntegerType;
import static org.sosy_lab.java_smt.api.FormulaType.getBitvectorTypeWithSize;

public class Register extends IExpr implements ExprInterface {

	private static int dummyCount = 0;

	private final String name;
	private String cVar;
    private final int threadId;

    private final int precision;

	public Register(String name, int threadId, int precision) {
		if(name == null){
			name = "DUMMY_REG_" + dummyCount++;
		}
		this.name = name;
		this.threadId = threadId;
		this.precision = precision;
	}
	
	public String getName() {
		return name;
	}

	public String getCVar() {
		return cVar;
	}

	public void setCVar(String name) {
		this.cVar = name;
	}

	public int getThreadId(){
		return threadId;
	}

	@Override
	public String toString() {
        return name;
	}

    @Override
    public int hashCode(){
        return (name.hashCode() << 8) + threadId;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;

        if (obj == null || getClass() != obj.getClass())
            return false;

        Register rObj = (Register) obj;
        return name.equals(rObj.name) && threadId == rObj.threadId;
    }

	@Override
	public Formula toIntFormula(Event e, SolverContext ctx) {
		String name = getName() + "(" + e.repr() + ")";
		FormulaManager fmgr = ctx.getFormulaManager();
		FormulaType<?> type = precision > 0 ? getBitvectorTypeWithSize(precision) : IntegerType;
		return fmgr.makeVariable(type, name);
	}

	public Formula toIntFormulaResult(Event e, SolverContext ctx) {
		String name = getName() + "(" + e.repr() + "_result)";
		FormulaManager fmgr = ctx.getFormulaManager();
		FormulaType<?> type = precision > 0 ? getBitvectorTypeWithSize(precision) : IntegerType;
		return fmgr.makeVariable(type, name);
	}

	@Override
	public ImmutableSet<Register> getRegs() {
		return ImmutableSet.of(this);
	}

	@Override
	public Formula getLastValueExpr(SolverContext ctx){
		String name = getName() + "_" + threadId + "_final";
		FormulaManager fmgr = ctx.getFormulaManager();
		FormulaType<?> type = precision > 0 ? getBitvectorTypeWithSize(precision) : IntegerType;
		return fmgr.makeVariable(type, name);
	}

	@Override
	public BigInteger getIntValue(Event e, Model model, SolverContext ctx){
		return new BigInteger(model.evaluate(toIntFormula(e, ctx)).toString());
	}

	@Override
	public <T> T visit(ExpressionVisitor<T> visitor) {
		return visitor.visit(this);
	}

	@Override
	public ExprInterface reduce() {
		throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

	@Override
	public int getPrecision() {
    	return precision;
    }
}
