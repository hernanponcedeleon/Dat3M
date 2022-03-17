package com.dat3m.dartagnan.expression.utils;

import static com.dat3m.dartagnan.GlobalSettings.ARCH_PRECISION;

import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import com.google.common.base.Preconditions;

public class Utils {

	public static BooleanFormula generalEqual(Formula f1, Formula f2, SolverContext ctx) {
		Preconditions.checkArgument(f1 instanceof IntegerFormula || f1 instanceof BitvectorFormula, 
				"generalEqual inputs must be IntegerFormula or BitvectorFormula");  

		FormulaManager fmgr = ctx.getFormulaManager();
        // The boogie file might have a different type (Ints vs BVs) that the imposed by ARCH_PRECISION
        // In such cases we perform the transformation 
		return ARCH_PRECISION > -1 ? 
				fmgr.getBitvectorFormulaManager().equal(
						convertToBitvectorFormula(f1, ctx), 
						convertToBitvectorFormula(f2, ctx)) : 
        		fmgr.getIntegerFormulaManager().equal(
        				convertToIntegerFormula(f1, ctx), 
        				convertToIntegerFormula(f2, ctx));
	}
	
    private static IntegerFormula convertToIntegerFormula(Formula f, SolverContext ctx) {
    	return f instanceof BitvectorFormula ? 
    			ctx.getFormulaManager().getBitvectorFormulaManager().toIntegerFormula((BitvectorFormula) f, false) : 
    			(IntegerFormula)f;
    }

    private static BitvectorFormula convertToBitvectorFormula(Formula f, SolverContext ctx) {
    	return f instanceof BitvectorFormula ?
    			(BitvectorFormula)f :
    			ctx.getFormulaManager().getBitvectorFormulaManager().makeBitvector(ARCH_PRECISION, (IntegerFormula) f);
    }
}