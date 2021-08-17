package com.dat3m.dartagnan.program.utils;

import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

public class Utils {

	private static SolverContext defaultCtx;

	public static SolverContext getDefaultCtx() {
		if (defaultCtx == null) {
				try {
					Configuration config = Configuration.defaultConfiguration();
					defaultCtx = SolverContextFactory.createSolverContext(
							config,
							BasicLogManager.create(config),
							ShutdownManager.create().getNotifier(),
							SolverContextFactory.Solvers.Z3);
				} catch (Exception e) {
					e.printStackTrace();
				}
		}
		return defaultCtx;
	}


	public static BooleanFormula generalEqual(Formula f1, Formula f2, SolverContext ctx) {
		FormulaManager fmgr = ctx.getFormulaManager();
		if(f1 instanceof IntegerFormula && f2 instanceof IntegerFormula) {
			return fmgr.getIntegerFormulaManager().equal((IntegerFormula)f1, (IntegerFormula)f2);
		}
		if(f1 instanceof BitvectorFormula && f2 instanceof BitvectorFormula) {
			return fmgr.getBitvectorFormulaManager().equal((BitvectorFormula)f1, (BitvectorFormula)f2);
		}
		throw new RuntimeException(String.format("Formulas %s and %s have different types or are of unsupported type for generalEqual", f1, f2));
	}
	
    public static IntegerFormula convertToIntegerFormula(Formula f, SolverContext ctx) {
    	return f instanceof BitvectorFormula ? 
    			ctx.getFormulaManager().getBitvectorFormulaManager().toIntegerFormula((BitvectorFormula) f, false) : 
    			(IntegerFormula)f;
    }    
}
