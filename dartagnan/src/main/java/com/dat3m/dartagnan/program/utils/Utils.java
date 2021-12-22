package com.dat3m.dartagnan.program.utils;

import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import com.dat3m.dartagnan.parsers.program.exception.ExprTypeMismatchException;

public class Utils {

	public static BooleanFormula generalEqual(Formula f1, Formula f2, SolverContext ctx) {
		FormulaManager fmgr = ctx.getFormulaManager();
		if(f1 instanceof IntegerFormula && f2 instanceof IntegerFormula) {
			return fmgr.getIntegerFormulaManager().equal((IntegerFormula)f1, (IntegerFormula)f2);
		} else if(f1 instanceof BitvectorFormula && f2 instanceof BitvectorFormula) {
			return fmgr.getBitvectorFormulaManager().equal((BitvectorFormula)f1, (BitvectorFormula)f2);
		}
		throw new ExprTypeMismatchException(String.format("Formulas %s and %s have different types or are of unsupported type for generalEqual", f1, f2));
	}
	
    public static IntegerFormula convertToIntegerFormula(Formula f, SolverContext ctx) {
    	return f instanceof BitvectorFormula ? 
    			ctx.getFormulaManager().getBitvectorFormulaManager().toIntegerFormula((BitvectorFormula) f, false) : 
    			(IntegerFormula)f;
    }
}
