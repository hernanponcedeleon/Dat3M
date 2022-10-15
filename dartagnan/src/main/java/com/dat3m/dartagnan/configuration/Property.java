package com.dat3m.dartagnan.configuration;

import java.util.Arrays;
import java.util.EnumSet;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.wmm.axiom.Axiom;

public enum Property implements OptionInterface {
	REACHABILITY, RACES, LIVENESS, CAT;
	
	// Used to display in UI
    @Override
    public String toString() {
        switch(this){
        	case REACHABILITY:
        		return "Reachability";
        	case RACES:
        		return "Races";
			case LIVENESS:
				return "Liveness";
			case CAT:
				return "CAT properties";
			default:
				throw new UnsupportedOperationException("Unrecognized property: " + this);
        }
    }

	public static EnumSet<Property> getDefault() {
		return EnumSet.of(REACHABILITY, CAT);
	}

	// Used to decide the order shown by the selector in the UI
	public static Property[] orderedValues() {
		Property[] order = { REACHABILITY, RACES, LIVENESS, CAT };
		// Be sure no element is missing
		assert(Arrays.asList(order).containsAll(Arrays.asList(values())));
		return order;
	}
	
	public BooleanFormula getSMTVariable(SolverContext ctx) {
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        return bmgr.makeVariable(this.toString());
	}

	public BooleanFormula getSMTVariable(Axiom ax, SolverContext ctx) {
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        return bmgr.makeVariable("Flag " + (ax.getName() != null ? ax.getName() : ax.getRelation().getNameOrTerm()));
	}
}