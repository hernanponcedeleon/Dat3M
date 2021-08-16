package com.dat3m.dartagnan.wmm.utils;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class Utils {

	public static BooleanFormula edge(String relName, Event e1, Event e2, SolverContext ctx) {
		FormulaManager fmgr = ctx.getFormulaManager();
		return fmgr.getBooleanFormulaManager().makeVariable(fmgr.escape(relName) + "(" + e1.repr() + "," + e2.repr() + ")");
	}

	public static BooleanFormula bindRegVal(Register register, Event w, Event r, SolverContext ctx){
		return ctx.getFormulaManager().getBooleanFormulaManager().makeVariable("BindRegVal(E" + w.getCId() + ",E" + r.getCId() + "," + register.getName() + ")");
	}

	public static IntegerFormula intVar(String relName, Event e, SolverContext ctx) {
		FormulaManager fmgr = ctx.getFormulaManager();
		return fmgr.getIntegerFormulaManager().makeVariable(fmgr.escape(relName) + "(" + e.repr() + ")");
	}
	
	public static IntegerFormula intCount(String relName, Event e1, Event e2, SolverContext ctx) {
		FormulaManager fmgr = ctx.getFormulaManager();
		return fmgr.getIntegerFormulaManager().makeVariable(fmgr.escape(relName) + "(" + e1.repr() + "," + e2.repr() + ")");
	}
}