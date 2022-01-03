package com.dat3m.dartagnan.expression.utils;

import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import com.google.common.base.Preconditions;

public class Utils {

	public static BooleanFormula generalEqual(Formula f1, Formula f2, SolverContext ctx) {
		Preconditions.checkArgument(f1.getClass().equals(f2.getClass()),
				String.format("Formulas %s and %s have different types or are of unsupported type for generalEqual", f1, f2));
		Preconditions.checkArgument(f1 instanceof IntegerFormula || f1 instanceof BitvectorFormula, 
				"generalEqual inputs must be IntegerFormula or BitvectorFormula");  
		
		FormulaManager fmgr = ctx.getFormulaManager();
		if(f1 instanceof IntegerFormula) {
			// By the preconditions, f1 and f2 are guaranteed to be IntegerFormula
			return fmgr.getIntegerFormulaManager().equal((IntegerFormula)f1, (IntegerFormula)f2);
		} else {
			// By the preconditions, f1 and f2 are guaranteed to be BitvectorFormula
			return fmgr.getBitvectorFormulaManager().equal((BitvectorFormula)f1, (BitvectorFormula)f2);
		}
	}
	
    public static IntegerFormula convertToIntegerFormula(Formula f, SolverContext ctx) {
    	return f instanceof BitvectorFormula ? 
    			ctx.getFormulaManager().getBitvectorFormulaManager().toIntegerFormula((BitvectorFormula) f, false) : 
    			(IntegerFormula)f;
    }
}