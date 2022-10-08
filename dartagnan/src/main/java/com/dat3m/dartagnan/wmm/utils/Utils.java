package com.dat3m.dartagnan.wmm.utils;

import com.dat3m.dartagnan.program.event.core.Event;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import static com.dat3m.dartagnan.program.event.Tag.INIT;
import static com.dat3m.dartagnan.program.event.Tag.WRITE;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CO;
import static org.sosy_lab.java_smt.api.FormulaType.BooleanType;
import static org.sosy_lab.java_smt.api.FormulaType.IntegerType;

public class Utils {

	public static BooleanFormula edge(String relName, Event e1, Event e2, SolverContext ctx) {
		FormulaManager fmgr = ctx.getFormulaManager();
		return fmgr.makeVariable(BooleanType, fmgr.escape(relName) + "(" + e1.repr() + "," + e2.repr() + ")");
	}

	public static IntegerFormula intVar(String relName, Event e, SolverContext ctx) {
		FormulaManager fmgr = ctx.getFormulaManager();
		return fmgr.makeVariable(IntegerType, fmgr.escape(relName) + "(" + e.repr() + ")");
	}

	public static BooleanFormula cycleVar(String relName, Event e, SolverContext ctx) {
		FormulaManager fmgr = ctx.getFormulaManager();
		return fmgr.makeVariable(BooleanType, fmgr.escape(relName) + "-cycle(" + e.repr() + ")");
	}

	public static IntegerFormula coClockVar(Event write, SolverContext ctx) {
		Preconditions.checkArgument(write.is(WRITE), "Cannot get a clock-var for non-writes.");
		if (write.is(INIT)) {
			return ctx.getFormulaManager().getIntegerFormulaManager().makeNumber(0);
		}
		return intVar(CO, write, ctx);
	}
}