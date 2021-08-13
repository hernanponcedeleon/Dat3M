package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.google.common.collect.ImmutableSet;

import java.math.BigInteger;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class Address extends IConst implements ExprInterface {

    private final int index;
    private BigInteger constantValue;

    Address(int index, int precision){
        super(BigInteger.valueOf(index), precision);
        this.index = index;
    }

    public boolean hasConstantValue() {
     	return this.constantValue != null;
     }

    public BigInteger getConstantValue() {
     	return this.constantValue;
     }

    public void setConstantValue(BigInteger value) {
     	this.constantValue = value;
     }

    @Override
    public ImmutableSet<Register> getRegs(){
        return ImmutableSet.of();
    }

    @Override
    public Formula toIntFormula(Event e, SolverContext ctx){
        return toIntFormula(ctx);
    }

    @Override
    public Formula getLastValueExpr(SolverContext ctx){
        return toIntFormula(ctx);
    }

    public Formula getLastMemValueExpr(SolverContext ctx){
        FormulaManager fmgr = ctx.getFormulaManager();
		return precision > 0 ? 
        		fmgr.getBitvectorFormulaManager().makeVariable(precision, "last_val_at_memory_" + index) : 
        		fmgr.getIntegerFormulaManager().makeVariable("last_val_at_memory_" + index);
    }

    @Override
    public BooleanFormula toBoolFormula(Event e, SolverContext ctx){
        return ctx.getFormulaManager().getBooleanFormulaManager().makeTrue();
    }

    @Override
    public String toString(){
        return "&mem" + index;
    }

    @Override
    public int hashCode(){
        return index;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;

        if (obj == null || getClass() != obj.getClass())
            return false;

        return index == ((Address)obj).index;
    }

    @Override
    public Formula toIntFormula(SolverContext ctx){
		FormulaManager fmgr = ctx.getFormulaManager();
		if(constantValue != null) {
			return precision > 0 ? 
					fmgr.getBitvectorFormulaManager().makeBitvector(precision, constantValue) : 
					fmgr.getIntegerFormulaManager().makeNumber(constantValue);
    	}
		return precision > 0 ? 
				fmgr.getBitvectorFormulaManager().makeVariable(precision, "memory_" + index) :
				fmgr.getIntegerFormulaManager().makeVariable("memory_" + index);
    }

    @Override
    public BigInteger getIntValue(Event e, Model model, SolverContext ctx){
        if (hasConstantValue()) {
            return constantValue;
        }
        return new BigInteger(model.evaluate(toIntFormula(ctx)).toString());
    }

    @Override
    public <T> T visit(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }
}
